//
//  LoginInteractor.swift
//  TCAInspiredVIPER
//  
//  Created by Daiki Fujimori on 2025/06/01
//  

/// ビジネスロジック
enum LoginInteractor {
    
    static func login(context: LoginContext,
                      email: String,
                      password: String) async throws -> User {
        
        context.analytics.log(event: "login_attempt")
        return try await context.authAPI.authenticate(email: email, password: password)
    }
}
