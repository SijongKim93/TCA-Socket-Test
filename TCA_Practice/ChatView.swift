//
//  ChatView.swift
//  TCA_Practice
//
//  Created by SiJongKim on 9/12/25.
//

import SwiftUI
import ComposableArchitecture

struct ChatView: View {
    var store: StoreOf<ChatFeature>
    
    var body: some View {
        WithPerceptionTracking {
            @Perception.Bindable var store = store
            
            VStack {
                MessageListView(messages: store.messages)
                Divider()
                MessageInputView(store: store)
                ConnectionButtonView(store: store)
            }
        }
    }
}

struct MessageListView: View {
    let messages: [String]
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 8) {
                ForEach(messages, id: \.self) { msg in
                    Text(msg)
                        .padding(10)
                        .background(msg.hasPrefix("Me:") ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity, alignment: msg.hasPrefix("Me:") ? .trailing : .leading)
                }
            }
            .padding()
        }
    }
}

struct MessageInputView: View {
    let store: StoreOf<ChatFeature>
    @State private var inputText: String = ""
    
    var body: some View {
        WithPerceptionTracking {
            let isConnected = store.isConnected
            
            HStack {
                TextField(
                    "Type a message...",
                    text: $inputText
                )
                .textFieldStyle(.roundedBorder)
                .disabled(!isConnected)
                .onSubmit {
                    if !inputText.isEmpty {
                        store.send(.updateCurrentMessage(inputText))
                        store.send(.sendMessage)
                        inputText = ""
                    }
                }
                
                Button("Send") {
                    if !inputText.isEmpty {
                        store.send(.updateCurrentMessage(inputText))
                        store.send(.sendMessage)
                        inputText = ""
                    }
                }
                .disabled(!isConnected || inputText.isEmpty)
            }
            .padding()
        }
    }
}

struct ConnectionButtonView: View {
    let store: StoreOf<ChatFeature>
    
    var body: some View {
        WithPerceptionTracking {
            if store.isConnected {
                Button("Disconnect") {
                    store.send(.disconnect)
                }
                .foregroundColor(.red)
                .padding(.bottom)
            } else {
                Button("Connect") {
                    store.send(.connect)
                }
                .padding(.bottom)
            }
        }
    }
}

