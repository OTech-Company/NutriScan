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
            content
        }
        .frame(height: ProfileSemantics.HeaderLayout.headerHeight)
        .clipShape(RoundedCorner(radius: ProfileSemantics.Radius.zero, corners: []))
    }

    @ViewBuilder
    private var content: some View {
        if isLoading {
            ProfileHeaderLoadingView()
        } else if let errorMessage = state.errorMessage, !errorMessage.isEmpty, !state.hasCachedProfile {
            // TODO: once a dedicated EmptyStateView exists for Profile,
            // consider using it here instead of/alongside
            // ProfileHeaderFailureView, since "never loaded, currently
            // offline" is a distinct case from a generic error.
            ProfileHeaderFailureView(message: errorMessage)
        } else {
            ProfileHeaderSuccessView(state: state, onEdit: onEdit)
        }
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
                errorMessage: nil,
                hasCachedProfile: true
            ),
            isLoading: false,
            onEdit: {}
        )

        ProfileHeaderView(
            state: ProfileState(),
            isLoading: true,
            onEdit: {}
        )

        // No cached data at all + failed — the only case that shows the
        // failure view (e.g. first launch, no connectivity).
        ProfileHeaderView(
            state: ProfileState(
                fullName: "",
                familyMembers: [],
                streakDays: 0,
                avatarURL: nil,
                isLoading: false,
                errorMessage: "No internet connection",
                hasCachedProfile: false
            ),
            isLoading: false,
            onEdit: {}
        )

        // Had data before, latest refresh failed — falls back to showing the
        // cached success view instead of an error.
        ProfileHeaderView(
            state: ProfileState(
                fullName: "Sara Omar",
                familyMembers: [],
                streakDays: 15,
                avatarURL: nil,
                isLoading: false,
                errorMessage: "No internet connection",
                hasCachedProfile: true
            ),
            isLoading: false,
            onEdit: {}
        )
    }
    .background(Color.ProfileSemantics.headerBackground)
}
