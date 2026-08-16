//
//  FamilyMemberSheetView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 25/07/2026.
//

import PhotosUI
import SwiftUI

struct FamilyMemberSheetView: View {
    @State private var viewModel: FamilyMemberSheetViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var isEditingMode: Bool
    @State private var activeAlert: ActiveAlert = .none
    @State private var selectedPhotoItem: PhotosPickerItem?

    let onSave: (FamilyMemberInput, Data?) async -> String?
    let onDelete: (() async -> String?)?

    init(
        existingMember: FamilyMember?,
        allMembers: [FamilyMember],
        onSave: @escaping (FamilyMemberInput, Data?) async -> String?,
        onDelete: (() async -> String?)? = nil
    ) {
        let vm = FamilyMemberSheetViewModel(
            existingMember: existingMember, allMembers: allMembers)
        _viewModel = State(initialValue: vm)
        _isEditingMode = State(initialValue: existingMember == nil)
        self.onSave = onSave
        self.onDelete = onDelete
    }

    private func performSave(input: FamilyMemberInput) {
        Task {
            viewModel.isSaving = true
            if let errorMessage = await onSave(
                input, viewModel.pendingImageData)
            {
                viewModel.errorMessage = errorMessage
                viewModel.alertContext = .networkError
                activeAlert = .error
            } else {
                dismiss()
            }
            viewModel.isSaving = false
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: EditProfileSemantics.Spacing.sectionVertical) {

                RoundedRectangle(
                    cornerRadius: ProfileSemantics.Radius.dragHandle
                )
                .fill(Color.Gray.gray400)
                .frame(
                    width: ProfileSemantics.Sizes.sheetDragHandleWidth,
                    height: ProfileSemantics.Sizes.sheetDragHandleHeight
                )
                .padding(.top, ProfileSemantics.Spacing.smallSpacing)

                PhotosPicker(
                    selection: $selectedPhotoItem, matching: .images,
                    photoLibrary: .shared()
                ) {
                    ZStack {
                        Circle()
                            .stroke(
                                Color.Teal.teal700,
                                lineWidth: ProfileSemantics.Border
                                    .avatarThickBorderWidth
                            )
                            .frame(
                                width: ProfileSemantics.Sizes.sheetAvatarSize,
                                height: ProfileSemantics.Sizes.sheetAvatarSize)

                        if let pendingData = viewModel.pendingImageData,
                            let uiImage = UIImage(data: pendingData)
                        {
                            Image(uiImage: uiImage)
                                .resizable().scaledToFill()
                                .frame(
                                    width: ProfileSemantics.Sizes
                                        .sheetAvatarSize,
                                    height: ProfileSemantics.Sizes
                                        .sheetAvatarSize
                                )
                                .clipShape(Circle())
                        } else if let imageUrlString = viewModel.existingMember?
                            .imageUrl, !imageUrlString.isEmpty
                        {
                            CachedImage(
                                urlString: imageUrlString,
                                failureImageName: "person.fill",
                                contentMode: .fill
                            )
                            .frame(
                                width: ProfileSemantics.Sizes.sheetAvatarSize,
                                height: ProfileSemantics.Sizes.sheetAvatarSize
                            )
                            .clipShape(Circle())
                        } else {
                            Image(
                                systemName: viewModel.isEditMode
                                    ? "person.fill" : "plus"
                            )
                            .font(
                                .system(
                                    size: ProfileSemantics.Sizes
                                        .sheetAvatarIconSize, weight: .medium)
                            )
                            .foregroundColor(Color.Teal.teal700)
                        }

                        if isEditingMode {
                            Image(systemName: "camera.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(Color.Teal.teal700)
                                .background(Circle().fill(.white))
                                .offset(
                                    x: ProfileSemantics.Sizes.sheetAvatarSize
                                        / 2.8,
                                    y: ProfileSemantics.Sizes.sheetAvatarSize
                                        / 2.8)
                        }
                    }
                    .padding(.top, ProfileSemantics.Spacing.smallSpacing)
                }
                .buttonStyle(.plain)
                .disabled(
                    !isEditingMode || viewModel.isSaving || viewModel.isDeleting
                )
                .onChange(of: selectedPhotoItem) { _, newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(
                            type: Data.self)
                        {
                            await viewModel.handleImageSelection(data: data)
                        }
                    }
                }

                VStack(spacing: EditProfileSemantics.Spacing.fieldVertical) {
                    VStack(spacing: ProfileSemantics.Spacing.smallSpacing) {
                        EditableFieldView(
                            placeholder: LocalizationKeys.Profile.memberNamePlaceholder.localized,
                            text: $viewModel.name.value,
                            isEditing: isEditingMode)
                        if viewModel.name.state == .error {
                            CustomTextFieldError(
                                errorMessage: viewModel.name.error)
                        }
                    }

                    VStack(spacing: ProfileSemantics.Spacing.smallSpacing) {
                        EditableFieldView(
                            placeholder: LocalizationKeys.Profile.relationPlaceholder.localized,
                            text: $viewModel.relation.value,
                            isEditing: isEditingMode)
                        if viewModel.relation.state == .error {
                            CustomTextFieldError(
                                errorMessage: viewModel.relation.error)
                        }
                    }
                }

                SelectableChipsSectionView(
                    title: LocalizationKeys.ProfileSetup.chronicConditions.localized,
                    items: viewModel.conditions.chips,
                    onAddOther: { viewModel.conditions.showSearchSheet = true },
                    onToggle: { viewModel.conditions.toggle($0) },
                    onRemove: { viewModel.conditions.remove($0) }
                ).disabled(!isEditingMode)

                SelectableChipsSectionView(
                    title: LocalizationKeys.ProfileSetup.allergies.localized, items: viewModel.allergies.chips,
                    onAddOther: { viewModel.allergies.showSearchSheet = true },
                    onToggle: { viewModel.allergies.toggle($0) },
                    onRemove: { viewModel.allergies.remove($0) }
                ).disabled(!isEditingMode)

                let buttonTitle: String = {
                    if !viewModel.isEditMode { return LocalizationKeys.Profile.addMember.localized }
                    return isEditingMode ? LocalizationKeys.Common.save.localized : LocalizationKeys.Common.edit.localized
                }()

                CustomPuffedButton(
                    title: buttonTitle,
                    action: {
                        if !viewModel.isEditMode {
                            // Adding new member flow
                            if viewModel.isDuplicate() {
                                viewModel.alertContext = .duplicate
                                activeAlert = .warning
                            } else if let input = viewModel.submit() {
                                performSave(input: input)
                            }
                        } else {
                            if isEditingMode {
                                if viewModel.validateFieldsOrInputs() {
                                    if viewModel.isDuplicate() {
                                        viewModel.alertContext = .duplicate
                                        activeAlert = .warning
                                    } else if viewModel.hasUnsavedChanges {
                                        viewModel.alertContext = .unsavedChanges
                                        activeAlert = .warning
                                    } else {
                                        withAnimation { isEditingMode = false }
                                    }
                                }
                            } else {
                                withAnimation { isEditingMode = true }
                            }
                        }
                    },
                    isLoading: viewModel.isLoading || viewModel.isSaving
                )
                .animation(.easeInOut, value: isEditingMode)
                .disabled(viewModel.isSaving || viewModel.isDeleting)

                if viewModel.isEditMode, onDelete != nil {
                    Button(action: {
                        viewModel.alertContext = .delete
                        activeAlert = .warning
                    }) {
                        Text(LocalizationKeys.Common.delete.localized)
                            .font(
                                .system(
                                    size: ProfileSemantics.Sizes.buttonTextSize,
                                    weight: .medium))
                    }
                    .buttonStyle(DeleteTextButtonStyle())
                    .padding(.top, ProfileSemantics.Spacing.tinySpacing)
                    .disabled(viewModel.isSaving || viewModel.isDeleting)
                }
            }
            .padding(.horizontal, EditProfileSemantics.Spacing.screenHorizontal)
            .padding(.bottom, ProfileSemantics.Spacing.sheetBottomPadding)
        }
        .background(
            Color.EditProfileSemantics.backgroundPrimary.ignoresSafeArea()
        )
        .overlay {
            if viewModel.isDeleting {
                ZStack {
                    Color.black.opacity(0.4).ignoresSafeArea()
                    ProgressView().tint(.white)
                }
            }
        }
        .task { await viewModel.loadReferenceData() }
        .sheet(isPresented: $viewModel.conditions.showSearchSheet) {
            SearchSelectionSheet(
                title: LocalizationKeys.ProfileSetup.searchConditions.localized,
                searchQuery: $viewModel.conditions.searchQuery,
                results: viewModel.conditions.filteredItems,
                placeholder: LocalizationKeys.ProfileSetup.searchConditionsPlaceholder.localized,
                onSelect: { viewModel.conditions.select($0) })
        }
        .sheet(isPresented: $viewModel.allergies.showSearchSheet) {
            SearchSelectionSheet(
                title: LocalizationKeys.ProfileSetup.searchAllergies.localized,
                searchQuery: $viewModel.allergies.searchQuery,
                results: viewModel.allergies.filteredItems,
                placeholder: LocalizationKeys.ProfileSetup.searchAllergiesPlaceholder.localized,
                onSelect: { viewModel.allergies.select($0) })
        }
        .customAlert(
            activeAlert: $activeAlert,
            config: { alert in
                switch alert {
                case .warning:
                    switch viewModel.alertContext {
                    case .duplicate:
                        return CustomAlertConfig(
                            type: .warning, title: LocalizationKeys.Profile.duplicateMemberTitle.localized,
                            description: LocalizationKeys.Profile.duplicateMemberDesc.localized,
                            primaryButtonTitle: LocalizationKeys.Common.ok.localized,
                            primaryButtonColor: Color.Teal.teal1000)
                    case .unsavedChanges:
                        return CustomAlertConfig(
                            type: .warning, title: LocalizationKeys.Profile.saveChangesTitle.localized,
                            description:
                                "You have modified this family member's details. Are you sure you want to save?",
                            primaryButtonTitle: LocalizationKeys.Common.save.localized,
                            primaryButtonColor: Color.Teal.teal1000,
                            secondaryButtonTitle: "Discard")
                    case .delete:
                        return CustomAlertConfig(
                            type: .warning, title: LocalizationKeys.Profile.deleteMemberTitle.localized,
                            description:
                                "Are you sure you want to delete this family member?",
                            primaryButtonTitle: LocalizationKeys.Common.delete.localized,
                            primaryButtonColor: Color.Red.red500,
                            secondaryButtonTitle: LocalizationKeys.Common.cancel.localized)
                    case .networkError:
                        return CustomAlertConfig(
                            type: .error, title: "", description: "")
                    }
                case .error:
                    return CustomAlertConfig(
                        type: .error, title: LocalizationKeys.Common.actionFailed.localized,
                        description: viewModel.errorMessage
                            ?? LocalizationKeys.Common.unknownError.localized,
                        primaryButtonTitle: LocalizationKeys.Common.ok.localized,
                        primaryButtonColor: Color.Teal.teal1000)
                default:
                    return CustomAlertConfig(
                        type: .warning, title: "", description: "")
                }
            },
            primaryAction: { alert in
                if alert == .warning {
                    switch viewModel.alertContext {
                    case .delete:
                        if let onDelete = onDelete {
                            Task {
                                viewModel.isDeleting = true
                                if let error = await onDelete() {
                                    viewModel.errorMessage = error
                                    viewModel.alertContext = .networkError
                                    activeAlert = .error
                                } else {
                                    dismiss()
                                }
                                viewModel.isDeleting = false
                            }
                        } else {
                            dismiss()
                        }
                    case .unsavedChanges:
                        if viewModel.isDuplicate() {
                            viewModel.alertContext = .duplicate
                            activeAlert = .warning
                        } else if let input = viewModel.submit() {
                            performSave(input: input)
                        }
                    case .duplicate, .networkError:
                        viewModel.errorMessage = nil
                    }
                } else if alert == .error {
                    viewModel.errorMessage = nil
                }
            },
            secondaryAction: { _ in
                if viewModel.alertContext == .unsavedChanges {
                    viewModel.revertChanges()
                    withAnimation { isEditingMode = false }
                }
            }
        )
        .environment(\.layoutDirection, AppLanguage.current.layoutDirection)
    }
}
