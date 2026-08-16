//
//  HealthProfileView.swift
//  NutriScan
//
//  Created by Osama Hosam on 18/07/2026.
//

import SwiftUI

struct HealthProfileSetupView: View {
    private enum AlertDestination: String, Identifiable {
        case saveError
        var id: String { rawValue }
    }

    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator

    @Environment(\.colorScheme) var colorScheme
    
    @Bindable var viewModel: ProfileSetupFlowViewModel
    
    // MARK: - Search Sheet States
    @State private var showConditionSearchSheet = false
    @State private var showAllergySearchSheet = false
    
    @State private var conditionSearchQuery = ""
    @State private var allergySearchQuery = ""

    @State private var alert: AlertDestination?
    @State private var isFinishingSetup = false

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
                    
                    Text(LocalizationKeys.ProfileSetup.healthProfileTitle.localized)
                        .font(Font.AppFont.title2)
                        .foregroundStyle(Color.HealthProfileSetupSemantic.title)
                    
                    Text(LocalizationKeys.ProfileSetup.healthProfileSubtitle.localized)
                        .font(Font.AppFont.textSecondary)
                        .foregroundColor(Color.HealthProfileSetupSemantic.subtitle)
                        .lineSpacing(2)
                }
                .padding(.horizontal, 22)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        SelectableChipsSectionView(
                            title: LocalizationKeys.ProfileSetup.chronicConditions.localized,
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
                            title: LocalizationKeys.ProfileSetup.allergies.localized,
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
                    title: (viewModel.isSaving || isFinishingSetup) ? LocalizationKeys.ProfileSetup.saving.localized : LocalizationKeys.ProfileSetup.save.localized,
                    action: {
                        Task {
                            let success = await viewModel.saveProfile()
                            if success {
                                isFinishingSetup = true
                                await flowCoordinator.finishProfileSetup()
                            } else {
                                alert = .saveError
                            }
                        }
                    }
                )
                .disabled(viewModel.isSaving || isFinishingSetup)
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
                title: LocalizationKeys.ProfileSetup.searchConditions.localized,
                searchQuery: $conditionSearchQuery,
                results: filteredConditions.map(\.name),
                placeholder: LocalizationKeys.ProfileSetup.searchConditionsPlaceholder.localized,
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
                title: LocalizationKeys.ProfileSetup.searchAllergies.localized,
                searchQuery: $allergySearchQuery,
                results: filteredAllergies.map(\.name),
                placeholder: LocalizationKeys.ProfileSetup.searchAllergiesPlaceholder.localized,
                onSelect: { selectedAllergyName in
                    if let allg = viewModel.allAllergies.first(where: { $0.name == selectedAllergyName }) {
                        viewModel.toggleAllergy(allg)
                        allergySearchQuery = ""
                        showAllergySearchSheet = false
                    }
                }
            )
        }
        .customAlert(item: $alert, config: { _ in
            CustomAlertConfig(
                    type: .error,
                    title: LocalizationKeys.ProfileSetup.updateFailedTitle.localized,
                    message: viewModel.saveError ?? LocalizationKeys.Common.unknownError.localized,
                    primaryButton: CustomAlertButton(LocalizationKeys.Common.dismiss.localized)
                )
                )
        }, primaryAction: { _ in })
    }
}

#Preview {
    HealthProfileSetupView(viewModel: ProfileSetupFlowFactory.makeViewModel())
}
