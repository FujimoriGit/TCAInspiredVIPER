//
//  PathStore.swift
//  TCAInspiredVIPER
//  
//  Created by Daiki Fujimori on 2025/06/01
//  

import Observation
import SwiftUI

@MainActor
@Observable
final class PathStore {
    
    var path = NavigationPath()
}

@MainActor
protocol AppWireframe: Sendable {
    
    associatedtype Route: Hashable
    
    func navigate(to route: Route)
}
