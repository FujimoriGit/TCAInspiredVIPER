//
//  SignUpFeature.swift
//  TCAInspiredVIPER
//  
//  Created by Daiki Fujimori on 2025/06/01
//  

struct SignUpFeature {
    
    // MARK: - private property
    
    private let router: SignUpRouter
    
    // MARK: - initialize
    
    init(router: SignUpRouter) {
        
        self.router = router
    }
}

// MARK: - extension (for implements Reducer)

extension SignUpFeature: Reducer {
    
    // MARK: - State definition
    
    struct State: Equatable {
        
        var email = ""
        var password = ""
        var agreedToTerms = false
    }
    
    // MARK: - Action definition
    
    enum Action: Equatable {
        
        case emailChanged(String)
        case passwordChanged(String)
        case toggleAgreement(Bool)
        case submit
    }
    
    // MARK: - reduce definition
    
    func reduce(state: inout State, action: Action) -> Effect<Action> {
        
        switch action {
            
        case .emailChanged(let email):
            state.email = email
            return .none
            
        case .passwordChanged(let password):
            state.password = password
            return .none
            
        case .toggleAgreement(let agreed):
            state.agreedToTerms = agreed
            return .none
            
        case .submit:
            guard state.agreedToTerms else { return .none }
            return .navigation { router.navigate(to: .confirm) }
        }
    }
}
