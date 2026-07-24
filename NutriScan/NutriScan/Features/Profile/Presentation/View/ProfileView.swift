//
//  ProfileView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var router: AppRouter
    var viewModel: ProfileViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ProfileHeaderView(
                    userName: viewModel.state.fullName,   // was: viewModel.state.userName
                    avatarURL: nil,                        // no avatar field in this scoped response — pending confirmation if needed
                    streakDays: 0,                         // not part of this contract — flag below
                    onEdit: { router.push(ProfileRoute.editProfile) }
                )

                VStack(alignment: .leading, spacing: ProfileSemantics.Spacing.sectionSpacing) {
                    FamilyMembersSectionView(
                        members: viewModel.state.familyMembers,
                        onAddMember: { /* TODO: router.push(ProfileRoute.addFamilyMember) once that route exists */ },
                        onShowDetails: { _ in /* TODO: router.push(ProfileRoute.familyMemberDetails(member)) */ }
                    )

                    SettingsSectionView(
                        onScanHistory: { router.push(ProfileRoute.scanHistory) },
                        onNotifications: { /* TODO: no ProfileRoute case for notifications yet */ },
                        onSettings: { router.push(ProfileRoute.settings) }
                    )
                }
                .padding(.horizontal, ProfileSemantics.Spacing.horizontalPadding)
                .padding(.top, ProfileSemantics.Spacing.sectionSpacing)
                .padding(.bottom, 100) // clearance above bottom tab bar
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.ProfileSemantics.containerBackground)
                .clipShape(RoundedCorner(radius: ProfileSemantics.Radius.containerTop, corners: [.topLeft, .topRight]))
                .offset(y: -ProfileSemantics.Radius.containerTop) // pulls container up to overlap header's bottom edge
            }
        }
        .background(Color.ProfileSemantics.background.ignoresSafeArea())
        .navigationBarHidden(true)
        .task {
            await viewModel.loadProfile()
        }
    }
}
