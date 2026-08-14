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
    
    @State private var sheetMember: FamilyMember?
    @State private var isAddingNewMember = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.ProfileSemantics.headerBackground.ignoresSafeArea()
            ProfileHeaderDecoration()

            ProfileHeaderView(
                state: viewModel.state,
                isLoading: false,
                onEdit: { router.push(ProfileRoute.editProfile) }
            ).padding(.top, ProfileSemantics.Spacing.headerVerticalPadding)

            VStack(spacing: ProfileSemantics.Spacing.zero) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: ProfileSemantics.Spacing.sectionSpacing) {
                        
                        FamilyMembersSectionView(
                            members: viewModel.familyMembers,
                            isLoading: false,
                            onAddMember: { isAddingNewMember = true },
                            onShowDetails: { member in sheetMember = member }
                        )

                        SettingsSectionView(
                            onScanHistory: { router.push(ProfileRoute.scanHistory) },
                            onCaloriesHistory: { router.push(ProfileRoute.caloriesHistory) },
                            onNotifications: { /* TODO: no ProfileRoute case for notifications yet */ },
                            onSettings: { router.push(ProfileRoute.settings) }
                        )
                    }
                    .padding(.horizontal, ProfileSemantics.Spacing.horizontalPadding)
                    .padding(.top, ProfileSemantics.Spacing.sectionSpacing)
                    .padding(.bottom, CustomAnimatedTabBar.contentClearance)
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
            await viewModel.updateAndFetchStreak()
        }
        .sheet(isPresented: $isAddingNewMember) {
            FamilyMemberSheetView(
                existingMember: nil,
                allMembers: viewModel.familyMembers,
                onSave: { input, imageData in
                    return await viewModel.addFamilyMember(input, imageData: imageData)
                }
            )
            .presentationDetents([.large])
            .presentationCornerRadius(ProfileSemantics.Radius.sheetPresentation)
        }
        .sheet(item: $sheetMember) { member in
            FamilyMemberSheetView(
                existingMember: member,
                allMembers: viewModel.familyMembers,
                onSave: { input, imageData in
                    return await viewModel.updateFamilyMember(id: member.id, with: input, imageData: imageData)
                },
                onDelete: {
                    return await viewModel.deleteFamilyMember(id: member.id)
                }
            )
            .presentationDetents([.large])
            .presentationCornerRadius(ProfileSemantics.Radius.sheetPresentation)
        }
    }
}
