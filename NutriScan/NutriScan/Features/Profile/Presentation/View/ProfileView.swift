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
    @State private var sheetMember: FamilyMember?  // nil sentinel for "not shown"
    @State private var isAddingNewMember = false
    var body: some View {
        ZStack(alignment: .top) {
            Color.ProfileSemantics.headerBackground
                .ignoresSafeArea()
            ProfileHeaderDecoration()

            ProfileHeaderView(
                state: viewModel.state,
                isLoading: isFetchingProfile,
                onEdit: { router.push(ProfileRoute.editProfile) }
            ).padding(.top, ProfileSemantics.Spacing.headerVerticalPadding)

            VStack(spacing: ProfileSemantics.Spacing.zero) {
                ScrollView(showsIndicators: false) {
                    VStack(
                        alignment: .leading,
                        spacing: ProfileSemantics.Spacing.sectionSpacing
                    ) {
                        FamilyMembersSectionView(
                            members: viewModel.state.familyMembers,
                            isLoading: isFetchingProfile,
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
                    .padding(.bottom, ProfileSemantics.Spacing.bottomTabBarClearance)  // clearance above bottom tab bar
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .background(Color.ProfileSemantics.containerBackground)
            .clipShape(
                RoundedCorner(
                    radius: ProfileSemantics.Radius.containerTop,
                    corners: [.topLeft, .topRight])
            )
            .padding(.top, ProfileSemantics.Spacing.containerTopPadding)
            .ignoresSafeArea(edges: .bottom)
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .task {
            isFetchingProfile = !viewModel.hasLoaded
            await viewModel.loadProfile()
            withAnimation(ProfileSemantics.Animation.fetchTransition) {
                isFetchingProfile = false
            }
        }
        .sheet(isPresented: $isAddingNewMember) {
            FamilyMemberSheetView(
                existingMember: nil,
                allMembers: viewModel.state.familyMembers,
                onSave: { input in
                    Task { await viewModel.addFamilyMember(input) }
                }
            )
            .presentationDetents([.large])
            .presentationCornerRadius(ProfileSemantics.Radius.sheetPresentation)
        }
        .sheet(item: $sheetMember) { member in
            FamilyMemberSheetView(
                existingMember: member,
                allMembers: viewModel.state.familyMembers,
                onSave: { input in
                    Task {
                        await viewModel.updateFamilyMember(
                            id: member.id, with: input)
                    }
                },
                onDelete: {
                    Task { await viewModel.deleteFamilyMember(id: member.id) }
                }
            )
            .presentationDetents([.large])
            .presentationCornerRadius(ProfileSemantics.Radius.sheetPresentation)
        }

    }
}
