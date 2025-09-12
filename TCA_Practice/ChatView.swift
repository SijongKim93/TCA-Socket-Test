//
//  ChatView.swift
//  TCA_Practice
//
//  Created by SiJongKim on 9/12/25.
//

import SwiftUI
import ComposableArchitecture

struct ChatView: View {
    let store: StoreOf<ChatFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                // 채팅 로그
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(viewStore.messages, id: \.self) { msg in
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
                            get: { viewStore.currentMessage },
                            set: { viewStore.send(.updateCurrentMessage($0)) }
                        )
                    )
                    .textFieldStyle(.roundedBorder)
                    .disabled(!viewStore.isConnected)
                    
                    Button("Send") {
                        viewStore.send(.sendMessage)
                    }
                    .disabled(!viewStore.isConnected || viewStore.currentMessage.isEmpty)
                }
                .padding()
                
                // 연결 버튼
                if viewStore.isConnected {
                    Button("Disconnect") {
                        viewStore.send(.disconnect)
                    }
                    .foregroundColor(.red)
                    .padding(.bottom)
                } else {
                    Button("Connect") {
                        viewStore.send(.connect)
                    }
                    .padding(.bottom)
                }
            }
        }
    }
}
