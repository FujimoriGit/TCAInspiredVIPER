//
//  SignUpFeature.swift
//  TCAInspiredVIPER
//  
//  Created by Daiki Fujimori on 2025/06/01
//  

struct SignUpFeature {
    
    // MARK: - private property
    
    private let router: SignUpWireframe
    
    // MARK: - initialize
    
    init(router: SignUpWireframe) {
        
        self.router = router
    }
}

// MARK: - extension (for implements Reducer)

extension SignUpFeature: Reducer {
    
    typealias State = SignUpState
    typealias Action = SignUpAction
    
    func reduce(state: inout State, action: Action) -> Effect<Action> {
        
        switch action {
            
        case .toggleAgreement(let agreed):
            state.agreedToTerms = agreed
            return .none
            
        case .submit:
            guard state.agreedToTerms else { return .none }
            return .navigation { router.navigate(to: .confirm) }
        }
    }
}
