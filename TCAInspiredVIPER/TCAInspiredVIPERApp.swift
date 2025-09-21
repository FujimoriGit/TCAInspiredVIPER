//
//  TCAInspiredVIPERApp.swift
//  TCAInspiredVIPER
//  
//  Created by Daiki Fujimori on 2025/06/01
//  


import SwiftUI

@main
struct TCAInspiredVIPERApp: App {
    
    // MARK: - private property
    
    @State private var pathStore = PathStore()
    
    // MARK: - body
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $pathStore.path) {
                LoginStackView(pathStore: pathStore)
            }
        }
    }
}
