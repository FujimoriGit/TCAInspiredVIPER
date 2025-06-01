//
//  LoginView.swift
//  TCAInspiredVIPER
//  
//  Created by Daiki Fujimori on 2025/06/01
//  

import SwiftUI

struct LoginView: View {
    
    // MARK: - private property
    
    @Bindable private var store: StoreOf<LoginFeature>
    
    // MARK: - initialize
    
    init(store: StoreOf<LoginFeature>) {
        
        self.store = store
    }
    
    // MARK: - body
    
    var body: some View {
        
        VStack(spacing: 16) {
            TextField("Email", text: Binding(
                get: { store.state.email },
                set: { store.send(.emailChanged($0)) }
            ))
            .textFieldStyle(.roundedBorder)
            
            SecureField("Password", text: Binding(
                get: { store.state.password },
                set: { store.send(.passwordChanged($0)) }
            ))
            .textFieldStyle(.roundedBorder)
            
            if store.state.isLoading {
                
                ProgressView()
            } else {
                
                Button("Login") {
                    
                    store.send(.loginButtonTapped)
                }
            }
            
            if let error = store.state.error {
                
                Text(error).foregroundColor(.red)
            }
            
            HStack {
                Button("Sign Up") {
                    store.send(.signUpTapped)
                }
                Spacer()
                Button("Forgot Password?") {
                    store.send(.forgotPasswordTapped)
                }
            }
            .padding(.top, 16)
        }
        .padding()
    }
}
