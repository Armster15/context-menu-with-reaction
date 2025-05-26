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

struct TouchDragState: Equatable {
    var isDragging: Bool = false
    var location: CGPoint = .zero
}

struct EmojiBar: View {
    let emojis = ["😀", "😁", "😂", "😍", "😌"]
    
    @State private var showEmojiPicker = false
    @State private var selectedEmoji: String = ""
    
    @State private var touchDragState = TouchDragState()
    @State private var highlightedEmoji: String? = nil
    
    var body: some View {
        ZStack {
            Color.clear
                .padding(-24)
                .contentShape(Rectangle())
                .zIndex(100)
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .global)
                        .onChanged { value in
                            touchDragState = TouchDragState(isDragging: true, location: value.location)
                        }
                        .onEnded { _ in
                            touchDragState.isDragging = false
                            highlightedEmoji = nil
                        }
                )
            
            BlurView(style: .systemUltraThinMaterial)
                .clipShape(Capsule())
            
            emojiBarContent
        }
    }
    
    private var emojiBarContent: some View {
        HStack(spacing: 0) {
            ForEach(Array(emojis.enumerated()), id: \.element) { index, emoji in
                InnerEmoji(
                    emoji: emoji,
                    isHighlighted: highlightedEmoji == emoji,
                    touchDragState: touchDragState,
                    onHighlightChange: { highlightedEmoji in
                        self.highlightedEmoji = highlightedEmoji
                    },
                    leadingPadding: index == 0 ? 16 : 12, // isFirst
                    trailingPadding: index == emojis.count - 1 ? 16 : 0 // isLast
                )
            }
            
//            Button(action: {
//                showEmojiPicker = true
//            }) {
//                Image(systemName: "plus")
//                    .font(.system(size: 32))
//                    .foregroundColor(.gray)
//            }
//            .buttonStyle(PlainButtonStyle())
//            .emojiPicker(isPresented: $showEmojiPicker, selectedEmoji: $selectedEmoji)
//            .accessibilityLabel("Open Emoji Picker")
            
        }
        .background(
            Capsule()
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }
}

struct InnerEmoji: View {
    let emoji: String
    let isHighlighted: Bool
    let touchDragState: TouchDragState
    let onHighlightChange: (String?) -> Void
    let leadingPadding: CGFloat
    let trailingPadding: CGFloat
    
    @State private var emojiFrame: CGRect = .zero
    
    var body: some View {
        Button(emoji) {
            // Handle emoji selection/reaction here
            print("Selected emoji: \(emoji)")
        }
        .padding(.vertical, 8)
        .padding(.leading, leadingPadding)
        .padding(.trailing, trailingPadding)
        
        .font(.system(size: 32))
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isHighlighted ? 1.5 : 1.0)
        .offset(y: isHighlighted ? -25 : 0)
        .animation(.easeInOut(duration: 0.1), value: isHighlighted)
        .background(
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        emojiFrame = geometry.frame(in: .global)
                    }
                    .onChange(of: geometry.frame(in: .global)) { newFrame in
                        emojiFrame = newFrame
                    }
                    .onChange(of: touchDragState) { state in
                        if state.isDragging {
                            let isCurrentlyOver = emojiFrame.contains(state.location)
                            if isCurrentlyOver && !isHighlighted {
                                onHighlightChange(emoji)
                                // Optional: Add haptic feedback
                                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                                impactFeedback.impactOccurred()
                            } else if !isCurrentlyOver && isHighlighted {
                                onHighlightChange(nil)
                            }
                        }
                    }
            }
        )
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
