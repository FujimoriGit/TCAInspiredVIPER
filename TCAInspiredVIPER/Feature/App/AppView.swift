//
//  AppView.swift
//  TCAInspiredVIPER
//  
//  Created by Daiki Fujimori on 2025/06/16
//  

import SwiftUI

struct AppView: View {
    
    @Bindable private var store: StoreOf<AppFeature>
    @State private var pathStore: PathStore

    init(store: StoreOf<AppFeature>, pathStore: PathStore) {
        
        self.store = store
        self._pathStore = State(initialValue: pathStore)
    }

    var body: some View {
        NavigationStack(path: $pathStore.path) {
            LoginStackView(
                pathStore: pathStore,
                loginStore: store.scope(
                    state: \AppFeature.State.login,
                    action: { .login($0) },
                    feature: LoginFeature(router: LoginRouter(pathStore: pathStore))
                ),
                signUpStore: store.scope(
                    state: \AppFeature.State.signUp,
                    action: { .signUp($0) },
                    feature: SignUpFeature(router: SignUpRouter(pathStore: pathStore))
                )
            )
        }
    }
}
