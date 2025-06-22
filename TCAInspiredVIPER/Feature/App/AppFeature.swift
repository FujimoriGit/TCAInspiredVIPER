//
//  AppFeature.swift
//  TCAInspiredVIPER
//  
//  Created by Daiki Fujimori on 2025/06/16
//  

import Foundation

struct AppFeature {
    
    private let reducer: AnyReducer<State, Action>

    @MainActor
    init(pathStore: PathStore) {
        
        let login = LoginFeature(router: LoginRouter(pathStore: pathStore))
            .pullback(state: \State.login,
                      action: { action -> LoginFeature.Action? in
                
                guard case .login(let action) = action else { return nil }
                return action
            },
                      toParentAction: Action.login)
        let signUp = SignUpFeature(router: SignUpRouter(pathStore: pathStore))
            .pullback(state: \State.signUp,
                      action: { action -> SignUpFeature.Action? in
                
                guard case .signUp(let action) = action else { return nil }
                return action
            },
                      toParentAction: Action.signUp)
        
        self.reducer = combine(login, signUp)
    }
}

extension AppFeature: Reducer {
    
    struct State: Equatable {
        
        var login = LoginFeature.State()
        var signUp = SignUpFeature.State()
    }

    enum Action: Equatable {
        
        case login(LoginFeature.Action)
        case signUp(SignUpFeature.Action)
    }

    func reduce(state: inout State, action: Action) -> Effect<Action> {
        
        reducer.reduce(state: &state, action: action)
    }
}
