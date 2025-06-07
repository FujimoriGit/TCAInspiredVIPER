//
//  LoginInteractor.swift
//  TCAInspiredVIPER
//
//  Created by Daiki Fujimori on 2025/06/01
//

/// Business logic for login
enum LoginInteractor {

}

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
                return .loginFailed(error)
            }
        }
    }
}

private extension LoginInteractor {

    static func login(context: LoginContext,
                      email: String,
                      password: String) async throws -> User {
        context.dependency.analytics.log(event: "login_attempt")
        return try await context.dependency.authAPI.authenticate(email: email,
                                                                password: password)
    }
}
