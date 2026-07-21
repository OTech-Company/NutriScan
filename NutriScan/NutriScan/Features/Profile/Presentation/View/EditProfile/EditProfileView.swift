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
                BackButton(action: { router.pop() }).padding(
                    .bottom, EditProfileSemantics.Spacing.sectionVertical)

                ProfileHeaderView(
                    name: viewModel.firstName + " " + viewModel.lastName,
                    email: viewModel.email,
                    avatarImage: Image(systemName: "person.circle.fill")
                )

                VStack(spacing: EditProfileSemantics.Spacing.fieldVertical) {
                    EditableFieldView(placeholder: "first name", text: $viewModel.firstName)
                    EditableFieldView(placeholder: "last name", text: $viewModel.lastName)

                    DateSelectionField(date: $viewModel.birthdate)

                    HStack(spacing: 12) {
                        MeasureFieldView(label: "Hight", value: $viewModel.height, unit: "cm")
                        MeasureFieldView(label: "Weight", value: $viewModel.weight, unit: "kg")
                    }
                }
                SelectableChipsSectionView(
                    title: "Chronic Conditions",
                    predefinedItems: viewModel.allConditions,
                    customItems: $viewModel.customConditions,
                    selected: $viewModel.selectedConditions,
                    isAdding: $viewModel.isAddingCondition,
                    inputText: $viewModel.conditionInput,
                    onSubmit: { viewModel.submitCondition() },
                    onRemoveCustom: { viewModel.removeCustomCondition($0) }
                )

                SelectableChipsSectionView(
                    title: "Allergies",
                    predefinedItems: viewModel.allAllergies,
                    customItems: $viewModel.customAllergies,
                    selected: $viewModel.selectedAllergies,
                    isAdding: $viewModel.isAddingAllergy,
                    inputText: $viewModel.allergyInput,
                    onSubmit: { viewModel.submitAllergy() },
                    onRemoveCustom: { viewModel.removeCustomAllergy($0) }
                )

                CustomPuffedButton(
                    title: "Save",
                    action: { /* TODO: backend save */  },
                    isLoading: viewModel.isLoading
                )
                .padding(.top, 8)
            }
            .padding(.horizontal, EditProfileSemantics.Spacing.screenHorizontal)
            .padding(.bottom, 120)
        }
        .background(
            Color.EditProfileSemantics.backgroundPrimary.ignoresSafeArea()
        )
        .navigationBarHidden(true)

    }
}
