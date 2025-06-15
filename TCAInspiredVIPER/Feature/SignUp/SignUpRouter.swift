//
//  SignUpRouter.swift
//  TCAInspiredVIPER
//  
//  Created by Daiki Fujimori on 2025/06/01
//  

import SwiftUI

struct SignUpRouter: AppWireframe {
    
    enum SignUpRoute: Hashable {
        
        case terms
        case confirm
    }
    
    private let pathStore: PathStore

    init(pathStore: PathStore) {
        
        self.pathStore = pathStore
    }

    func navigate(to route: SignUpRoute) {
        
        pathStore.path.append(route)
    }
}
