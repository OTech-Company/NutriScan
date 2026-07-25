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
    @State private var sheetMember: FamilyMember?      // nil sentinel for "not shown"
    @State private var isAddingNewMember = false
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
                                onAddMember: { isAddingNewMember = true },
                                onShowDetails: { member in sheetMember = member }
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
        .sheet(isPresented: $isAddingNewMember) {
            FamilyMemberSheetView(
                existingMember: nil,
                onSave: { input in
                    Task { await viewModel.addFamilyMember(input) }
                }
            )
            .presentationDetents([.large])
        }
        .sheet(item: $sheetMember) { member in
            FamilyMemberSheetView(
                existingMember: member,
                onSave: { input in
                    Task { await viewModel.updateFamilyMember(id: member.id ?? "", with: input) }
                },
                onDelete: {
                    Task { await viewModel.deleteFamilyMember(id: member.id ?? "") }
                }
            )
            .presentationDetents([.large])
        }
        
    }
}
