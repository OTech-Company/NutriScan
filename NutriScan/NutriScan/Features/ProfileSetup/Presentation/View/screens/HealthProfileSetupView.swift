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
    
    @State private var isAddingCondition = false
    @State private var isAddingAllergy = false
    
    @State private var conditionInput = ""
    @State private var allergyInput = ""

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
                            predefinedItems: allConditions,
                            customItems: $customConditions,
                            selected: $selectedConditions,
                            isAdding: $isAddingCondition,
                            inputText: $conditionInput,
                            onSubmit: submitCondition,
                            onRemoveCustom: removeCustomCondition
                        )
                        
                        SelectableChipsSectionView(
                            title: "Allergies",
                            predefinedItems: allAllergies,
                            customItems: $customAllergies,
                            selected: $selectedAllergies,
                            isAdding: $isAddingAllergy,
                            inputText: $allergyInput,
                            onSubmit: submitAllergy,
                            onRemoveCustom: removeCustomAllergy
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
    }
    
    // MARK: - Actions: Conditions
    private func submitCondition() {
        let trimmed = conditionInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            isAddingCondition = false
            return
        }
        let allExisting = allConditions + customConditions
        if let existing = allExisting.first(where: { $0.caseInsensitiveCompare(trimmed) == .orderedSame }) {
            selectedConditions.insert(existing)
        } else {
            customConditions.append(trimmed)
            selectedConditions.insert(trimmed)
        }
        conditionInput = ""
        isAddingCondition = false
    }

    private func removeCustomCondition(_ condition: String) {
        customConditions.removeAll { $0 == condition }
        selectedConditions.remove(condition)
    }

    // MARK: - Actions: Allergies
    private func submitAllergy() {
        let trimmed = allergyInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            isAddingAllergy = false
            return
        }
        let allExisting = allAllergies + customAllergies
        if let existing = allExisting.first(where: { $0.caseInsensitiveCompare(trimmed) == .orderedSame }) {
            selectedAllergies.insert(existing)
        } else {
            customAllergies.append(trimmed)
            selectedAllergies.insert(trimmed)
        }
        allergyInput = ""
        isAddingAllergy = false
    }

    private func removeCustomAllergy(_ allergy: String) {
        customAllergies.removeAll { $0 == allergy }
        selectedAllergies.remove(allergy)
    }
}

#Preview {
    HealthProfileSetupView()
}
