//
//  ProfileView.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//


import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator

    var body: some View {
        VStack(spacing: 16) {
            Button("Edit Profile") {
                router.push(ProfileRoute.editProfile)
            }
            Button("Settings") {
                router.presentFullScreen(ProfileRoute.settings)
            }
            Button("Log Out", role: .destructive) {
                flowCoordinator.logout()
            }
        }
        .navigationTitle("Profile")
    }
}