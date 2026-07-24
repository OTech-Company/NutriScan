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

    let onSave: (FamilyMemberInput) -> Void
    let onDelete: (() -> Void)?   // nil in Add mode, provided in View mode

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

                // Drag handle + circular avatar/plus icon per mock
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
                if let onDelete {
                    Button(role: .destructive, action: {
                        onDelete()
                        dismiss()
                    }) {
                        Text("Delete Member")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color.Red.red500)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
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
    }
}
