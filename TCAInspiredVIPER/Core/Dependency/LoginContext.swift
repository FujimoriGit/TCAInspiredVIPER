//
//  LoginContext.swift
//  TCAInspiredVIPER
//  
//  Created by Daiki Fujimori on 2025/06/01
//  

// MARK: - context

/// 依存の抽象化と注入を簡潔に管理するためのプロトコル
protocol LoginContext {
    
    var authAPI: Authenticating { get }
    var analytics: AnalyticsReporting { get }
}

/// 認証IF
protocol Authenticating {
    
    func authenticate(email: String, password: String) async throws -> User
}

struct User: Equatable {
    
    let id: Int
    let name: String
}

/// ロギングIF
protocol AnalyticsReporting {
    
    func log(event: String)
}

// MARK: - mock

struct MockLoginContext: LoginContext {
    
    var authAPI: Authenticating = MockAuthAPI()
    var analytics: AnalyticsReporting = MockAnalyticsService()
}

struct MockAuthAPI: Authenticating {
    
    func authenticate(email: String, password: String) async throws -> User {
        
        do {
            // 1秒遅延して成功を返す
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return User(id: 1, name: "Sample User")
        }
        catch {
            
            throw error
        }
    }
}

struct MockAnalyticsService: AnalyticsReporting {
    
    func log(event: String) {
        
        print("Analytics log: \(event)")
    }
}
