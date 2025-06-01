//
//  LoginAction.swift
//  TCAInspiredVIPER
//  
//  Created by Daiki Fujimori on 2025/06/01
//  

enum LoginAction {
    
    case emailChanged(String)
    case passwordChanged(String)
    case loginButtonTapped
    case loginSucceeded(User)
    case loginFailed(Error)
    case signUpTapped
    case forgotPasswordTapped
}

struct User: Equatable {
    
    let id: Int
    let name: String
}
