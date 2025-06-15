//
//  LoginContext.swift
//  TCAInspiredVIPER
//  
//  Created by Daiki Fujimori on 2025/06/15
//  

struct LoginContext: AnalyticsReporting {
    
    let authenticate: @Sendable (_ email: String, _ password: String) async throws -> User
}

extension LoginContext: DependencyKey {
    
    static var liveValue: LoginContext {
        
        .init(authenticate: { _, _ in
            
            do {
                
                try await Task.sleep(nanoseconds: 1_000_000_000)
                return User(id: 1, name: "Sample User")
            } catch {
                
                throw error
            }
        })
    }
}

extension DependencyValues {
    
    var loginContext: LoginContext {
        
        get { self[LoginContext.self] }
        set { self[LoginContext.self] = newValue }
    }
}

struct User: Equatable {

    let id: Int
    let name: String
}

enum LoginError: Error, Equatable {
    
    case invalidCredentials
    case networkError(String)
    
    var localizedDescription: String {
        
        switch self {
            
        case .invalidCredentials:
            return "Invalid email or password."
            
        case .networkError(let message):
            return "Network error: \(message)"
        }
    }
}
