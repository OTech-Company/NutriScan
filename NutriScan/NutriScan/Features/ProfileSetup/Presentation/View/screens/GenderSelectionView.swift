//
//  GenderSelectionView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 17/07/2026.
//

import SwiftUI

struct GenderSelectionView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var viewModel = GenderSelectionViewModel()

    var body: some View {
        VStack(spacing: 0) {
            (Text("\(viewModel.currentStep)")
                .foregroundColor(Color.Teal.teal1000)
                + Text("/")
                .foregroundColor(Color.Gray.gray600)
                + Text("\(viewModel.totalSteps)")
                .foregroundColor(Color.Gray.gray400))
                .padding(.top, 128)
                .font(Font.AppFont.textSecondary)

            (Text("What is You ")
                .foregroundColor(Color.Gray.gray1600)
                + Text("Gender?")
                .foregroundColor(Color.Teal.teal1000))
                .font(Font.AppFont.title3)
                .multilineTextAlignment(.center)
                .padding(.top, 8)

            Text(
                "We'll use this information to personalize your NutriScan experience."
            )
            .font(Font.AppFont.textDefault)
            .foregroundColor(Color.Gray.gray700)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40)
            .padding(.top, 8)

            Spacer(minLength: 60)

            GenderSelectionRow(selectedGender: $viewModel.selectedGender)

            Spacer()

            ProgressNextButton(currentStep: viewModel.currentStep) {
                router.push(ProfileSetupRoute.birthdatePicker)
            }
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity)
        .appProfileSetupBackground()
        .navigationBarHidden(true)
    }
}

#Preview("Light Mode") {
    GenderSelectionView()
        .environmentObject(AppRouter())
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    GenderSelectionView()
        .environmentObject(AppRouter())
        .preferredColorScheme(.dark)
}
