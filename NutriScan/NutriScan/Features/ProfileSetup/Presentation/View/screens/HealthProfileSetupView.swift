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
    
    @State private var allAllergies = ["Peanuts", "Gluten", "Dairy"]
    @State private var allConditions = ["Diabetes", "Hypertension", "Celiac Disease"]
    
    @State private var selectedConditions: Set<String> = []
    @State private var selectedAllergies: Set<String> = []
    
    @State private var customConditions: [String] = []
    @State private var customAllergies: [String] = []
    
    // MARK: - Search Sheet States
    @State private var showConditionSearchSheet = false
    @State private var showAllergySearchSheet = false
    
    @State private var conditionSearchQuery = ""
    @State private var allergySearchQuery = ""

    // MARK: - Filtered Results for Search Sheets
    var filteredConditions: [String] {
        let unselected = allConditions.filter { !selectedConditions.contains($0) }
        if conditionSearchQuery.isEmpty { return unselected }
        return unselected.filter { $0.localizedCaseInsensitiveContains(conditionSearchQuery) }
    }
    
    var filteredAllergies: [String] {
        let unselected = allAllergies.filter { !selectedAllergies.contains($0) }
        if allergySearchQuery.isEmpty { return unselected }
        return unselected.filter { $0.localizedCaseInsensitiveContains(allergySearchQuery) }
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
                            items: allConditions.map { ProfileChipItem(name: $0, isSelected: selectedConditions.contains($0), isNewlyAdded: false) } +
                                   customConditions.map { ProfileChipItem(name: $0, isSelected: selectedConditions.contains($0), isNewlyAdded: true) },
                            onAddOther: { showConditionSearchSheet = true },
                            onToggle: { condition in
                                if selectedConditions.contains(condition) {
                                    selectedConditions.remove(condition)
                                } else {
                                    selectedConditions.insert(condition)
                                }
                            },
                            onRemove: removeCustomCondition
                        )
                        
                        SelectableChipsSectionView(
                            title: "Allergies",
                            items: allAllergies.map { ProfileChipItem(name: $0, isSelected: selectedAllergies.contains($0), isNewlyAdded: false) } +
                                   customAllergies.map { ProfileChipItem(name: $0, isSelected: selectedAllergies.contains($0), isNewlyAdded: true) },
                            onAddOther: { showAllergySearchSheet = true },
                            onToggle: { allergy in
                                if selectedAllergies.contains(allergy) {
                                    selectedAllergies.remove(allergy)
                                } else {
                                    selectedAllergies.insert(allergy)
                                }
                            },
                            onRemove: removeCustomAllergy
                        )
                    }
                    .padding(.horizontal, 22)
                    .padding(.bottom, 120)
                }
            }
            
            VStack {
                Spacer()
                CustomPuffedButton(
                    title: "Save",
                    action: {
                        flowCoordinator.finishProfileSetup()
                    }
                )
                .padding(.horizontal, 22)
                .padding(.bottom, 24)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showConditionSearchSheet) {
            SearchSelectionSheet(
                title: "Search Conditions",
                searchQuery: $conditionSearchQuery,
                results: filteredConditions,
                onSelect: { selectedCondition in
                    selectCondition(selectedCondition)
                }
            )
        }
        .sheet(isPresented: $showAllergySearchSheet) {
            SearchSelectionSheet(
                title: "Search Allergies",
                searchQuery: $allergySearchQuery,
                results: filteredAllergies,
                onSelect: { selectedAllergy in
                    selectAllergy(selectedAllergy)
                }
            )
        }
    }
    
    // MARK: - Actions: Conditions
    private func selectCondition(_ condition: String) {
        if !allConditions.contains(condition) && !customConditions.contains(condition) {
            customConditions.append(condition)
        }
        selectedConditions.insert(condition)
        conditionSearchQuery = ""
        showConditionSearchSheet = false
    }

    private func removeCustomCondition(_ condition: String) {
        customConditions.removeAll { $0 == condition }
        selectedConditions.remove(condition)
    }

    // MARK: - Actions: Allergies
    private func selectAllergy(_ allergy: String) {
        if !allAllergies.contains(allergy) && !customAllergies.contains(allergy) {
            customAllergies.append(allergy)
        }
        selectedAllergies.insert(allergy)
        allergySearchQuery = ""
        showAllergySearchSheet = false
    }

    private func removeCustomAllergy(_ allergy: String) {
        customAllergies.removeAll { $0 == allergy }
        selectedAllergies.remove(allergy)
    }
}

#Preview {
    HealthProfileSetupView()
}
