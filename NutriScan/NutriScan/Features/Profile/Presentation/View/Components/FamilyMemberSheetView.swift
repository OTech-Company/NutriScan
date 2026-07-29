//
//  FamilyMemberSheetView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 25/07/2026.
//

import SwiftUI

struct FamilyMemberSheetView: View {
    @State private var viewModel: FamilyMemberSheetViewModel
    @Environment(\.dismiss) private var dismiss

    // MARK: - Local Edit & Alert States
    @State private var isEditingMode: Bool
    @State private var activeAlert: ActiveAlert = .none

    let onSave: (FamilyMemberInput) -> Void
    let onDelete: (() -> Void)?

    init(
        existingMember: FamilyMember?,
        allMembers: [FamilyMember],
        onSave: @escaping (FamilyMemberInput) -> Void,
        onDelete: (() -> Void)? = nil
    ) {
        let vm = FamilyMemberSheetViewModel(
            existingMember: existingMember, allMembers: allMembers)
        _viewModel = State(initialValue: vm)
        // If it's a new member, start directly in editing mode. If editing, start locked.
        _isEditingMode = State(initialValue: existingMember == nil)
        self.onSave = onSave
        self.onDelete = onDelete
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

                ZStack {
                    Circle()
                        .stroke(
                            Color.Teal.teal700,
                            lineWidth: ProfileSemantics.Border
                                .avatarThickBorderWidth
                        )
                        .frame(
                            width: ProfileSemantics.Sizes.sheetAvatarSize,
                            height: ProfileSemantics.Sizes.sheetAvatarSize
                        )

                    Image(
                        systemName: viewModel.isEditMode
                            ? "person.fill" : "plus"
                    )
                    .font(
                        .system(
                            size: ProfileSemantics.Sizes.sheetAvatarIconSize,
                            weight: .medium)
                    )
                    .foregroundColor(Color.Teal.teal700)
                }
                .padding(.top, ProfileSemantics.Spacing.smallSpacing)

                VStack(spacing: EditProfileSemantics.Spacing.fieldVertical) {
                    VStack(spacing: ProfileSemantics.Spacing.smallSpacing) {
                        EditableFieldView(
                            placeholder: "Member name",
                            text: $viewModel.name.value,
                            isEditing: isEditingMode
                        )
                        if viewModel.name.state == .error {
                            CustomTextFieldError(
                                errorMessage: viewModel.name.error)
                        }
                    }

                    VStack(spacing: ProfileSemantics.Spacing.smallSpacing) {
                        EditableFieldView(
                            placeholder: "Relation (e.g. Son, Mother)",
                            text: $viewModel.relation.value,
                            isEditing: isEditingMode
                        )
                        if viewModel.relation.state == .error {
                            CustomTextFieldError(
                                errorMessage: viewModel.relation.error)
                        }
                    }
                }

                SelectableChipsSectionView(
                    title: "Chronic Conditions",
                    items: viewModel.conditions.chips,
                    onAddOther: { viewModel.conditions.showSearchSheet = true },
                    onToggle: { viewModel.conditions.toggle($0) },
                    onRemove: { viewModel.conditions.remove($0) }
                )
                .disabled(!isEditingMode)

                SelectableChipsSectionView(
                    title: "Allergies",
                    items: viewModel.allergies.chips,
                    onAddOther: { viewModel.allergies.showSearchSheet = true },
                    onToggle: { viewModel.allergies.toggle($0) },
                    onRemove: { viewModel.allergies.remove($0) }
                )
                .disabled(!isEditingMode)

                // Dynamic Button Text: "Edit" -> "Save" / "Add Member"
                let buttonTitle: String = {
                    if !viewModel.isEditMode { return "Add Member" }
                    return isEditingMode ? "Save" : "Edit"
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
                                onSave(input)
                                dismiss()
                            }
                        } else {
                            // Editing existing member flow
                            if isEditingMode {
                                if viewModel.validateFieldsOrInputs() {
                                    if viewModel.isDuplicate() {
                                        viewModel.alertContext = .duplicate
                                        activeAlert = .warning
                                    } else if viewModel.hasUnsavedChanges {
                                        viewModel.alertContext = .unsavedChanges
                                        activeAlert = .warning
                                    } else {
                                        dismiss()
                                    }
                                }
                            } else {
                                // Switch from "Edit" to "Save" mode
                                withAnimation { isEditingMode = true }
                            }
                        }
                    },
                    isLoading: viewModel.isLoading
                )
                .animation(.easeInOut, value: isEditingMode)

                if viewModel.isEditMode, onDelete != nil {
                    Button(action: {
                        viewModel.alertContext = .delete
                        activeAlert = .warning
                    }) {
                        Text("Delete")
                            .font(
                                .system(
                                    size: ProfileSemantics.Sizes.buttonTextSize,
                                    weight: .medium))
                    }
                    .buttonStyle(DeleteTextButtonStyle())
                    .padding(.top, ProfileSemantics.Spacing.tinySpacing)
                }
            }
            .padding(.horizontal, EditProfileSemantics.Spacing.screenHorizontal)
            .padding(.bottom, ProfileSemantics.Spacing.sheetBottomPadding)
        }
        .background(
            Color.EditProfileSemantics.backgroundPrimary.ignoresSafeArea()
        )
        .task {
            await viewModel.loadReferenceData()
        }
        .sheet(isPresented: $viewModel.conditions.showSearchSheet) {
            SearchSelectionSheet(
                title: "Search Conditions",
                searchQuery: $viewModel.conditions.searchQuery,
                results: viewModel.conditions.filteredItems,
                onSelect: { viewModel.conditions.select($0) }
            )
        }
        .sheet(isPresented: $viewModel.allergies.showSearchSheet) {
            SearchSelectionSheet(
                title: "Search Allergies",
                searchQuery: $viewModel.allergies.searchQuery,
                results: viewModel.allergies.filteredItems,
                onSelect: { viewModel.allergies.select($0) }
            )
        }
        // MARK: - Custom Alert Modifier
        .customAlert(
            activeAlert: $activeAlert,
            config: { alert in
                switch alert {
                case .warning:
                    switch viewModel.alertContext {
                    case .duplicate:
                        return CustomAlertConfig(
                            type: .warning,
                            title: "Duplicate Member",
                            description: "This family member already exists.",
                            primaryButtonTitle: "Ok",
                            primaryButtonColor: Color.Teal.teal1000
                        )
                    case .unsavedChanges:
                        return CustomAlertConfig(
                            type: .warning,
                            title: "Save Changes",
                            description:
                                "You have modified this family member's details. Are you sure you want to save?",
                            primaryButtonTitle: "Save",
                            primaryButtonColor: Color.Teal.teal1000,
                            secondaryButtonTitle: "Discard"
                        )
                    case .delete:
                        return CustomAlertConfig(
                            type: .warning,
                            title: "Delete Member",
                            description:
                                "Are you sure you want to delete this family member? This action cannot be undone.",
                            primaryButtonTitle: "Delete",
                            primaryButtonColor: Color.Red.red500,
                            secondaryButtonTitle: "Cancel"
                        )
                    }
                default:
                    return CustomAlertConfig(
                        type: .warning, title: "", description: "")
                }
            },
            primaryAction: { alert in
                if alert == .warning {
                    switch viewModel.alertContext {
                    case .delete:
                        onDelete?()
                        dismiss()
                    case .unsavedChanges:
                        if viewModel.isDuplicate() {
                            viewModel.alertContext = .duplicate
                            activeAlert = .warning
                        } else if let input = viewModel.submit() {
                            onSave(input)
                            dismiss()
                        }
                    case .duplicate:
                        viewModel.errorMessage = nil
                    }
                }
            },
            secondaryAction: { _ in
                if viewModel.alertContext == .unsavedChanges {
                    viewModel.revertChanges()
                    withAnimation { isEditingMode = false }
                }
            }
        )
    }
}
