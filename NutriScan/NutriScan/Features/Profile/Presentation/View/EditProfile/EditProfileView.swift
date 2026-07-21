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
                    name: viewModel.firstName.value + " " + viewModel.lastName.value,
                    email: viewModel.email,
                    avatarImage: Image(systemName: "person.circle.fill")
                )

                VStack(spacing: EditProfileSemantics.Spacing.fieldVertical) {
                    
                    // First Name Field
                    VStack(spacing: 4) {
                        EditableFieldView(placeholder: "first name", text: $viewModel.firstName.value)
                        if viewModel.firstName.state == .error {
                            CustomTextFieldError(errorMessage: viewModel.firstName.error)
                        }
                    }
                    
                    // Last Name Field
                    VStack(spacing: 4) {
                        EditableFieldView(placeholder: "last name", text: $viewModel.lastName.value)
                        if viewModel.lastName.state == .error {
                            CustomTextFieldError(errorMessage: viewModel.lastName.error)
                        }
                    }

                    DateSelectionField(date: $viewModel.birthdate)

                    HStack(alignment: .top, spacing: 12) {
                        // Height Field
                        VStack(spacing: 4) {
                            MeasureFieldView(label: "Height", value: $viewModel.height.value, unit: "cm")
                            if viewModel.height.state == .error {
                                CustomTextFieldError(errorMessage: viewModel.height.error)
                            }
                        }
                        
                        // Weight Field
                        VStack(spacing: 4) {
                            MeasureFieldView(label: "Weight", value: $viewModel.weight.value, unit: "kg")
                            if viewModel.weight.state == .error {
                                CustomTextFieldError(errorMessage: viewModel.weight.error)
                            }
                        }
                    }
                }
                
                SelectableChipsSectionView(
                    title: "Chronic Conditions",
                    predefinedItems: viewModel.allConditions,
                    customItems: $viewModel.customConditions,
                    selected: $viewModel.selectedConditions,
                    onAddOther: { viewModel.showConditionSearchSheet = true },
                    onRemoveCustom: { viewModel.removeCustomCondition($0) }
                )

                SelectableChipsSectionView(
                    title: "Allergies",
                    predefinedItems: viewModel.allAllergies,
                    customItems: $viewModel.customAllergies,
                    selected: $viewModel.selectedAllergies,
                    onAddOther: { viewModel.showAllergySearchSheet = true },
                    onRemoveCustom: { viewModel.removeCustomAllergy($0) }
                )

                CustomPuffedButton(
                    title: "Save",
                    action: {
                        withAnimation {
                            viewModel.validateAndSave()
                        }
                    },
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
        // MARK: - Condition Search Sheet
        .sheet(isPresented: $viewModel.showConditionSearchSheet) {
            SearchSelectionSheet(
                title: "Search Conditions",
                searchQuery: $viewModel.conditionSearchQuery,
                results: viewModel.filteredConditions,
                onSelect: { selectedCondition in
                    viewModel.selectCustomCondition(selectedCondition)
                }
            )
        }
        // MARK: - Allergy Search Sheet
        .sheet(isPresented: $viewModel.showAllergySearchSheet) {
            SearchSelectionSheet(
                title: "Search Allergies",
                searchQuery: $viewModel.allergySearchQuery,
                results: viewModel.filteredAllergies,
                onSelect: { selectedAllergy in
                    viewModel.selectCustomAllergy(selectedAllergy)
                }
            )
        }
    }
}
