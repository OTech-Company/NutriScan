//
//  ProfileSetupView 2.swift
//  NutriScan
//
//  Created by Osama Hosam on 17/07/2026.
//



import SwiftUI


struct birthdatePickerView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator

    @State private var name = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("Let's set up your profile")
                .font(.title2)

            TextField("Your name", text: $name)
                .textFieldStyle(.roundedBorder)

            TextField("setup ur gender " , text: $name)
                .textFieldStyle(.roundedBorder)

            Button("Set go set up ur date of birth") {
                router.push(ProfileSetupRoute.birthdatePicker)
            }

            Button("Finish Setup") {
                // On real success from your ProfileUseCase:
                flowCoordinator.finishProfileSetup()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Profile Setup")
    }
}
