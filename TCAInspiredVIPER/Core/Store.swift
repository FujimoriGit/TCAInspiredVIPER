//
//  Store.swift
//  TCAInspiredVIPER
//  
//  Created by Daiki Fujimori on 2025/06/01
//  

import Observation

/// 画面の状態を管理するクラス
@MainActor
@Observable
final class StoreOf<Feature: Reducer> {
    
    // MARK: - private properties
    
    fileprivate(set) var state: Feature.State {
        
        didSet {
            
            stateUpdater?(state)
        }
    }
    private let feature: Feature
    private var sendAction: @MainActor @Sendable (Feature.Action) -> Void
    private var stateUpdater: ((Feature.State) -> Void)?
    
    // MARK: - initialize
    
    init(initialState: Feature.State,
         feature: Feature,
         send: @escaping @MainActor @Sendable (Feature.Action) -> Void,
         update: ((Feature.State) -> Void)?) {
        
        self.state = initialState
        self.feature = feature
        self.sendAction = send
        self.stateUpdater = update
    }
    
    convenience init(initialState: Feature.State, feature: Feature) {
        
        self.init(initialState: initialState,
                  feature: feature,
                  send: { _ in },
                  update: nil)
        
        self.sendAction = { [weak self] action in
            
            guard let self else { return }
            self.send(action)
        }
    }
}

// MARK: - public method

extension StoreOf {
    
    @discardableResult
    func send(_ action: Feature.Action) -> Task<Void, Never> {
        
        let effect = feature.reduce(state: &state, action: action)
        
        return effect.run { [weak self] action in
            
            guard let self else { return }
            
            Task { @MainActor in
                
                self.sendAction(action)
            }
        }
    }

    func scope<Child: Reducer>(
            state keyPath: WritableKeyPath<Feature.State, Child.State>,
            action transform: @escaping @Sendable (Child.Action) -> Feature.Action,
            feature: Child
        ) -> StoreOf<Child> {
            
            let childStore = StoreOf<Child>(
                initialState: self.state[keyPath: keyPath],
                feature: feature,
                send: { [weak self] childAction in
                    
                    self?.send(transform(childAction))
                },
                update: { [weak self] childState in
                    
                    self?.state[keyPath: keyPath] = childState
                }
            )

            let parentUpdater = stateUpdater
            stateUpdater = { [weak childStore] newState in
                
                childStore?.state = newState[keyPath: keyPath]
                parentUpdater?(newState)
            }

            return childStore
        }
}
