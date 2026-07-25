//
//  HealthProfileView.swift
//  NutriScan
//
//  Created by Osama Hosam on 18/07/2026.
//

import SwiftUI

struct HealthProfileSetupView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator

    @Environment(\.colorScheme) var colorScheme
    
    @Bindable var viewModel: ProfileSetupFlowViewModel
    
    // MARK: - Search Sheet States
    @State private var showConditionSearchSheet = false
    @State private var showAllergySearchSheet = false
    
    @State private var conditionSearchQuery = ""
    @State private var allergySearchQuery = ""

    @State private var activeAlert: ActiveAlert = .none

    // MARK: - Filtered Results for Search Sheets
    var filteredConditions: [ProfileSetupDiseaseOption] {
        let unselected = viewModel.allConditions.filter { !viewModel.selectedConditions.contains($0) }
        if conditionSearchQuery.isEmpty { return unselected }
        return unselected.filter { $0.name.localizedCaseInsensitiveContains(conditionSearchQuery) }
    }
    
    var filteredAllergies: [ProfileSetupAllergyOption] {
        let unselected = viewModel.allAllergies.filter { !viewModel.selectedAllergies.contains($0) }
        if allergySearchQuery.isEmpty { return unselected }
        return unselected.filter { $0.name.localizedCaseInsensitiveContains(allergySearchQuery) }
    }

    var body: some View {
            
        ZStack {
            Color.HealthProfileSetupSemantic.background
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Image(colorScheme == .dark ? "right_top_corner_dark" : "right_top_corner_light")
                }
                Spacer()
            }
            .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Spacer()
                        .frame(width: 22)
                    Image(colorScheme == .dark ? "hearts_dark" : "hearts_light")
                    Spacer()
                }
                Spacer()
            }
            
            VStack {
                HStack {
                    BackButton(action: { router.pop() })
                    Spacer()
                }
                .padding(.leading, 22)
                Spacer()
            }
            .zIndex(1)
            
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    
                    Spacer()
                        .frame(height: 150)
                    
                    Text("Setup Your Health\nProfile")
                        .font(Font.AppFont.title2)
                        .foregroundStyle(Color.HealthProfileSetupSemantic.title)
                    
                    Text("Help us tailor NutriScan to your specific dietary\nneeds and health conditions.")
                        .font(Font.AppFont.textSecondary)
                        .foregroundColor(Color.HealthProfileSetupSemantic.subtitle)
                        .lineSpacing(2)
                }
                .padding(.horizontal, 22)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        SelectableChipsSectionView(
                            title: "Chronic Conditions",
                            items: viewModel.allConditions.map { ProfileChipItem(name: $0.name, isSelected: viewModel.selectedConditions.contains($0), isNewlyAdded: false) },
                            onAddOther: { showConditionSearchSheet = true },
                            onToggle: { conditionName in
                                if let option = viewModel.allConditions.first(where: { $0.name == conditionName }) {
                                    viewModel.toggleCondition(option)
                                }
                            },
                            onRemove: { _ in }
                        )
                        
                        SelectableChipsSectionView(
                            title: "Allergies",
                            items: viewModel.allAllergies.map { ProfileChipItem(name: $0.name, isSelected: viewModel.selectedAllergies.contains($0), isNewlyAdded: false) },
                            onAddOther: { showAllergySearchSheet = true },
                            onToggle: { allergyName in
                                if let option = viewModel.allAllergies.first(where: { $0.name == allergyName }) {
                                    viewModel.toggleAllergy(option)
                                }
                            },
                            onRemove: { _ in }
                        )
                    }
                    .padding(.horizontal, 22)
                    .padding(.bottom, 120)
                }
            }
            
            VStack {
                Spacer()
                CustomPuffedButton(
                    title: viewModel.isSaving ? "Saving..." : "Save",
                    action: {
                        Task {
                            let success = await viewModel.saveProfile()
                            if success {
                                flowCoordinator.finishProfileSetup()
                            } else {
                                activeAlert = .error
                            }
                        }
                    }
                )
                .disabled(viewModel.isSaving)
                .padding(.horizontal, 22)
                .padding(.bottom, 24)
            }
        }
        .task {
            await viewModel.loadHealthProfileOptions()
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showConditionSearchSheet) {
            SearchSelectionSheet(
                title: "Search Conditions",
                searchQuery: $conditionSearchQuery,
                results: filteredConditions.map(\.name),
                onSelect: { selectedConditionName in
                    if let cond = viewModel.allConditions.first(where: { $0.name == selectedConditionName }) {
                        viewModel.toggleCondition(cond)
                        conditionSearchQuery = ""
                        showConditionSearchSheet = false
                    }
                }
            )
        }
        .sheet(isPresented: $showAllergySearchSheet) {
            SearchSelectionSheet(
                title: "Search Allergies",
                searchQuery: $allergySearchQuery,
                results: filteredAllergies.map(\.name),
                onSelect: { selectedAllergyName in
                    if let allg = viewModel.allAllergies.first(where: { $0.name == selectedAllergyName }) {
                        viewModel.toggleAllergy(allg)
                        allergySearchQuery = ""
                        showAllergySearchSheet = false
                    }
                }
            )
        }
        .customAlert(activeAlert: $activeAlert, config: { alert in
            switch alert {
            case .error:
                return CustomAlertConfig(
                    type: .error,
                    title: "Update Failed",
                    description: viewModel.saveError ?? "An unknown error occurred while saving your profile.",
                    primaryButtonTitle: "Dismiss"
                )
            default:
                return CustomAlertConfig(type: .error, title: "", description: "")
            }
        }, primaryAction: { _ in })
    }
}

#Preview {
    HealthProfileSetupView(viewModel: ProfileSetupFlowFactory.makeViewModel())
}
