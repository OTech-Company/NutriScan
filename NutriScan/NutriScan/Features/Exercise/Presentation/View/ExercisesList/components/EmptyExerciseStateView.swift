//
//  EmptyExerciseStateView.swift
//  NutriScan
//

import SwiftUI

struct EmptyExerciseStateView: View {

    @State private var appeared = false
    @State private var iconBounce = false

    var body: some View {
        VStack(spacing: 28) {

            // MARK: - Icon with layered rings
            ZStack {
                // Outer ring
                Circle()
                    .fill(Color.Teal.teal200.opacity(0.25))
                    .frame(width: 140, height: 140)

                // Middle ring
                Circle()
                    .fill(Color.Teal.teal200.opacity(0.45))
                    .frame(width: 108, height: 108)

                // Inner filled circle
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.Teal.teal400, Color.Teal.teal600],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 78, height: 78)
                    .shadow(color: Color.Teal.teal400.opacity(0.35), radius: 12, x: 0, y: 6)

                Image(systemName: "figure.run.circle")
                    .font(.system(size: 36, weight: .medium))
                    .foregroundColor(.white)
            }
            .scaleEffect(iconBounce ? 1.06 : 1.0)
            .animation(
                .easeInOut(duration: 1.6).repeatForever(autoreverses: true),
                value: iconBounce
            )

            // MARK: - Text block
            VStack(spacing: 10) {
                Text("No exercises found")
                    .font(Font.AppFont.subtitle1)
                    .foregroundColor(Color.ExerciseSemantic.rowTitle)

                Text("Try adjusting your search\nor choose a different category")
                    .font(Font.AppFont.textSecondary)
                    .foregroundColor(Color.ExerciseSemantic.rowSubtitle)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
        }
        .padding(.horizontal, 32)
        .padding(.top, 60)
        .frame(maxWidth: .infinity)
        // Entrance animation
        .opacity(appeared ? 1 : 0)
        .scaleEffect(appeared ? 1 : 0.88)
        .animation(.spring(response: 0.5, dampingFraction: 0.75), value: appeared)
        .onAppear {
            appeared = true
            iconBounce = true
        }
        .onDisappear {
            appeared = false
            iconBounce = false
        }
    }
}

// MARK: - Preview

#Preview {
    EmptyExerciseStateView()
}
