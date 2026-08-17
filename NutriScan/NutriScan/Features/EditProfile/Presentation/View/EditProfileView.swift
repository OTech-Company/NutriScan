//
//  EditProfileView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 19/07/2026.
//
import SwiftUI

struct EditProfileView: View {
    private enum AlertDestination: String, Identifiable {
        case error
        case saveChanges
        var id: String { rawValue }
    }

    @EnvironmentObject private var router: AppRouter
    @State private var viewModel = EditProfileViewModel()
    @State private var isEditingMode = false
    @State private var alert: AlertDestination?

    var body: some View {
        ZStack {
            Color.EditProfileSemantics.backgroundPrimary.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(
                    alignment: .leading,
                    spacing: EditProfileSemantics.Spacing.sectionVertical
                ) {
                    BackButton(action: { router.pop() }).padding(
                        .bottom,
                        EditProfileSemantics.Spacing.sectionVertical)

                    EditProfileHeaderView(
                        name: viewModel.firstName.value + " "
                            + viewModel.lastName.value,
                        email: viewModel.email,
                        avatarURL: viewModel.avatarURL,
                        customImage: viewModel.avatarUIImage,
                        isEditing: isEditingMode,
                        selectedItem: $viewModel.selectedPhotoItem
                    )
                    .disabled(!isEditingMode)

                    VStack(
                        spacing: EditProfileSemantics.Spacing.fieldVertical
                    ) {

                        VStack(spacing: 4) {
                            EditableFieldView(
                                placeholder: LocalizationKeys.Auth.Register.firstNamePlaceholder.localized,
                                text: $viewModel.firstName.value,
                                isEditing: isEditingMode)
                            if viewModel.firstName.state == .error {
                                CustomTextFieldError(
                                    errorMessage: viewModel.firstName.error)
                            }
                        }

                        VStack(spacing: 4) {
                            EditableFieldView(
                                placeholder: LocalizationKeys.Auth.Register.lastNamePlaceholder.localized,
                                text: $viewModel.lastName.value,
                                isEditing: isEditingMode)
                            if viewModel.lastName.state == .error {
                                CustomTextFieldError(
                                    errorMessage: viewModel.lastName.error)
                            }
                        }

                        DateSelectionField(
                            date: $viewModel.birthdate,
                            isEditing: isEditingMode)

                        HStack(alignment: .top, spacing: 12) {
                            VStack(spacing: 4) {
                                MeasureFieldView(
                                    label: LocalizationKeys.Common.height.localized,
                                    value: $viewModel.height.value,
                                    unit: LocalizationKeys.Common.cm.localized, isEditing: isEditingMode)
                                if viewModel.height.state == .error {
                                    CustomTextFieldError(
                                        errorMessage: viewModel.height.error
                                    )
                                }
                            }

                            VStack(spacing: 4) {
                                MeasureFieldView(
                                    label: LocalizationKeys.Common.weight.localized,
                                    value: $viewModel.weight.value,
                                    unit: LocalizationKeys.Common.kg.localized, isEditing: isEditingMode)
                                if viewModel.weight.state == .error {
                                    CustomTextFieldError(
                                        errorMessage: viewModel.weight.error
                                    )
                                }
                            }
                        }
                    }

                    SelectableChipsSectionView(
                        title: LocalizationKeys.ProfileSetup.chronicConditions.localized,
                        items: viewModel.conditions.chips,
                        onAddOther: {
                            viewModel.conditions.showSearchSheet = true
                        },
                        onToggle: { viewModel.conditions.toggle($0) },
                        onRemove: { viewModel.conditions.remove($0) }
                    )
                    .disabled(!isEditingMode)

                    SelectableChipsSectionView(
                        title: LocalizationKeys.ProfileSetup.allergies.localized,
                        items: viewModel.allergies.chips,
                        onAddOther: {
                            viewModel.allergies.showSearchSheet = true
                        },
                        onToggle: { viewModel.allergies.toggle($0) },
                        onRemove: { viewModel.allergies.remove($0) }
                    )
                    .disabled(!isEditingMode)

                    CustomPuffedButton(
                        title: isEditingMode ? LocalizationKeys.Common.save.localized : LocalizationKeys.Common.edit.localized,
                        action: {
                            if isEditingMode {
                                if viewModel.validateFields() {
                                    if viewModel.hasUnsavedChanges {
                                        alert = .saveChanges
                                    } else {
                                        // Exit edit mode smoothly if no data changed
                                        withAnimation { isEditingMode = false }
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

                }
                .padding(
                    .horizontal,
                    EditProfileSemantics.Spacing.screenHorizontal
                )
                .padding(.bottom, 120)
            }
        }
        .onChange(of: viewModel.errorMessage) { _, error in
            if error != nil {
                alert = .error
            }
        }
        .customAlert(
            item: $alert,
            config: { alert in
                switch alert {
                case .error:
                    return CustomAlertConfig(
                        type: .error,
                        title: LocalizationKeys.Common.actionFailed.localized,
                        message: viewModel.errorMessage ?? LocalizationKeys.Common.unknownError.localized,
                        primaryButton: CustomAlertButton(LocalizationKeys.Common.ok.localized, role: .destructive)
                    )
                case .saveChanges:
                    return CustomAlertConfig(
                        type: .warning,
                        title: LocalizationKeys.Profile.saveChangesTitle.localized,
                        message: LocalizationKeys.EditProfile.saveChangesDesc.localized,
                        primaryButton: CustomAlertButton(LocalizationKeys.Common.save.localized, role: .standard),
                        secondaryButton: CustomAlertButton(LocalizationKeys.EditProfile.discard.localized, role: .cancel)
                    )
                }
            },
            primaryAction: { alert in
                switch alert {
                case .error:
                    viewModel.errorMessage = nil
                case .saveChanges:
                    Task {
                        await viewModel.performSave()
                        if viewModel.errorMessage == nil {
                            withAnimation { isEditingMode = false }
                        }
                    }
                }
            },
            secondaryAction: { alert in
                if alert == .saveChanges {
                    viewModel.revertChanges()
                    withAnimation { isEditingMode = false }
                }
            }
        )
        .navigationBarHidden(true)
        .task {
            // Background fetch just the reference items (allergies/diseases lists)
            await viewModel.loadReferenceData()
        }
        .sheet(isPresented: $viewModel.conditions.showSearchSheet) {
            SearchSelectionSheet(
                title: LocalizationKeys.ProfileSetup.searchConditions.localized,
                searchQuery: $viewModel.conditions.searchQuery,
                results: viewModel.conditions.filteredItems,
                placeholder: LocalizationKeys.ProfileSetup.searchConditionsPlaceholder.localized,
                onSelect: { selectedCondition in
                    viewModel.conditions.select(selectedCondition)
                }
            )
        }
        .sheet(isPresented: $viewModel.allergies.showSearchSheet) {
            SearchSelectionSheet(
                title: LocalizationKeys.ProfileSetup.searchAllergies.localized,
                searchQuery: $viewModel.allergies.searchQuery,
                results: viewModel.allergies.filteredItems,
                placeholder: LocalizationKeys.ProfileSetup.searchAllergiesPlaceholder.localized,
                onSelect: { selectedAllergy in
                    viewModel.allergies.select(selectedAllergy)
                }
            )
        }
        .onChange(of: viewModel.selectedPhotoItem) { _, _ in
            Task {
                await viewModel.loadSelectedImage()
            }
        }
    }
}
