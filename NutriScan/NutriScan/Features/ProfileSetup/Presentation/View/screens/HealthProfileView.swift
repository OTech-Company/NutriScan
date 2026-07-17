//
//  HealthProfileView.swift
//  NutriScan
//
//  Created by Osama Hosam on 18/07/2026.
//



import SwiftUI


struct HealthProfileView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator

    @State private var name = ""

    var body: some View {
        VStack(spacing: 16) {

            Button("Finish Setup") {
                // TODO: real success from your ProfileUseCase:
                flowCoordinator.finishProfileSetup()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
