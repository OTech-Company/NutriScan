//
//  ProfileHeaderView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import SwiftUI
import Shimmer

struct ProfileHeaderView: View {
    let state: ProfileState
    var isLoading: Bool = false
    var onEdit: () -> Void

    var body: some View {
        ZStack(alignment: .topLeading) {
            if isLoading {
                ProfileHeaderLoadingView()
            } else if let errorMessage = state.errorMessage, !errorMessage.isEmpty {
                ProfileHeaderFailureView(message: errorMessage)
            } else {
                ProfileHeaderSuccessView(state: state, onEdit: onEdit)
            }
        }
        .frame(height: ProfileSemantics.HeaderLayout.headerHeight)
        .clipShape(RoundedCorner(radius: ProfileSemantics.Radius.zero, corners: []))
    }
}

#Preview("Profile Header") {
    VStack(spacing: ProfileSemantics.Spacing.sectionSpacing) {
        ProfileHeaderView(
            state: ProfileState(
                fullName: "Sara Omar",
                familyMembers: [],
                streakDays: 15, // Mock data
                avatarURL: nil,
                isLoading: false,
                errorMessage: nil
            ),
            isLoading: false,
            onEdit: {}
        )
        
        ProfileHeaderView(
            state: ProfileState(),
            isLoading: true,
            onEdit: {}
        )
        
        ProfileHeaderView(
            state: ProfileState(
                fullName: "",
                familyMembers: [],
                streakDays: 0, // Mock data
                avatarURL: nil,
                isLoading: false,
                errorMessage: "No internet connection"
            ),
            isLoading: false,
            onEdit: {}
        )
    }
    .background(Color.ProfileSemantics.headerBackground)
}
