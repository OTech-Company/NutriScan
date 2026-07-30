//
//  SliderTestView.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 25/07/2026.
//

import SwiftUI

struct SwipeToActionButton: View {
    var actionTitle: String = "Swipe right to add"
    var action: () -> Void

    /// When the parent sets this to `true`, the slider snaps back to idle.
    /// The parent is responsible for resetting it back to `false` after.
    var shouldReset: Bool = false

    @State private var dragOffset: CGFloat = 0
    @State private var isCompleted: Bool = false

    private let thumbWidth: CGFloat = 36
    private let thumbHeight: CGFloat = 18
    private let trackInset: CGFloat = 4 // The horizontal padding inside the track

    var body: some View {
        GeometryReader { geometry in
            let trackWidth = geometry.size.width
            // Correct maxDrag calculation: Total width minus the thumb width and track padding on both sides
            let maxDrag = trackWidth - thumbWidth - (trackInset * 2)

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
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if value.translation.width >= 0 && value.translation.width <= maxDrag {
                                    dragOffset = value.translation.width
                                }
                            }
                            .onEnded { value in
                                if dragOffset > maxDrag * 0.75 {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        dragOffset = maxDrag
                                        isCompleted = true
                                    }
                                    action()

                                    // Auto-reset after 1.5s so the card returns to idle state
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        resetSlider()
                                    }
                                } else {
                                    resetSlider()
                                }
                            }
                    )
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, trackInset)
            }
        }
        .frame(height: 24)
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
