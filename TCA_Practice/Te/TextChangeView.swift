//
//  TextChangeView.swift
//  TCA_Practice
//
//  Created by 김시종 on 9/14/25.
//

import SwiftUI
import ComposableArchitecture

struct TextChangeView: View {
    let store: StoreOf<TextChangeFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                Text("\(store.text)")
                
                Button("Change Button") {
                    store.send(.textChangeButtonTapped)
                }
                .font(.title3)
            }
        }
    }
}
