//
//  FamilyMemberSheetView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 25/07/2026.
//

import SwiftUI

// MARK: - Custom Button Style
/// Handles both pointer hover (iPadOS/macOS) and touch press (iOS) states
struct DeleteTextButtonStyle: ButtonStyle {
    @State private var isHovering = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            // Applies the requested red color on either touch or pointer hover
            .foregroundColor(configuration.isPressed || isHovering ? Color.red : Color.Gray.gray400)
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isHovering = hovering
                }
            }
    }
}

// MARK: - View
struct FamilyMemberSheetView: View {
    @State private var viewModel: FamilyMemberSheetViewModel
    @Environment(\.dismiss) private var dismiss

    // MARK: - Alert State
    @State private var activeAlert: ActiveAlert = .none

    let onSave: (FamilyMemberInput) -> Void
    let onDelete: (() -> Void)?

    init(
        existingMember: FamilyMember?,
        onSave: @escaping (FamilyMemberInput) -> Void,
        onDelete: (() -> Void)? = nil
    ) {
        _viewModel = State(initialValue: FamilyMemberSheetViewModel(existingMember: existingMember))
        self.onSave = onSave
        self.onDelete = onDelete
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: EditProfileSemantics.Spacing.sectionVertical) {

                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.Gray.gray400)
                    .frame(width: 40, height: 5)
                    .padding(.top, 8)

                ZStack {
                    Circle()
                        .stroke(Color.Teal.teal700, lineWidth: 1.5)
                        .frame(width: 90, height: 90)

                    Image(systemName: viewModel.isEditMode ? "person.fill" : "plus")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(Color.Teal.teal700)
                }
                .padding(.top, 8)

                VStack(spacing: EditProfileSemantics.Spacing.fieldVertical) {
                    VStack(spacing: 4) {
                        EditableFieldView(
                            placeholder: "Member name",
                            text: $viewModel.name.value,
                            isEditing: true
                        )
                        if viewModel.name.state == .error {
                            CustomTextFieldError(errorMessage: viewModel.name.error)
                        }
                    }

                    VStack(spacing: 4) {
                        EditableFieldView(
                            placeholder: "Relation (e.g. Son, Mother)",
                            text: $viewModel.relation.value,
                            isEditing: true
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

                SelectableChipsSectionView(
                    title: "Allergies",
                    items: viewModel.allergies.chips,
                    onAddOther: { viewModel.allergies.showSearchSheet = true },
                    onToggle: { viewModel.allergies.toggle($0) },
                    onRemove: { viewModel.allergies.remove($0) }
                )

                CustomPuffedButton(
                    title: viewModel.isEditMode ? "Save Changes" : "Add Member",
                    action: {
                        if let input = viewModel.submit() {
                            onSave(input)
                            dismiss()
                        }
                    },
                    isLoading: viewModel.isLoading
                )

                // Delete button — only present when viewing an existing member.
                if onDelete != nil {
                    Button(action: {
                        activeAlert = .warning
                    }) {
                        Text("Delete")
                            .font(.system(size: 16, weight: .medium))
                    }
                    // Apply the custom interactive style
                    .buttonStyle(DeleteTextButtonStyle())
                    .padding(.top, 4)
                }
            }
            .padding(.horizontal, EditProfileSemantics.Spacing.screenHorizontal)
            .padding(.bottom, 32)
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
                    return CustomAlertConfig(
                        type: .warning,
                        title: "Delete Member",
                        description: "Are you sure you want to delete this family member? This action cannot be undone.",
                        primaryButtonTitle: "Delete",
                        primaryButtonColor: Color.Red.red500, // Or swap to Color.red if preferred
                        secondaryButtonTitle: "Cancel"
                    )
                default:
                    return CustomAlertConfig(type: .warning, title: "", description: "")
                }
            },
            primaryAction: { alert in
                if alert == .warning {
                    onDelete?()
                    dismiss()
                }
            },
            secondaryAction: { _ in }
        )
    }
}
