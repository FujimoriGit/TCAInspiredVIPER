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
            // TODO: Binding時のAction
            TextField("Email", text: $store.state.email)
            SecureField("Password", text: $store.state.password)
            Toggle("Agree to Terms", isOn: $store.state.agreedToTerms)
            Button("Sign Up") {
                
                store.send(.submit)
            }
            .disabled(!store.state.agreedToTerms)
        }
    }
}
