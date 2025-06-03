//
//  Reducer.swift
//  TCAInspiredVIPER
//  
//  Created by Daiki Fujimori on 2025/06/01
//  

/// 状態(`State`)をアクション(`Action`)に応じてどう変えるか、
/// また副作用（非同期処理や画面遷移など）を実行するかどうかを定めるプロトコル
protocol Reducer {
    
    associatedtype State: Equatable
    associatedtype Action
    
    /// `Effect`を返す純粋関数
    /// - Note: Reducerでは副作用を直接実行せず、`Effect`として返却します.
    /// 　　　　　実際の実行は`Effect.run(send:)`を通して明示的に行うことで、テスト性・予測可能性・集中管理を実現します.
    /// - Parameters:
    ///   - state: 画面や機能単位の状態データ
    ///   - action: ユーザー操作やシステムイベントなど、状態を変化させるきっかけ
    /// - Returns: 副作用の種類（`Effect`）
    func reduce(state: inout State, action: Action) -> Effect<Action>
}

/// 非同期処理や画面遷移などの副作用の種類を表現するための構造体
struct Effect<Action> {
    
    // MARK: - private property
    
    /// 副作用を実行するクロージャ
    private let operation: (@escaping (Action) -> Void) -> Void
    
    // MARK: - initialize
    
    /// 初期化
    /// - Parameter operation: 実行時に使用される副作用処理クロージャ
    init(operation: @escaping (@escaping (Action) -> Void) -> Void) {
        
        self.operation = operation
    }
}

// MARK: - extension

extension Effect {
    
    /// 渡された`send`クロージャを使って、この`Effect`に含まれる副作用処理を実行する.
    /// - Parameter send: 処理結果として`Action`を外部に送信するためのクロージャ
    func run(send: @escaping (Action) -> Void) {
        
        operation(send)
    }
    
    /// 何も行わない空の`Effect`を返却する. （副作用なし）
    static var none: Effect<Action> {
        
        .init { _ in }
    }
    
    /// 非同期処理を表す`Effect`を返却する.
    /// - Parameter work: 非同期で実行される処理. 完了時に`Action`を返す.
    /// - Returns: 非同期タスクを実行する`Effect`
    static func task(_ work: @escaping () async -> Action) -> Effect<Action> {
        
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
    static func navigation(_ route: @escaping () -> Void) -> Effect<Action> {
        
        .init { _ in route() }
    }
}
