//
//  LoginInteractorTests.swift
//  TCAInspiredVIPERTests
//
//  Created by Daiki Fujimori on 2025/06/07
//

import Testing
@testable import TCAInspiredVIPER

struct LoginInteractorTests {

    @MainActor
    @Test func testLoginEffectReturnsSuccess() async throws {

        let context = LoginContext(dependency: .mock)
        let effect = LoginInteractor.loginEffect(context: context,
                                                 email: "test@example.com",
                                                 password: "password")
        var result: LoginFeature.Action?
        effect.run { action in
            result = action
        }
        try await Task.sleep(nanoseconds: 1_100_000_000)
        #expect(result == .loginSucceeded(User(id: 1, name: "Sample User")))
    }
}
