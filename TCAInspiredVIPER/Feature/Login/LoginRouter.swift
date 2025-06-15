//
//  LoginRouter.swift
//  TCAInspiredVIPER
//  
//  Created by Daiki Fujimori on 2025/06/01
//  

import SwiftUI

struct LoginRouter: AppWireframe {
    
    enum LoginRoute: Hashable {
        
        case home
        case signUp
        case forgotPassword
    }
    
    private let pathStore: PathStore
    
    init(pathStore: PathStore) {
        
        self.pathStore = pathStore
    }
    
    func navigate(to route: LoginRoute) {
        
        pathStore.path.append(route)
    }
}
