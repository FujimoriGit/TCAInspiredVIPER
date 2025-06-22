//
//  LoginStackView.swift
//  TCAInspiredVIPER
//  
//  Created by Daiki Fujimori on 2025/06/01
//  

import SwiftUI

/// ログイン画面のstackを制御するView
struct LoginStackView: View {
    
    // MARK: - private property
    
    @State private var pathStore: PathStore
    
    @Bindable private var loginStore: StoreOf<LoginFeature>
    @Bindable private var signUpStore: StoreOf<SignUpFeature>
    
    // MARK: - initialize
    
    init(pathStore: PathStore,
         loginStore: StoreOf<LoginFeature>,
         signUpStore: StoreOf<SignUpFeature>) {
        
        self.pathStore = pathStore
        self.loginStore = loginStore
        self.signUpStore = signUpStore
    }

    // MARK: - body
    
    var body: some View {
        LoginView(store: loginStore)
            .navigationDestination(for: LoginRouter.LoginRoute.self) { route in
                
                switch route {
                    
                case .home:
                    Text("home")
                    
                case .signUp:
                    SignUpStackView(pathStore: pathStore,
                                    signUpStore: signUpStore)
                    
                case .forgotPassword:
                    Text("forgotPassword")
                }
            }
    }
}
