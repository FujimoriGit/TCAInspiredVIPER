//
//  SignUpFeatureTests.swift
//  TCAInspiredVIPERTests
//
//  Created by Daiki Fujimori on 2025/06/07
//

import Testing
@testable import TCAInspiredVIPER

struct SignUpFeatureTests {

    @MainActor
    @Test func testSubmitNavigatesWhenAgreed() async throws {
        let pathStore = PathStore()
        let router = SignUpRouter(pathStore: pathStore)
        let feature = SignUpFeature(router: router)
        let store = StoreOf<SignUpFeature>(initialState: .init(), feature: feature)

        store.send(.toggleAgreement(true))
        store.send(.submit)

        #expect(pathStore.path.count == 1)
    }
}
