//
//  ProfileView.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//


import SwiftUI

// MARK: - Parent Screen
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

// MARK: - Header Component
struct HeaderComponent: View {
    let fullName: String
    let streakCount: Int
    let badgesCount: Int
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer().frame(height: 50)
            
            // Profile image placeholder
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.white)
            
            Text(fullName)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            HStack(spacing: 12) {
                BadgeLabel(text: "\(streakCount) Day Streak", systemIcon: "flame.fill", color: .orange)
                BadgeLabel(text: "\(badgesCount) Badges Earned", systemIcon: "trophy.fill", color: .yellow)
            }
            
            Spacer().frame(height: 20)
        }
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.1, green: 0.55, blue: 0.55)) // NutriScan Teal
        .clipShape(RoundedCornerShape(radius: 30, corners: [.bottomLeft, .bottomRight]))
    }
}

// MARK: - Health Profile Card
struct HealthProfileCardComponent: View {
    let completionPercentage: Int
    let onEditClicked: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 10) {
                    Image(systemName: "cross.case.fill")
                        .foregroundColor(Color(red: 0.1, green: 0.55, blue: 0.55))
                        .font(.title2)
                    Text("My Health Profile")
                        .font(.headline)
                        .fontWeight(.bold)
                }
                Spacer()
                Button(action: onEditClicked) {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.gray)
                }
            }
            
            ProgressView(value: Double(completionPercentage), total: 100)
                .tint(Color(red: 0.1, green: 0.55, blue: 0.55))
            
            HStack {
                Text("Profile Completion:")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("\(completionPercentage)%")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.1, green: 0.55, blue: 0.55))
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// MARK: - List Row Components
struct MenuOptionRowComponent: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color(red: 0.1, green: 0.55, blue: 0.55))
                    .frame(width: 24)
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.footnote)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

struct ToggleOptionRowComponent: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color(red: 0.1, green: 0.55, blue: 0.55))
                .frame(width: 24)
            Text(title)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(Color(red: 0.1, green: 0.55, blue: 0.55))
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Tiny Helpers
struct BadgeLabel: View {
    let text: String
    let systemIcon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: systemIcon)
                .foregroundColor(color)
            Text(text)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.black)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.white.opacity(0.85))
        .cornerRadius(20)
    }
}

struct RoundedCornerShape: Shape {
    let radius: CGFloat
    let corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
