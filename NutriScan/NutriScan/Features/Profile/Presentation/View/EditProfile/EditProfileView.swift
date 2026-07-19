//
//  EditProfileView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 19/07/2026.
//
import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var viewModel = EditProfileViewModel()

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(
                alignment: .leading,
                spacing: EditProfileSemantics.Spacing.sectionVertical
            ) {
                BackButton(action: { router.pop() })

                ProfileHeaderView(
                    name: viewModel.name,
                    email: viewModel.email,
                    avatarImage: Image("avatar-placeholder")
                )

                VStack(spacing: EditProfileSemantics.Spacing.fieldVertical) {
                    EditableFieldView(
                        placeholder: "name", text: $viewModel.name)
                    EditableFieldView(
                        placeholder: "user name", text: $viewModel.username)
                    EditableFieldView(
                        placeholder: "email", text: $viewModel.email,
                        trailingIcon: "envelope")
                    EditableFieldView(
                        placeholder: "password", text: $viewModel.password,
                        trailingIcon: "lock")
                }

                ConditionsSectionView(
                    allConditions: viewModel.availableConditions,
                    selected: $viewModel.selectedConditions,
                    onAddOther: { viewModel.showAddConditionSheet = true }
                )

                AllergiesSectionView(
                    allAllergies: viewModel.availableAllergies,
                    selected: $viewModel.selectedAllergies,
                    onAddOther: { viewModel.showAddAllergySheet = true }
                )

                CustomPuffedButton(
                    title: "Sign in",
                    action: { /* TODO: backend save */  },
                    isLoading: viewModel.isLoading
                )
                .padding(.top, 8)
            }
            .padding(.horizontal, EditProfileSemantics.Spacing.screenHorizontal)
        }
        .background(Color.EditProfileSemantics.backgroundPrimary.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}
