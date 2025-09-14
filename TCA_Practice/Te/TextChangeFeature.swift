//
//  TextChangeFeature.swift
//  TCA_Practice
//
//  Created by 김시종 on 9/13/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct TextChangeFeature {
    @ObservableState
    struct State: Equatable {
        var text: String
    }
    
    enum Action {
        case textChangeButtonTapped
        case textReset
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .textChangeButtonTapped:
                state.text = "Tapped Change"
                return .none
                
            case .textReset:
                state.text = ""
                return .none
            }
        }
    }
}

