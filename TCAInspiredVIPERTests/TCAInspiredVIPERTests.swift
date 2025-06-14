//
//  TCAInspiredVIPERTests.swift
//  TCAInspiredVIPERTests
//  
//  Created by Daiki Fujimori on 2025/06/01
//  


import Testing
@testable import TCAInspiredVIPER

struct TCAInspiredVIPERTests {

    @Test func testPathStoreStartsEmpty() async throws {

        let store = PathStore()
        #expect(store.path.isEmpty)
    }

}
