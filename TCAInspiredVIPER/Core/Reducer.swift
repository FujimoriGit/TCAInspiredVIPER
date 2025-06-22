//
//  Reducer.swift
//  TCAInspiredVIPER
//
//  Created by Daiki Fujimori on 2025/06/01
//

@preconcurrency import Combine

/// 状態(`State`)をアクション(`Action`)に応じてどう変えるか、
/// また副作用（非同期処理や画面遷移など）を実行するかどうかを定めるプロトコル
protocol Reducer: Sendable {
    
    associatedtype State: Equatable
    associatedtype Action: Sendable
    
    /// `Effect`を返す純粋関数
    /// - Note: Reducerでは副作用を直接実行せず、`Effect`として返却します.
    /// 　　　　　実際の実行は`Effect.run(send:)`を通して明示的に行うことで、テスト性・予測可能性・集中管理を実現します.
    /// - Parameters:
    ///   - state: 画面や機能単位の状態データ
    ///   - action: ユーザー操作やシステムイベントなど、状態を変化させるきっかけ
    /// - Returns: 副作用の種類（`Effect`）
    func reduce(state: inout State, action: Action) -> Effect<Action>
}

@MainActor
struct Send<Action>: Sendable {
    
    let send: @MainActor @Sendable (Action) -> Void
    
    init(send: @escaping @MainActor @Sendable (Action) -> Void) {
        
        self.send = send
    }
}

/// 非同期処理や画面遷移などの副作用の種類を表現するための構造体
struct Effect<Action> {
    
    // MARK: - private property
    
    /// 副作用を実行するクロージャ
    /// 戻り値の`Task`で実行状態を追跡できるようにしている
    private let operation: (@Sendable @escaping (Action) -> Void) -> Task<Void, Never>
    
    // MARK: - initialize
    
    /// 初期化
    /// - Parameter operation: 実行時に使用される副作用処理クロージャ
    init(operation: @escaping (@Sendable @escaping (Action) -> Void) -> Task<Void, Never>) {
        
        self.operation = operation
    }
}

// MARK: - extension

extension Effect {
    
    /// 何も行わない空の`Effect`を返却する. （副作用なし）
    static var none: Self {
        
        .init { _ in Task {} }
    }
    
    /// 渡された`send`クロージャを使って、この`Effect`に含まれる副作用処理を実行する.
    /// - Parameter send: 処理結果として`Action`を外部に送信するためのクロージャ
    /// - Returns: 実行を表す`Task`
    @discardableResult
    func run(send: @Sendable @escaping (Action) -> Void) -> Task<Void, Never> {
        
        operation(send)
    }
    
    /// 非同期処理を表す`Effect`を返却する.
    /// - Parameter work: 非同期で実行される処理. 完了時に`Action`を返す.
    /// - Returns: 非同期タスクを実行する`Effect`
    static func task(_ work: @Sendable @escaping () async -> Action) -> Self {
        
        .init { send in
            
            Task {
                
                let action = await work()
                send(action)
            }
        }
    }
    
    /// 画面遷移を表す`Effect`を返却する.
    /// - Parameter route: 画面遷移処理
    /// - Returns: 遷移処理を実行する`Effect`
    static func navigation(_ route: @MainActor @escaping () -> Void) -> Effect<Action> {
        
        .init { _ in
            
            Task { @MainActor in
                
                route()
            }
        }
    }
    
    /// `Action`を変換する`Effect`を返却する.
    /// - Parameter transform: `Action`を別の型に変換するクロージャ
    /// - Returns: 変換後の`Effect`
    func map<B>(_ transform: @Sendable @escaping (Action) -> B) -> Effect<B> {
        
        .init { send in
            
            self.run { action in
                
                send(transform(action))
            }
        }
    }
    
    /// 複数の`Effect`をまとめて実行する`Effect`を返却する.
    /// - Parameter effects: 実行する`Effect`の配列
    /// - Returns: まとめて実行する`Effect`
    static func merge(_ effects: [Effect<Action>]) -> Effect<Action> {
        
        .init { send in
            
            let tasks = effects.map { effect in
                
                effect.run(send: send)
            }
            
            return Task {
                
                for task in tasks { _ = await task.value }
            }
        }
    }
    
    /// 可変長引数版の`merge`
    static func merge(_ effects: Effect<Action>...) -> Effect<Action> {
        
        merge(effects)
    }
}

// MARK: - AnyReducer

/// 型抹消したReducer
struct AnyReducer<State: Equatable, Action: Sendable>: Reducer {
    
    private let _reduce: @Sendable (inout State, Action) -> Effect<Action>
    
    init<R: Reducer>(_ reducer: R) where R.State == State, R.Action == Action {
        
        self._reduce = reducer.reduce
    }
    
    func reduce(state: inout State, action: Action) -> Effect<Action> {
        
        _reduce(&state, action)
    }
}

// MARK: - CombineReducers

/// 複数のReducerを組み合わせる
struct CombineReducers<State: Equatable, Action: Sendable>: Reducer {
    
    private let reducers: [AnyReducer<State, Action>]
    
    init(_ reducers: [AnyReducer<State, Action>]) {
        
        self.reducers = reducers
    }
    
    func reduce(state: inout State, action: Action) -> Effect<Action> {
        
        let effects = reducers.map { reducer in
            
            reducer.reduce(state: &state, action: action)
        }
        
        return .merge(effects)
    }
}

// MARK: - PullbackReducer

/// 子Reducerを親の状態/アクションで扱えるようにする
struct PullbackReducer<Local: Reducer, ParentState: Equatable, ParentAction>: Reducer {
    
    typealias State = ParentState
    typealias Action = ParentAction
    
    let local: Local
    let state: WritableKeyPath<ParentState, Local.State> & Sendable
    let extract: @Sendable (ParentAction) -> Local.Action?
    let embed: @Sendable (Local.Action) -> ParentAction
    
    func reduce(state parentState: inout ParentState, action parentAction: ParentAction) -> Effect<ParentAction> {
        
        guard let localAction = extract(parentAction) else {
            
            return .none
        }
        
        let effect = local.reduce(state: &parentState[keyPath: state], action: localAction)
        
        return effect.map(embed)
    }
}

// MARK: - Reducer Utility Extensions

extension Reducer {
    
    /// `AnyReducer`へ変換する
    func eraseToAnyReducer() -> AnyReducer<State, Action> {
        
        AnyReducer(self)
    }
    
    /// 子Reducerを親の状態/アクションに変換する
    func pullback<ParentState, ParentAction>(
        state: WritableKeyPath<ParentState, State> & Sendable,
        action extract: @escaping @Sendable (ParentAction) -> Action?,
        toParentAction embed: @escaping @Sendable (Action) -> ParentAction
    ) -> AnyReducer<ParentState, ParentAction> {
        
        AnyReducer(
            PullbackReducer(
                local: self,
                state: state,
                extract: extract,
                embed: embed
            )
        )
    }
}

// MARK: - global method

/// Reducerを結合する
func combine<State: Equatable, Action: Sendable>(_ reducers: AnyReducer<State, Action>...) -> AnyReducer<State, Action> {
    
    AnyReducer(CombineReducers(reducers))
}
