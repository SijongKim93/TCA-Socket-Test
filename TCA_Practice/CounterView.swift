//
//  ContentView.swift
//  TCA_Practice
//
//  Created by SiJongKim on 9/11/25.
//

import SwiftUI
import ComposableArchitecture

struct CounterView: View {
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 20) {
                Text("Count: \(store.count)")
                    .font(.largeTitle)
                
                HStack(spacing: 20) {
                    Button("-") {
                        store.send(.decrementButtonTapped)
                    }
                    .font(.title)
                    
                    Button("+") {
                        store.send(.incrementButtonTapped)
                    }
                    .font(.title)
                }
                
                Button("Reset") {
                    store.send(.resetButtonTapped)
                }
                .font(.title)
            }
            .padding()
        }
    }
}

