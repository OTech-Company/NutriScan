////
////  GenderSelectionView.swift
////  NutriScan
////
////  Created by Mina_Wagdy on 17/07/2026.
////
//
//import SwiftUI
//
//struct GenderPickerView: View {
//    @EnvironmentObject private var router: AppRouter
//    @State private var viewModel = GenderSelectionViewModel()
//
//    var body: some View {
//        ProfileSetupStepView(
//            currentStep: viewModel.currentStep,
//            totalSteps: viewModel.totalSteps,
//            titleSegments: [
//                TitleSegment("What is Your "),
//                TitleSegment(
//                    "Gender?",
//                    color: Color.ProfileSetupSemantic.accent
//                )
//            ],
//            subtitle: "We'll use this information to personalize your NutriScan experience.",
//            nextRoute: .heightPicker
//        ) {
//            // Step-specific structural layout and components
//            Spacer(minLength: 60)
//
//            GenderSelectionRow(selectedGender: $viewModel.selectedGender)
//
//            Spacer()
//        }
//        .navigationBarHidden(true)
//    }
//}
//
//#Preview("Light Mode") {
//    GenderPickerView()
//        .environmentObject(AppRouter())
//        .preferredColorScheme(.light)
//}
//
//#Preview("Dark Mode") {
//    GenderPickerView()
//        .environmentObject(AppRouter())
//        .preferredColorScheme(.dark)
//}
