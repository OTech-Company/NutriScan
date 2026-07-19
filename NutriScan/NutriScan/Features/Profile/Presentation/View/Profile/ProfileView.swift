//
//  ProfileView.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//

import SwiftUI

// MARK: - Profile Screen
struct ProfileView: View {
    @State private var viewModel: ProfileViewModel
    @State private var notificationsEnabled = true
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator

    init(viewModel: ProfileViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            switch viewModel.uiState {
            case .loading:
                ProgressView()
                    .frame(maxHeight: .infinity)
            case .success(let profile, let streak, let badges):
                ScrollView {
                    VStack(spacing: 20) {
                        // Header Component
                        HeaderComponent(
                            fullName: profile.fullName,
                            streakCount: streak,
                            badgesCount: badges
                        )
                        
                        VStack(spacing: 16) {
                            // Health Card Component
                            HealthProfileCardComponent(
                                completionPercentage: profile.completionPercentage,
                                onEditClicked: {
                                    print("Edit profile")
                                    router.push(ProfileRoute.editProfile)
                                }
                            )
                            
                            // Navigation Menu Options
                            VStack(spacing: 12) {
                                MenuOptionRowComponent(icon: "person", title: "Personal Information") {
                                    print("Go to personal info")
                                    router.push(ProfileRoute.personalInformation)
                                }
                                MenuOptionRowComponent(icon: "clock.arrow.circlepath", title: "Scan History") {
                                    print("Go to history")
                                    router.push(ProfileRoute.scanHistory)
                                }
                                MenuOptionRowComponent(icon: "gearshape", title: "Settings") {
                                    print("Go to settings")
                                    router.push(ProfileRoute.settings)
                                }
                                // Toggle Option
                                ToggleOptionRowComponent(
                                    icon: "bell",
                                    title: "Notifications",
                                    isOn: $notificationsEnabled
                                )
                                .onChange(of: notificationsEnabled) { _, newValue in
                                    viewModel.toggleNotifications(isEnabled: newValue)
                                }
                            }
                            
                            // Destructive CTA
                            Button(action: { print("Logout") }) {
                                Text("Log Out")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        Capsule()
                                            .stroke(Color.red.opacity(0.3), lineWidth: 1)
                                    )
                            }
                            .padding(.top, 20)
                        }
                        .padding(.horizontal, 20)
                    }
                }
            case .error(let message):
                VStack {
                    Text(message).foregroundColor(.red)
                    Button("Retry") {
                        Task { await viewModel.loadProfile() }
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
        .task {
            await viewModel.loadProfile()
        }
    }
}
