//
//  SwipeToActionButton.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 25/07/2026.
//

import SwiftUI

struct SwipeToActionButton: View {
    var actionTitle: String = "Swipe right to add"
    var action: (@escaping (Bool) -> Void) -> Void

    /// When the parent sets this to `true`, the slider snaps back to idle.
    var shouldReset: Bool = false

    @State private var dragOffset: CGFloat = 0
    @State private var isCompleted: Bool = false
    @State private var trackWidth: CGFloat = 0

    private let thumbWidth: CGFloat = 36
    private let thumbHeight: CGFloat = 18
    private let trackInset: CGFloat = 4 // The horizontal padding inside the track

    var body: some View {
        let maxDrag = max(0, trackWidth - thumbWidth - (trackInset * 2))

        ZStack(alignment: .leading) {
            // Background Track
            Capsule()
                .fill(Color.Favorites.swipeBackgroundColor)
                .frame(height: 24)

            // Text Instruction (Centered dynamically)
            HStack {
                Spacer()
                Text(isCompleted ? "Added!" : actionTitle)
                    .font(Font.AppFont.lexendDecaLight12)
                    .foregroundColor(Color.Favorites.swipeTextColor)
                    .padding(.leading, isCompleted ? 0 : 28) // Offset a bit to balance the thumb visually
                Spacer()
            }

            // Sliding Thumb / Button
            HStack {
                ZStack {
                    Capsule()
                        .foregroundStyle(Color.Teal.teal1000)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }
                .frame(width: thumbWidth, height: thumbHeight)
                .offset(x: max(0, min(dragOffset, maxDrag)))
                Spacer(minLength: 0)
            }
            .padding(.horizontal, trackInset)
        }
        .frame(height: 24)
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        trackWidth = geo.size.width
                    }
                    .onChange(of: geo.size.width) { _, newWidth in
                        trackWidth = newWidth
                    }
            }
        )
        .contentShape(Rectangle())
        .highPriorityGesture(
            DragGesture(minimumDistance: 5)
                .onChanged { value in
                    guard maxDrag > 0 else { return }
                    // Prevent vertical scrolling from triggering horizontal swipe
                    guard abs(value.translation.width) > abs(value.translation.height) else { return }
                    
                    if value.translation.width >= 0 {
                        dragOffset = min(value.translation.width, maxDrag)
                    }
                }
                .onEnded { value in
                    guard maxDrag > 0 else { return }
                    
                    if dragOffset > maxDrag * 0.5 {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            dragOffset = maxDrag
                        }
                        
                        action { success in
                            if success {
                                withAnimation {
                                    isCompleted = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    resetSlider()
                                }
                            } else {
                                resetSlider()
                            }
                        }
                    } else {
                        resetSlider()
                    }
                }
        )
        .onChange(of: shouldReset) { _, newValue in
            if newValue {
                resetSlider()
            }
        }
    }

    private func resetSlider() {
        withAnimation(.spring()) {
            dragOffset = 0
            isCompleted = false
        }
    }
}

#Preview {
    VStack {
        FavoriteCardView(
            favUIState: FavUIState(id: "1", image: "testImage", title: "Milk Product", calories: 180, condition: .Caution)
        )
    }
    .padding(.horizontal, 80)
}
