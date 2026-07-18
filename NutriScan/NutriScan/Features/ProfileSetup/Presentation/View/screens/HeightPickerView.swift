//
//  HeightPickerView.swift
//  NutriScan
//
//  Created by Osama Hosam on 18/07/2026.
//


import SwiftUI

struct HeightPickerView: View {

    @State private var height: Int = 170

    @EnvironmentObject private var router: AppRouter

    var body: some View {
        VStack(spacing: 28) {

            HStack {
//                BackButton(action: {})
                Spacer()
            }
            .padding(.horizontal, 20)

            StepProgressText(current: 3, total: 4)

            TitleBlock(
                segments: [
                    TitleSegment("How "),
                    TitleSegment(
                        "tall ",
                        color: Color.ProfileSetupSemantic.accent
                    ),
                    TitleSegment("are you?")
                ],
                subtitle: "We'll use your height to personalize your\nnutrition insights and calorie calculations."
            )

            Spacer(minLength: 10)

            ValueCard(
                value: height,
                style: .boxed,
                sideCount: 2
            )

            Spacer()

            RulerDial(
                value: $height,
                unit: .height
            )

            Spacer()

            ProgressNextButton(currentStep: 3, totalSteps: 4) {
                router.push(ProfileSetupRoute.weightPicker)
            }
        }
        .padding(.top, 12)
        .background(
            Color.ProfileSetupSemantic.background
                .ignoresSafeArea()
        )
    }
}

#Preview {
    HeightPickerView()
}
