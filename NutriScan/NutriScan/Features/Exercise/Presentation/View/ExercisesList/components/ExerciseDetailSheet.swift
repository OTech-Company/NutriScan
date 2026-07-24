//
//  ExerciseDetailSheet.swift
//  NutriScan
//

import SwiftUI

// MARK: - Content Height Preference Key

private struct ContentHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

// MARK: - ExerciseDetailSheet

struct ExerciseDetailSheet: View {
    let exercise: Exercise
    var onStartWorkout: () -> Void = {}

    @State private var isExpanded: Bool = false
    @State private var contentHeight: CGFloat = 300

    // Truncate instructions at 3 lines when collapsed
    private let collapsedLineLimit = 3

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // MARK: Drag Handle
                Capsule()
                    .fill(Color.ExerciseSemantic.sheetHandle)
                    .frame(width: 40, height: 4)
                    .padding(.top, 12)
                    .padding(.bottom, 20)

                // MARK: Exercise Header
                HStack(spacing: 16) {
                    // Thumbnail
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.Teal.teal200.opacity(0.5))
                            .frame(width: 72, height: 72)

                        CachedImage(
                            urlString: exercise.fullGifUrlString ?? exercise.fullImageUrlString,
                            failureImageName: "figure.mixed.cardio",
                            contentMode: .fit
                        )
                        .frame(width: 72, height: 72)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    // Name + subtitle
                    VStack(alignment: .leading, spacing: 6) {
                        Text(exercise.name)
                            .font(Font.AppFont.textPrimary)
                            .foregroundColor(Color.ExerciseSemantic.sheetTitle)

                        Text("\(exercise.equipment)  •  \(exercise.target)")
                            .font(Font.AppFont.textSecondary)
                            .foregroundColor(Color.ExerciseSemantic.sheetSubtitle)
                    }

                    Spacer()
                }
                .padding(.horizontal, 20)

                // MARK: Divider
                Rectangle()
                    .fill(Color.Teal.teal200.opacity(0.6))
                    .frame(height: 1)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)

                // MARK: Instructions
                VStack(alignment: .leading, spacing: 12) {
                    Text("Instructions")
                        .font(Font.AppFont.subtitle1)
                        .foregroundColor(Color.ExerciseSemantic.instructionHead)

                    VStack(alignment: .leading, spacing: 8) {
                        let text = exercise.instructions.localizedText.isEmpty
                            ? exercise.formattedInstructions
                            : exercise.instructions.localizedText

                        HStack(alignment: .top, spacing: 8) {
                            Text("•")
                                .font(Font.AppFont.textDefault)
                                .foregroundColor(Color.ExerciseSemantic.instructionText)

                            Text(text)
                                .font(Font.AppFont.textSecondary)
                                .foregroundColor(Color.ExerciseSemantic.instructionText)
                                .lineLimit(isExpanded ? nil : collapsedLineLimit)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        // Read more / read less toggle
                        if !isExpanded && text.count > 150 {
                            Button {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                    isExpanded = true
                                }
                            } label: {
                                Text("read more")
                                    .font(Font.AppFont.textSecondary)
                                    .foregroundColor(Color.ExerciseSemantic.readMoreText)
                            }
                            .padding(.leading, 16)
                        }
                    }
                }
                .padding(.horizontal, 20)

                // MARK: CTA — Start Workout
                CustomPuffedButton(title: "Start Workout", action: onStartWorkout)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 32)
            }
            .frame(maxWidth: .infinity)
            // Measure the real content height
            .background(
                GeometryReader { geo in
                    Color.clear
                        .preference(key: ContentHeightKey.self, value: geo.size.height)
                }
            )
        }
        .scrollDisabled(!isExpanded)          // disable scroll while collapsed
        .scrollIndicators(.hidden)
        .background(Color.ExerciseSemantic.sheetBackground)
        .onPreferenceChange(ContentHeightKey.self) { height in
            // Cap at 85 % of screen height to avoid covering the whole screen
            let maxHeight = UIScreen.main.bounds.height * 0.85
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                contentHeight = min(height, maxHeight)
            }
        }
        .presentationDetents([.height(contentHeight)])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(24)
        .presentationBackground(Color.ExerciseSemantic.sheetBackground)
    }
}
