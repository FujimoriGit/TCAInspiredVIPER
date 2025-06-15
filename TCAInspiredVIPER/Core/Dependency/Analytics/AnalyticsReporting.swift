//
//  AnalyticsReporting.swift
//  TCAInspiredVIPER
//  
//  Created by Daiki Fujimori on 2025/06/15
//

protocol AnalyticsReporting {

    func log(event: String)
}

extension AnalyticsReporting {
    
    func log(event: String) {
        
        print("Analytics log: \(event)")
    }
}
