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
    
    // MARK: - initialize
    
    init(pathStore: PathStore) {
        
        self.pathStore = pathStore
    }

    // MARK: - body
    
    var body: some View {
        LoginView(store: makeLoginStore(router: LoginRouter(pathStore: pathStore)))
            .navigationDestination(for: LoginRouter.LoginRoute.self) { route in
                
                switch route {
                    
                case .home:
                    Text("home")
                    
                case .signUp:
                    // TODO: EnvironmentObjectにした方がいい？
                    SignUpStackView(pathStore: pathStore)
                    
                case .forgotPassword:
                    Text("forgotPassword")
                }
            }
    }
}

// MARK: - private method

private extension LoginStackView {
    
    /// ログイン画面用のStoreを作成します.
    /// - Returns: LoginStore
    func makeLoginStore(router: LoginRouter) -> StoreOf<LoginFeature> {

        let feature = LoginFeature(router: router)
        
        return StoreOf<LoginFeature>(initialState: .init(),
                                     feature: feature)
    }
}
