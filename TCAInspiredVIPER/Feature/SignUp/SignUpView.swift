//
//  SignUpView.swift
//  TCAInspiredVIPER
//  
//  Created by Daiki Fujimori on 2025/06/01
//  

import SwiftUI

struct SignUpView: View {
    
    // MARK: - private property
    
    @Bindable private var store: StoreOf<SignUpFeature>
    
    // MARK: - initialize
    
    init(store: StoreOf<SignUpFeature>) {
        
        self.store = store
    }

    // MARK: - body
    
    var body: some View {
        Form {
            TextField("Email", text: Binding(
                get: { store.state.email },
                set: { store.send(.emailChanged($0)) }))
            SecureField("Password", text: Binding(
                get: { store.state.password },
                set: { store.send(.passwordChanged($0)) }))
            Toggle("Agree to Terms", isOn: Binding(
                get: { store.state.agreedToTerms },
                set: { store.send(.toggleAgreement($0)) }))
            Button("Sign Up") {
                
                store.send(.submit)
            }
            .disabled(!store.state.agreedToTerms)
        }
    }
}
