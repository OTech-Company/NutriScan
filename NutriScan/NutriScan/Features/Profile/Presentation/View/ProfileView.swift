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
    @State private var isFetchingProfile = true
    var body: some View {
        ZStack(alignment: .top) {
            Color.ProfileSemantics.headerBackground
                .ignoresSafeArea()
            if isFetchingProfile {
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.white)

                    Text("Loading Profile...")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }

                .frame(
                    maxWidth: .infinity, maxHeight: .infinity,
                    alignment: .center)
            } else {

                ProfileHeaderDecoration()

                ProfileHeaderView(
                    userName: viewModel.state.fullName,
                    avatarURL: nil,
                    streakDays: 15,  // TODO: not part of the current contract — flagged previously
                    onEdit: { router.push(ProfileRoute.editProfile) }
                ).padding(.top, 42)

                VStack(spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        VStack(
                            alignment: .leading,
                            spacing: ProfileSemantics.Spacing.sectionSpacing
                        ) {
                            FamilyMembersSectionView(
                                members: viewModel.state.familyMembers,
                                onAddMember: { /* TODO: router.push(ProfileRoute.addFamilyMember) once that route exists */
                                },
                                onShowDetails: {
                                    _
                                    in /* TODO: router.push(ProfileRoute.familyMemberDetails(member)) */
                                }
                            )

                            SettingsSectionView(
                                onScanHistory: {
                                    router.push(ProfileRoute.scanHistory)
                                },
                                onNotifications: { /* TODO: no ProfileRoute case for notifications yet */
                                },
                                onSettings: {
                                    router.push(ProfileRoute.settings)
                                }
                            )
                        }
                        .padding(
                            .horizontal,
                            ProfileSemantics.Spacing.horizontalPadding
                        )
                        .padding(.top, ProfileSemantics.Spacing.sectionSpacing)
                        .padding(.bottom, 100)  // clearance above bottom tab bar
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .background(Color.ProfileSemantics.containerBackground)
                .clipShape(
                    RoundedCorner(
                        radius: ProfileSemantics.Radius.containerTop,
                        corners: [.topLeft, .topRight])
                )
                .padding(.top, 180)
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .task {
            isFetchingProfile = true
            await viewModel.loadProfile()
            withAnimation(.easeIn(duration: 0.3)) {
                isFetchingProfile = false
            }
        }
    }
}
