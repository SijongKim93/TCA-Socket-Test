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
            TextChangeView(
                store: Store(
                    initialState: TextChangeFeature.State(text: "Hello world"),
                    reducer: {
                        TextChangeFeature()
                    }
                )
            )
        }
    }
}
