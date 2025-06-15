//
//  LoginInteractorTests.swift
//  TCAInspiredVIPERTests
//
//  Created by Daiki Fujimori on 2025/06/07
//

import XCTest
@testable import TCAInspiredVIPER

final class LoginInteractorTests: XCTestCase {

    func testLoginEffectReturnsSuccess() async throws {
        
        // モックの設定
        let mockContext = LoginContext(authenticate: { email, password in
            XCTAssertEqual(email, "test@example.com")
            XCTAssertEqual(password, "password")
            return User(id: 1, name: "Sample User")
        })

        let effect = LoginInteractor.loginEffect(context: mockContext,
                                                 email: "test@example.com",
                                                 password: "password")
        
        let receivedAction = try await withCheckedThrowingContinuation { continuation in
            effect.run { action in
                continuation.resume(returning: action)
            }
        }
        
        // 結果の検証
        XCTAssertEqual(receivedAction, .loginSucceeded(User(id: 1, name: "Sample User")))
    }
}
