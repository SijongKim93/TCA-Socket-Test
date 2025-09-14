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
            VStack {
                MessageListView(messages: store.messages)
                Divider()
                MessageInputView(
                    isConnected: store.isConnected,
                    onSendMessage: { text in
                        store.send(.updateCurrentMessage(text))
                        store.send(.sendMessage)
                    }
                )
                ConnectionButtonView(
                    isConnected: store.isConnected,
                    onConnect: { store.send(.connect) },
                    onDisconnect: { store.send(.disconnect) }
                )
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
    let isConnected: Bool
    let onSendMessage: (String) -> Void
    @State private var inputText: String = ""
    
    var body: some View {
        HStack {
            TextField(
                "Type a message...",
                text: $inputText
            )
            .textFieldStyle(.roundedBorder)
            .disabled(!isConnected)
            .onSubmit {
                sendMessage()
            }
            
            Button("Send") {
                sendMessage()
            }
            .disabled(!isConnected || inputText.isEmpty)
        }
        .padding()
    }
    
    private func sendMessage() {
        if !inputText.isEmpty {
            onSendMessage(inputText)
            inputText = ""
        }
    }
}

struct ConnectionButtonView: View {
    let isConnected: Bool
    let onConnect: () -> Void
    let onDisconnect: () -> Void
    
    var body: some View {
        if isConnected {
            Button("Disconnect") {
                onDisconnect()
            }
            .foregroundColor(.red)
            .padding(.bottom)
        } else {
            Button("Connect") {
                onConnect()
            }
            .padding(.bottom)
        }
    }
}

