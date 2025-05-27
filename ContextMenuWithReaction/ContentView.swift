//
//  ContentView.swift
//  ContextMenuWithReaction
//
//  Created by Armaan Aggarwal on 5/26/25.
//

import SwiftUI

let CORNER_RADIUS = 20.0

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isSender: Bool
}

struct MessageBubble: View {
    let message: Message

    var body: some View {
        HStack {
            if message.isSender {
                Spacer()
            }
            Text(message.text)
                .padding(.horizontal)
                .padding(.vertical, 15)
                .background(
                    message.isSender
                    ? Color.blue
                    : Color(UIColor.systemGray5)
                )
                .foregroundColor(
                    message.isSender
                    ? .white
                    : Color.primary
                )
                .cornerRadius(CORNER_RADIUS)
                .frame(maxWidth: 250, alignment: message.isSender ? .trailing : .leading)
            if !message.isSender {
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

struct ContentView: View {
    let messages: [Message] = [
        Message(text: "Hey!", isSender: false),
        Message(text: "Yo, what’s up?", isSender: true),
        Message(text: "Not much. Just finished work.", isSender: false),
        Message(text: "Nice, how was it?", isSender: true),
        Message(text: "Pretty hectic. Meetings all day. 😩", isSender: false),
        Message(text: "Oof. You need a break.", isSender: true),
        Message(text: "Tell me about it. Coffee saved me. Again.", isSender: false),
        Message(text: "Haha, the real MVP ☕", isSender: true),
        Message(text: "Did you finish that UI you were working on?", isSender: false),
        Message(text: "Almost! Just tweaking the layout for dark mode.", isSender: true),
        Message(text: "Sweet. Can’t wait to see it.", isSender: false),
        Message(text: "I’ll send you a screenshot in a bit.", isSender: true),
        Message(text: "Cool. Oh btw, did you watch the new episode?", isSender: false),
        Message(text: "Yes!! Crazy twist at the end 😱", isSender: true),
        Message(text: "Right?! I didn’t see that coming.", isSender: false),
        Message(text: "Same. Thought they were gonna drag it out longer.", isSender: true),
        Message(text: "Anyway, dinner time. Let’s catch up later?", isSender: false),
        Message(text: "Sure thing. Enjoy your food!", isSender: true),
        Message(text: "Thanks! 😄", isSender: false)
    ]

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages) { message in
                        MessageBubble(message: message)
                        .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: CORNER_RADIUS))
                        .contextMenu {
                            Button {
                                // action
                            } label: {
                                Label("Reply", systemImage: "arrowshape.turn.up.left")
                            }
                            
                            Button {
                                // action
                            } label: {
                                Label("Copy Text", systemImage: "doc.on.doc")
                            }
                            
                            Button(role: .destructive) {
                                // action
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .contextMenuAccessory(
                            placement: .top,
                            location: .preview,
                            alignment: .center,
                            trackingAxis: .yAxis
                        ) {
                            EmojiBar()
                                .padding(.vertical, 16)
                        }
                    }
                }
            }
        }
        .background(Color(UIColor.systemBackground))
    }
}


#Preview {
    ContentView()
}
