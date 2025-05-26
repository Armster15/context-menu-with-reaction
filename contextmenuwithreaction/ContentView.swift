//
//  ContentView.swift
//  contextmenuwithreaction
//
//  Created by Armaan Aggarwal on 5/26/25.
//

import SwiftUI
import MenuWithAView
import MCEmojiPicker

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("Hello")
                .foregroundColor(.white)
                .font(.title)
        }
        .padding([.leading, .trailing], 50)
        .padding([.top, .bottom], 20)
        // These corner radii should match
        .background(RoundedRectangle(cornerRadius: 50).foregroundColor(.blue))
        .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 50))
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
                .padding(16)
        }
    }
}

struct EmojiBar: View {
    let emojis = ["😀", "😁", "😂", "😍", "😌"]
    
    // MCEmojiPicker
    @State private var showEmojiPicker = false
    @State private var selectedEmoji: String = ""
    
    var body: some View {
        ZStack {
            // Background Blur
            BlurView(style: .systemUltraThinMaterial)
                .clipShape(Capsule())

            // Foreground with emojis
            HStack(spacing: 12) {
                ForEach(emojis, id: \.self) { emoji in
                    InnerEmoji(emoji: emoji)
                }

                Button(action: {
                    showEmojiPicker = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 32))
                        .foregroundColor(.gray)
                }
                .buttonStyle(PlainButtonStyle())
                .emojiPicker(isPresented: $showEmojiPicker, selectedEmoji: $selectedEmoji)
                .accessibilityLabel("Open Emoji Picker")
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.white.opacity(0.5))
            .clipShape(Capsule())
        }
    }
}

struct InnerEmoji: View {
    let emoji: String
    
    var body: some View {
        Button(emoji) {}
            .font(.system(size: 32))
            .buttonStyle(PlainButtonStyle())
    }
}

// BlurView helper
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

#Preview {
    ContentView()
}
