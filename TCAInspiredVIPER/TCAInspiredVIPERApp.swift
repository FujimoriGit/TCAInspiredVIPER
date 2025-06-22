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
    
    @State private var pathStore: PathStore
    private let store: StoreOf<AppFeature>
    
    // MARK: - initialize
    
    init() {
        
        let pathStore = PathStore()
        self._pathStore = State(initialValue: pathStore)
        self.store = StoreOf<AppFeature>(initialState: .init(),
                                         feature: AppFeature(pathStore: pathStore))
    }
    
    // MARK: - body
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $pathStore.path) {
                AppView(store: store, pathStore: pathStore)
            }
        }
    }
}
