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
    
    @Bindable private var signUpStore: StoreOf<SignUpFeature>
    
    // MARK: - initialize
    
    init(pathStore: PathStore,
         signUpStore: StoreOf<SignUpFeature>) {
        
        self.pathStore = pathStore
        self.signUpStore = signUpStore
    }

    // MARK: - body
    
    var body: some View {
        SignUpView(store: signUpStore)
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
