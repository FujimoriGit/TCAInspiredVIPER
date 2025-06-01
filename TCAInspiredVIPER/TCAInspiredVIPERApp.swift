//
//  TCAInspiredVIPERApp.swift
//  TCAInspiredVIPER
//  
//  Created by Daiki Fujimori on 2025/06/01
//  


import SwiftUI

@main
struct TCAInspiredVIPERApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView(store: makeLoginStore())
        }
    }
}

// MARK: - private method

private extension TCAInspiredVIPERApp {
    
    /// ログイン画面用のStoreを作成します.
    /// - Returns: LoginStore
    func makeLoginStore() -> StoreOf<LoginFeature> {
        
        // TODO: とりあえずモックを使用している
        let dependencies = MockLoginContext()
        let router = LoginRouter()
        
        let feature = LoginFeature(
            context: dependencies,
            router: router
        )
        
        return StoreOf<LoginFeature>(initialState: LoginState(),
                                     feature: feature)
    }
}
