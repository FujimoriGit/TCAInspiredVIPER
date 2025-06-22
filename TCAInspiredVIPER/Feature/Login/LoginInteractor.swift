//
//  LoginInteractor.swift
//  TCAInspiredVIPER
//
//  Created by Daiki Fujimori on 2025/06/01
//

/// Business logic for login
enum LoginInteractor {}

// MARK: - static method

extension LoginInteractor {

    static func loginEffect(context: LoginContext,
                            email: String,
                            password: String) -> Effect<LoginFeature.Action> {
        .task {
            
            do {
                
                let user = try await login(context: context,
                                            email: email,
                                            password: password)
                
                return .loginSucceeded(user)
            } catch {
                
                return .loginFailed(.invalidCredentials)
            }
        }
    }
}

// MARK: - private method

private extension LoginInteractor {

    static func login(context: LoginContext,
                      email: String,
                      password: String) async throws -> User {
        
        context.log(event: "login_attempt")
        return try await context.authenticate(email, password)
    }
}
