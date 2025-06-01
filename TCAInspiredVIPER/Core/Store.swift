//
//  Store.swift
//  TCAInspiredVIPER
//  
//  Created by Daiki Fujimori on 2025/06/01
//  

import Observation


/// 画面の状態を管理する基底クラス
@MainActor
@Observable
final class StoreOf<Feature: Reducer> {
    
    var state: Feature.State
    private let feature: Feature

    init(initialState: Feature.State, feature: Feature) {
        
        self.state = initialState
        self.feature = feature
    }

    func send(_ action: Feature.Action) {
        
        let effect = feature.reduce(state: &state, action: action)
        effect.run(send: self.send)
    }
}
