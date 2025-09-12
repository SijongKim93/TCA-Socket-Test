//
//  ChatFeature.swift
//  TCA_Practice
//
//  Created by SiJongKim on 9/12/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
public struct ChatFeature {
    @ObservableState
    public struct State: Equatable {
        public var isConnected: Bool
        public var currentMessage: String = ""
        public var messages: [String] = []
    }
    
    public enum Action {
        case connect
        case disconnect
        case sendMessage
        case messageReceived(String)
        case updateCurrentMessage(String)
        case socketOpened
        case socketClosed
        case socketFailed(Error)
    }
    
    enum CancelID {
        case socket
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .connect:
                state.isConnected = true
                let isConnected = state.isConnected
                
                return .run { send in
                    let url = URL(string: "wss://ws.postman-echo.com/raw")!
                    let task = URLSession.shared.webSocketTask(with: url)
                    task.resume()
                    await send(.socketOpened)
                    
                    while isConnected {
                        do {
                            let message = try await task.receive()
                            switch message {
                            case let .string(text):
                                await send(.messageReceived(text))
                            case let .data(data):
                                if let text = String(data: data, encoding: .utf8) {
                                    await send(.messageReceived(text))
                                }
                            @unknown default:
                                break
                            }
                        } catch {
                            await send(.socketFailed(error))
                            break
                        }
                    }
                    await send(.socketClosed)
                }
                .cancellable(id: CancelID.socket)
                
            case .disconnect:
                state.isConnected = false
                return .cancel(id: CancelID.socket)
                
            case .sendMessage:
                let text = state.currentMessage
                state.currentMessage = ""
                state.messages.append("Me: \(text)")
                
                return .run { _ in
                    let url = URL(string: "wss://ws.postman-echo.com/raw")!
                    let task = URLSession.shared.webSocketTask(with: url)
                    task.send(.string(text)) { error in
                        if let error = error {
                            print("Send Error: \(error)")
                        }
                    }
                }
                
            case let .messageReceived(text):
                state.currentMessage = text
                return .none
                
            case let .updateCurrentMessage(text):
                state.currentMessage = text
                return .none
                
            case .socketOpened:
                print("Socket Open")
                return .none
                
            case .socketClosed:
                print("Socket Closed")
                return .none
                
            case let .socketFailed(error):
                state.isConnected = false
                print("Socket Failed: \(error.localizedDescription)")
                return .none
            }
        }
    }
}
