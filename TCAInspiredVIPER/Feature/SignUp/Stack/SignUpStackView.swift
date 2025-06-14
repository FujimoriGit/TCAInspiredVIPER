//
//  SignUpStackView.swift
//  TCAInspiredVIPER
//  
//  Created by Daiki Fujimori on 2025/06/01
//  

import SwiftUI

/// サインアップ画面のstackを制御するView
struct SignUpStackView: View {
    
    // MARK: - private property
    
    @State private var pathStore: PathStore
    
    // MARK: - initialize
    
    init(pathStore: PathStore) {
        
        self.pathStore = pathStore
    }

    // MARK: - body
    
    var body: some View {
        SignUpView(store: makeSignUpStore(router: SignUpRouter(pathStore: pathStore)))
            .navigationDestination(for: SignUpRouter.SignUpRoute.self) { route in
                
                switch route {
                    
                case .terms:
                    Text("Terms and Conditions")
                    
                case .confirm:
                    Text("Confirm Sign Up")
                }
            }
    }
}

// MARK: - private method

private extension SignUpStackView {
    
    func makeSignUpStore(router: SignUpRouter) -> StoreOf<SignUpFeature> {

        let feature = SignUpFeature(router: router)
        return StoreOf<SignUpFeature>(initialState: .init(), feature: feature)
    }
}
