//
//  SignUpRouter.swift
//  TCAInspiredVIPER
//  
//  Created by Daiki Fujimori on 2025/06/01
//  

import SwiftUI

enum SignUpRoute: Hashable {
    
    case terms
    case confirm
}

protocol SignUpWireframe {
    
    func navigate(to route: SignUpRoute)
}

final class SignUpRouter: SignUpWireframe {
    
    private let pathStore: PathStore

    init(pathStore: PathStore) {
        
        self.pathStore = pathStore
    }

    func navigate(to route: SignUpRoute) {
        
        pathStore.path.append(route)
    }
}
