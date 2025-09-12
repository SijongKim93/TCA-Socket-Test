//
//  CounterFeature.swift
//  TCA_Practice
//
//  Created by SiJongKim on 9/11/25.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct CounterFeature {
    @ObservableState
    public struct State: Equatable {
        var count = 0
    }
    
    enum CancelID {
        case timer
    }
    
    public enum Action {
        case incrementButtonTapped
        case decrementButtonTapped
        case resetButtonTapped
        case startAutoIncrementButtonTapped
        case stopAutoIncrementButtonTapped
        case autoIncrementTick
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .incrementButtonTapped:
                state.count += 1
                return .none
                
            case .decrementButtonTapped:
                state.count -= 1
                return .none
                
            case .resetButtonTapped:
                state.count = 0
                return .none
                
            case .startAutoIncrementButtonTapped:
                return .run { send in
                    for await _ in Timer.publish(every: 1, on: .main, in: .common).autoconnect().values {
                        await send(.autoIncrementTick)
                    }
                }
                .cancellable(id: CancelID.timer)
                
            case .stopAutoIncrementButtonTapped:
                return .cancel(id: CancelID.timer)
                
            case .autoIncrementTick:
                state.count += 1
                return .none
            }
        }
    }
}
