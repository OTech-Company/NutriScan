//
//  WeightPicker.swift
//  NutriScan
//
//  Created by Osama Hosam on 17/07/2026.
//

import SwiftUI


struct WeightPickerScreen: View {
    @State private var weight: Int = 60
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        VStack(spacing: 28) {
            HStack {
//                BackButton(action: {})
                Spacer()
            }
            .padding(.horizontal, 20)
 
            StepProgressText(current: 4, total: 4)
 
            TitleBlock(
                segments: [
                    TitleSegment("Your current "),
                    TitleSegment("weight", color: Color.Teal.teal900)
                ],
                subtitle: "Your weight helps us estimate your daily \n calorie needs more accurately."
            )
 
            Spacer(minLength: 10)
 

            ValueCard(value: weight, style: .plain)

            Spacer()
            
            RulerDial(value: $weight, unit: .weight)
 
            Spacer()
 
            ProgressNextButton(currentStep: 4, totalSteps: 4) {
                router.push(ProfileSetupRoute.birthdatePicker)
            }
        }
        .padding(.top, 12)
        .background(Color.white.ignoresSafeArea())
    }
}
 
#Preview {
    WeightPickerScreen()
}
