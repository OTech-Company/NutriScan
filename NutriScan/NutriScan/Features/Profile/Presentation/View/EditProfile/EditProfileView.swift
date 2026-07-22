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
                    
                    VStack(spacing: 4) {
                        EditableFieldView(placeholder: "first name", text: $viewModel.firstName.value)
                        if viewModel.firstName.state == .error {
                            CustomTextFieldError(errorMessage: viewModel.firstName.error)
                        }
                    }
                    
                    VStack(spacing: 4) {
                        EditableFieldView(placeholder: "last name", text: $viewModel.lastName.value)
                        if viewModel.lastName.state == .error {
                            CustomTextFieldError(errorMessage: viewModel.lastName.error)
                        }
                    }

                    DateSelectionField(date: $viewModel.birthdate)

                    HStack(alignment: .top, spacing: 12) {
                        VStack(spacing: 4) {
                            MeasureFieldView(label: "Height", value: $viewModel.height.value, unit: "cm")
                            if viewModel.height.state == .error {
                                CustomTextFieldError(errorMessage: viewModel.height.error)
                            }
                        }
                        
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
                    items: viewModel.conditionChips,
                    onAddOther: { viewModel.showConditionSearchSheet = true },
                    onToggle: { viewModel.toggleCondition($0) },
                    onRemove: { viewModel.removeCondition($0) }
                )

                SelectableChipsSectionView(
                    title: "Allergies",
                    items: viewModel.allergyChips,
                    onAddOther: { viewModel.showAllergySearchSheet = true },
                    onToggle: { viewModel.toggleAllergy($0) },
                    onRemove: { viewModel.removeAllergy($0) }
                )

                CustomPuffedButton(
                    title: "Save",
                    action: {
                        Task {
                            await viewModel.validateAndSave()
                        }
                    },
                    isLoading: viewModel.isLoading
                )
                .animation(.easeInOut, value: viewModel.isLoading)
                .padding(.top, 8)
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.top, 8)
                }
            }
            .padding(.horizontal, EditProfileSemantics.Spacing.screenHorizontal)
            .padding(.bottom, 120)
        }
        .background(
            Color.EditProfileSemantics.backgroundPrimary.ignoresSafeArea()
        )
        .navigationBarHidden(true)
        .task {
            await viewModel.loadInitialData()
        }
        .sheet(isPresented: $viewModel.showConditionSearchSheet) {
            SearchSelectionSheet(
                title: "Search Conditions",
                searchQuery: $viewModel.conditionSearchQuery,
                results: viewModel.filteredConditions,
                onSelect: { selectedCondition in
                    viewModel.selectCondition(selectedCondition)
                }
            )
        }
        .sheet(isPresented: $viewModel.showAllergySearchSheet) {
            SearchSelectionSheet(
                title: "Search Allergies",
                searchQuery: $viewModel.allergySearchQuery,
                results: viewModel.filteredAllergies,
                onSelect: { selectedAllergy in
                    viewModel.selectAllergy(selectedAllergy)
                }
            )
        }
    }
}
