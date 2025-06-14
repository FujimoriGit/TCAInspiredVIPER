//
//  AppDependency.swift
//  TCAInspiredVIPER
//
//  Created by Daiki Fujimori on 2025/06/07
//

/// App wide dependencies passed into each feature context.
struct AppDependency {

    let authAPI: Authenticating
    let analytics: AnalyticsReporting

    static var mock: AppDependency {

        .init(authAPI: MockAuthAPI(), analytics: MockAnalyticsService())
    }
}

/// Authentication API interface
protocol Authenticating {

    func authenticate(email: String, password: String) async throws -> User
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

/// Analytics interface
protocol AnalyticsReporting {

    func log(event: String)
}

// MARK: - mocks

struct MockAuthAPI: Authenticating {

    func authenticate(email: String, password: String) async throws -> User {
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return User(id: 1, name: "Sample User")
        } catch {
            throw error
        }
    }
}

struct MockAnalyticsService: AnalyticsReporting {

    func log(event: String) {
        print("Analytics log: \(event)")
    }
}
