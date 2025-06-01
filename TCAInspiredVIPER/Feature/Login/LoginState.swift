//
//  LoginState.swift
//  TCAInspiredVIPER
//  
//  Created by Daiki Fujimori on 2025/06/01
//  

struct LoginState: Equatable {
    
    var email: String = ""
    var password: String = ""
    var isLoading: Bool = false
    var error: String?
}
