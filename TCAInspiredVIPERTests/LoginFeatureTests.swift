//
//  LoginFeatureTests.swift
//  TCAInspiredVIPERTests
//
//  Created by Daiki Fujimori on 2025/06/07
//

import Testing
@testable import TCAInspiredVIPER

struct LoginFeatureTests {

    @MainActor
    @Test func testLoginSuccessNavigatesToHome() async throws {
        let pathStore = PathStore()
        let router = LoginRouter(pathStore: pathStore)
        let feature = LoginFeature(router: router)
        let store = DependencyValues.withDependency { value in
            
            value.loginContext = .init(authenticate: { _, _ in
                
                do {
                    
                    try await Task.sleep(nanoseconds: 1_000_000_000)
                    return User(id: 1, name: "Sample User")
                } catch {
                    
                    throw error
                }
            })
        } operation:  {
            
            StoreOf<LoginFeature>(initialState: .init(), feature: feature)
        }

        store.send(.emailChanged("test@example.com"))
        store.send(.passwordChanged("password"))
        store.send(.loginButtonTapped)

        // Wait for async effect
        try await Task.sleep(nanoseconds: 1_100_000_000)

        #expect(store.state.isLoading == false)
    }
}
