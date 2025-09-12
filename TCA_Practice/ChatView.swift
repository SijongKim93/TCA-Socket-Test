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
                // 채팅 로그
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(store.messages, id: \.self) { msg in
                            Text(msg)
                                .padding(10)
                                .background(msg.hasPrefix("Me:") ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                                .cornerRadius(8)
                                .frame(maxWidth: .infinity, alignment: msg.hasPrefix("Me:") ? .trailing : .leading)
                        }
                    }
                    .padding()
                }
                
                Divider()
                
                // 입력창 + 버튼
                HStack {
                    TextField(
                        "Type a message...",
                        text: Binding(
                            get: { store.currentMessage },
                            set: { store.send(.updateCurrentMessage($0)) }
                        )
                    )
                    .textFieldStyle(.roundedBorder)
                    .disabled(!store.isConnected)
                    
                    Button("Send") {
                        store.send(.sendMessage)
                    }
                    .disabled(!store.isConnected || store.currentMessage.isEmpty)
                }
                .padding()
                
                // 연결 버튼
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
}
