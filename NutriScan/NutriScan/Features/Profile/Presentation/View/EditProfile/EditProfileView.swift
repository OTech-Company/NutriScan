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
                SelectableChipsSectionView(
                    title: "Chronic Conditions",
                    items: viewModel.allConditions,
                    selected: $viewModel.selectedConditions,
                    onAddOther: { /* Handle add condition */  }
                )
                SelectableChipsSectionView(
                    title: "Allergies",
                    items: viewModel.allAllergies,
                    selected: $viewModel.selectedAllergies,
                    onAddOther: { /* Handle add allergy */  }
                )

                CustomPuffedButton(
                    title: "Save",
                    action: { /* TODO: backend save */  },
                    isLoading: viewModel.isLoading
                )
                .padding(.top, 8)
            }
            .padding(.horizontal, EditProfileSemantics.Spacing.screenHorizontal)
        }
        .background(
            Color.EditProfileSemantics.backgroundPrimary.ignoresSafeArea()
        )
        .navigationBarHidden(true)
    }
}
