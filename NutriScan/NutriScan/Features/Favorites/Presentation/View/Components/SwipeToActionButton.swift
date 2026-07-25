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
    
    @State private var dragOffset: CGFloat = 0
    @State private var isCompleted: Bool = false
    
    private let thumbSize: CGFloat = 28
    private let trackInset: CGFloat = 2 // The horizontal padding inside the track
    
    var body: some View {
        GeometryReader { geometry in
            let trackWidth = geometry.size.width
            // Correct maxDrag calculation: Total width minus the thumb size and track padding on both sides
            let maxDrag = trackWidth - thumbSize - (trackInset * 2)
            
            ZStack(alignment: .leading) {
                // Background Track
                Capsule()
                    .fill(Color.Gray.gray300)
                    .frame(height: 36)
                
                // Text Instruction (Centered dynamically)
                HStack {
                    Spacer()
                    Text(isCompleted ? "Added!" : actionTitle)
                        .font(Font.AppFont.textSecondary)
                        .foregroundColor(Color.Gray.gray500)
                        .frame(width: trackWidth, alignment: .center)
                        .padding(.leading, isCompleted ? 0 : 16)
                    Spacer()
                }
                
                // Sliding Thumb / Button
                HStack {
                    ZStack {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .bold))
                            .frame(maxHeight: .infinity)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .background(Capsule().foregroundStyle(Color.Teal.teal1400))
                            .padding(.leading, 22)
                    }
                    .frame(width: thumbSize, height: thumbSize)
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
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
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
        .frame(height: 36)
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
        FavoriteCardView()
    }
    .padding(.horizontal, 80)
}
