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
                        .foregroundColor(
                            Color.EditProfileSemantics.textSecondary)
                }
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(
                        alignment: .leading,
                        spacing: EditProfileSemantics.Spacing.sectionVertical
                    ) {
                        BackButton(action: { router.pop() }).padding(
                            .bottom,
                            EditProfileSemantics.Spacing.sectionVertical)

                        ProfileHeaderView(
                            name: viewModel.firstName.value + " "
                                + viewModel.lastName.value,
                            email: viewModel.email,
                            avatarImage: Image(systemName: "person.circle.fill")
                        )
                        .disabled(!isEditingMode)

                        VStack(
                            spacing: EditProfileSemantics.Spacing.fieldVertical
                        ) {

                            VStack(spacing: 4) {
                                EditableFieldView(
                                    placeholder: "first name",
                                    text: $viewModel.firstName.value,
                                    isEditing: isEditingMode)
                                if viewModel.firstName.state == .error {
                                    CustomTextFieldError(
                                        errorMessage: viewModel.firstName.error)
                                }
                            }

                            VStack(spacing: 4) {
                                EditableFieldView(
                                    placeholder: "last name",
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
                                        label: "Height",
                                        value: $viewModel.height.value,
                                        unit: "cm", isEditing: isEditingMode)
                                    if viewModel.height.state == .error {
                                        CustomTextFieldError(
                                            errorMessage: viewModel.height.error
                                        )
                                    }
                                }

                                VStack(spacing: 4) {
                                    MeasureFieldView(
                                        label: "Weight",
                                        value: $viewModel.weight.value,
                                        unit: "kg", isEditing: isEditingMode)
                                    if viewModel.weight.state == .error {
                                        CustomTextFieldError(
                                            errorMessage: viewModel.weight.error
                                        )
                                    }
                                }
                            }
                        }

                        SelectableChipsSectionView(
                            title: "Chronic Conditions",
                            items: viewModel.conditions.chips,
                            onAddOther: {
                                viewModel.conditions.showSearchSheet = true
                            },
                            onToggle: { viewModel.conditions.toggle($0) },
                            onRemove: { viewModel.conditions.remove($0) }
                        )
                        .disabled(!isEditingMode)

                        SelectableChipsSectionView(
                            title: "Allergies",
                            items: viewModel.allergies.chips,
                            onAddOther: {
                                viewModel.allergies.showSearchSheet = true
                            },
                            onToggle: { viewModel.allergies.toggle($0) },
                            onRemove: { viewModel.allergies.remove($0) }
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
                    .padding(
                        .horizontal,
                        EditProfileSemantics.Spacing.screenHorizontal
                    )
                    .padding(.bottom, 120)
                }
            }
        }
        .navigationBarHidden(true)
        // MARK: TODO
//        .onAppear {
//            withAnimation(.easeInOut(duration: 0.3)) {
//                tabBarVisibility.isHidden = true
//            }
//        }
//        .onDisappear {
//            withAnimation(.easeInOut(duration: 0.3)) {
//                tabBarVisibility.isHidden = false
//            }
//        }
        .task {
            isFetchingProfile = true
            await viewModel.loadInitialData()
            withAnimation(.easeIn(duration: 0.3)) {
                isFetchingProfile = false
            }
        }
        .sheet(isPresented: $viewModel.conditions.showSearchSheet) {
            SearchSelectionSheet(
                title: "Search Conditions",
                searchQuery: $viewModel.conditions.searchQuery,
                results: viewModel.conditions.filteredItems,
                onSelect: { selectedCondition in
                    viewModel.conditions.select(selectedCondition)
                }
            )
        }
        .sheet(isPresented: $viewModel.allergies.showSearchSheet) {
            SearchSelectionSheet(
                title: "Search Allergies",
                searchQuery: $viewModel.allergies.searchQuery,
                results: viewModel.allergies.filteredItems,
                onSelect: { selectedAllergy in
                    viewModel.allergies.select(selectedAllergy)
                }
            )
        }
    }
}
