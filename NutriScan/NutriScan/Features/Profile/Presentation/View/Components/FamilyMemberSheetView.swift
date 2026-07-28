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

    // MARK: - Alert State
    @State private var activeAlert: ActiveAlert = .none
    
    // Tracks if the form is currently editable
    @State private var isEditingForm: Bool

    let onSave: (FamilyMemberInput) -> Void
    let onDelete: (() -> Void)?

    init(
        existingMember: FamilyMember?,
        allMembers: [FamilyMember],
        onSave: @escaping (FamilyMemberInput) -> Void,
        onDelete: (() -> Void)? = nil
    ) {
        _viewModel = State(initialValue: FamilyMemberSheetViewModel(existingMember: existingMember, allMembers: allMembers))
        // New members are editable by default, existing members start in view-only mode
        _isEditingForm = State(initialValue: existingMember == nil)
        self.onSave = onSave
        self.onDelete = onDelete
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: EditProfileSemantics.Spacing.sectionVertical) {

                RoundedRectangle(cornerRadius: ProfileSemantics.Radius.dragHandle)
                    .fill(Color.Gray.gray400)
                    .frame(
                        width: ProfileSemantics.Sizes.sheetDragHandleWidth,
                        height: ProfileSemantics.Sizes.sheetDragHandleHeight
                    )
                    .padding(.top, ProfileSemantics.Spacing.smallSpacing)

                ZStack {
                    Circle()
                        .stroke(Color.Teal.teal700, lineWidth: ProfileSemantics.Border.avatarThickBorderWidth)
                        .frame(
                            width: ProfileSemantics.Sizes.sheetAvatarSize,
                            height: ProfileSemantics.Sizes.sheetAvatarSize
                        )

                    Image(systemName: viewModel.isEditMode ? "person.fill" : "plus")
                        .font(.system(size: ProfileSemantics.Sizes.sheetAvatarIconSize, weight: .medium))
                        .foregroundColor(Color.Teal.teal700)
                }
                .padding(.top, ProfileSemantics.Spacing.smallSpacing)

                VStack(spacing: EditProfileSemantics.Spacing.fieldVertical) {
                    VStack(spacing: ProfileSemantics.Spacing.smallSpacing) {
                        EditableFieldView(
                            placeholder: "Member name",
                            text: $viewModel.name.value,
                            isEditing: isEditingForm
                        )
                        if viewModel.name.state == .error {
                            CustomTextFieldError(errorMessage: viewModel.name.error)
                        }
                    }

                    VStack(spacing: ProfileSemantics.Spacing.smallSpacing) {
                        EditableFieldView(
                            placeholder: "Relation (e.g. Son, Mother)",
                            text: $viewModel.relation.value,
                            isEditing: isEditingForm
                        )
                        if viewModel.relation.state == .error {
                            CustomTextFieldError(errorMessage: viewModel.relation.error)
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
                .disabled(!isEditingForm)

                SelectableChipsSectionView(
                    title: "Allergies",
                    items: viewModel.allergies.chips,
                    onAddOther: { viewModel.allergies.showSearchSheet = true },
                    onToggle: { viewModel.allergies.toggle($0) },
                    onRemove: { viewModel.allergies.remove($0) }
                )
                .disabled(!isEditingForm)

                CustomPuffedButton(
                    title: viewModel.isEditMode ? (isEditingForm ? "Save" : "Edit") : "Add Member",
                    action: {
                        if !viewModel.isEditMode {
                            // Flow for adding a NEW member
                            if viewModel.isDuplicate() {
                                viewModel.alertContext = .duplicate
                                activeAlert = .warning
                            } else if let input = viewModel.submit() {
                                onSave(input)
                                dismiss()
                            }
                        } else {
                            // Flow for editing an EXISTING member
                            if isEditingForm {
                                if viewModel.validate() {
                                    if viewModel.hasUnsavedChanges {
                                        if viewModel.isDuplicate() {
                                            viewModel.alertContext = .duplicate
                                            activeAlert = .warning
                                        } else {
                                            // Trigger confirmation alert for unsaved changes
                                            viewModel.alertContext = .unsavedChanges
                                            activeAlert = .warning
                                        }
                                    } else {
                                        // No changes made, seamlessly switch back to view mode
                                        withAnimation { isEditingForm = false }
                                    }
                                }
                            } else {
                                // Switch to edit mode
                                withAnimation { isEditingForm = true }
                            }
                        }
                    },
                    isLoading: viewModel.isLoading
                )

                if onDelete != nil {
                    Button(action: {
                        viewModel.alertContext = .delete
                        activeAlert = .warning
                    }) {
                        Text("Delete")
                            .font(.system(size: ProfileSemantics.Sizes.buttonTextSize, weight: .medium))
                    }
                    .buttonStyle(DeleteTextButtonStyle())
                    .padding(.top, ProfileSemantics.Spacing.tinySpacing)
                }
            }
            .padding(.horizontal, EditProfileSemantics.Spacing.screenHorizontal)
            .padding(.bottom, ProfileSemantics.Spacing.sheetBottomPadding)
        }
        .background(Color.EditProfileSemantics.backgroundPrimary.ignoresSafeArea())
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
                    if viewModel.alertContext == .duplicate {
                        return CustomAlertConfig(
                            type: .warning,
                            title: "Duplicate Member",
                            description: "this family member already exist",
                            primaryButtonTitle: "Ok",
                            primaryButtonColor: Color.Teal.teal1000
                        )
                    } else if viewModel.alertContext == .unsavedChanges {
                        return CustomAlertConfig(
                            type: .warning,
                            title: "Save Changes",
                            description: "You have modified this family member's data. Are you sure you want to save these changes?",
                            primaryButtonTitle: "Save",
                            primaryButtonColor: Color.Teal.teal1000,
                            secondaryButtonTitle: "Discard"
                        )
                    } else {
                        return CustomAlertConfig(
                            type: .warning,
                            title: "Delete Member",
                            description: "Are you sure you want to delete this family member? This action cannot be undone.",
                            primaryButtonTitle: "Delete",
                            primaryButtonColor: Color.Red.red500,
                            secondaryButtonTitle: "Cancel"
                        )
                    }
                default:
                    return CustomAlertConfig(type: .warning, title: "", description: "")
                }
            },
            primaryAction: { alert in
                if alert == .warning {
                    if viewModel.alertContext == .delete {
                        onDelete?()
                        dismiss()
                    } else if viewModel.alertContext == .unsavedChanges {
                        // User confirmed changes, trigger save and dismiss
                        if let input = viewModel.submit() {
                            onSave(input)
                            dismiss()
                        }
                    }
                }
            },
            secondaryAction: { alert in
                if alert == .warning && viewModel.alertContext == .unsavedChanges {
                    // User opted to discard changes
                    viewModel.revertChanges()
                    withAnimation { isEditingForm = false }
                }
            }
        )
    }
}
