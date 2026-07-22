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
    @State private var isEditingMode = false
    @State private var isFetchingProfile = true

    var body: some View {
        ZStack {
            Color.EditProfileSemantics.backgroundPrimary.ignoresSafeArea()

            if isFetchingProfile {
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(Color.EditProfileSemantics.titlePrimary)
                    
                    Text("Loading Profile...")
                        .font(.subheadline)
                        .foregroundColor(Color.EditProfileSemantics.textSecondary)
                }
            } else {
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
                        .disabled(!isEditingMode)

                        VStack(spacing: EditProfileSemantics.Spacing.fieldVertical) {
                            
                            VStack(spacing: 4) {
                                EditableFieldView(placeholder: "first name", text: $viewModel.firstName.value, isEditing: isEditingMode)
                                if viewModel.firstName.state == .error {
                                    CustomTextFieldError(errorMessage: viewModel.firstName.error)
                                }
                            }
                            
                            VStack(spacing: 4) {
                                EditableFieldView(placeholder: "last name", text: $viewModel.lastName.value, isEditing: isEditingMode)
                                if viewModel.lastName.state == .error {
                                    CustomTextFieldError(errorMessage: viewModel.lastName.error)
                                }
                            }

                            DateSelectionField(date: $viewModel.birthdate, isEditing: isEditingMode)

                            HStack(alignment: .top, spacing: 12) {
                                VStack(spacing: 4) {
                                    MeasureFieldView(label: "Height", value: $viewModel.height.value, unit: "cm", isEditing: isEditingMode)
                                    if viewModel.height.state == .error {
                                        CustomTextFieldError(errorMessage: viewModel.height.error)
                                    }
                                }
                                
                                VStack(spacing: 4) {
                                    MeasureFieldView(label: "Weight", value: $viewModel.weight.value, unit: "kg", isEditing: isEditingMode)
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
                        .disabled(!isEditingMode)

                        SelectableChipsSectionView(
                            title: "Allergies",
                            items: viewModel.allergyChips,
                            onAddOther: { viewModel.showAllergySearchSheet = true },
                            onToggle: { viewModel.toggleAllergy($0) },
                            onRemove: { viewModel.removeAllergy($0) }
                        )
                        .disabled(!isEditingMode)

                        CustomPuffedButton(
                            title: isEditingMode ? "Save" : "Edit",
                            action: {
                                if isEditingMode {
                                    Task {
                                        await viewModel.validateAndSave()
                                        if viewModel.errorMessage == nil {
                                            withAnimation {
                                                isEditingMode = false
                                            }
                                        }
                                    }
                                } else {
                                    withAnimation {
                                        isEditingMode = true
                                    }
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
            }
        }
        .navigationBarHidden(true)
        .task {
            isFetchingProfile = true
            await viewModel.loadInitialData()
            withAnimation(.easeIn(duration: 0.3)) {
                isFetchingProfile = false
            }
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
