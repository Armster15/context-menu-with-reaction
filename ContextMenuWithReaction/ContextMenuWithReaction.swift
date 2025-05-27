//
//  ContextMenuWithReaction.swift
//  ContextMenuWithReaction
//
//  Created by Armaan Aggarwal on 5/26/25.
//


import SwiftUI
import MenuWithAView
import MCEmojiPicker

struct TouchDragState: Equatable {
    var isDragging: Bool = false
    var location: CGPoint = .zero
}

public struct EmojiBar: View {
    let emojis = ["😀", "😁", "😂", "😍", "😌"]
    
    @State private var showEmojiPicker = false
    @State private var selectedEmoji: String = ""
    
    @State private var touchDragState = TouchDragState()
    @State private var highlightedEmoji: String? = nil
    
    public var body: some View {
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
                    content: {
                        Text(emoji)
                            .font(.system(size: 32))
                    },
                    touchDragState: touchDragState,
                    leadingPadding: index == 0 ? 16 : 12, // isFirst
                    trailingPadding: 0, // isLast
                    action: {
                        selectedEmoji = emoji
                    }
                )
            }
            
            InnerEmoji(
                content: {
                    Image(systemName: "plus")
                        .font(.system(size: 32))
                        .foregroundColor(.secondary)
                },
                touchDragState: touchDragState,
                leadingPadding: 12,
                trailingPadding: 16,
                action: {
                    showEmojiPicker = true
                }
            )
            .accessibilityLabel("Open Emoji Picker")
            .emojiPicker(
                isPresented: $showEmojiPicker,
                selectedEmoji: $selectedEmoji
            )
            // When selectedEmoji state changes (useEffect(() => {}, [selectedEmoji]))
            .onChange(of: selectedEmoji) {
                print(selectedEmoji)
            }
        }
        .background(
            Capsule()
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }
}

struct InnerEmoji<Content: View>: View {
    let content: () -> Content
    let touchDragState: TouchDragState
    let leadingPadding: CGFloat
    let trailingPadding: CGFloat
    let action: () -> Void

    @State private var emojiFrame: CGRect = .zero
    @State private var isHighlighted: Bool = false

    var body: some View {
        content()
            .padding(.vertical, 8)
            .padding(.leading, leadingPadding)
            .padding(.trailing, trailingPadding)
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
                                    isHighlighted = true
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                } else if !isCurrentlyOver && isHighlighted {
                                    isHighlighted = false
                                }
                            } else {
                                // When drag ends, check if we should trigger the action
                                let wasHighlighted = isHighlighted
                                isHighlighted = false
                                
                                if wasHighlighted {
                                    action()
                                }
                            }
                        }
                }
            )
            .onTapGesture {
                // Handle simple taps
                action()
            }
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
