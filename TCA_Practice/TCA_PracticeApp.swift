//
//  TCA_PracticeApp.swift
//  TCA_Practice
//
//  Created by SiJongKim on 9/11/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct CounterApp: App {
    var body: some Scene {
        WindowGroup {
            ChatView(
                store: Store(
                    initialState: ChatFeature.State(isConnected: false),
                    reducer: {
                        ChatFeature()
                    }
                )
            )
        }
    }
}
