//
//  LoginRouter.swift
//  TCAInspiredVIPER
//  
//  Created by Daiki Fujimori on 2025/06/01
//  

enum LoginRoute {
    
    case home
    case signUp
    case forgotPassword
}

protocol LoginWireframe {
    
    func navigate(to route: LoginRoute)
}

final class LoginRouter: LoginWireframe {
    
    func navigate(to route: LoginRoute) {
        
        switch route {
            
        case .home:
            print("Navigate to Home")
            
        case .signUp:
            print("Navigate to SignUp")
            
        case .forgotPassword:
            print("Navigate to ForgotPassword")
        }
    }
}
