import Combine
//
//  EditProfileViewModel.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 19/07/2026.
//
import SwiftUI

@Observable
final class EditProfileViewModel {
    var firstName: String = "Mina"
    var lastName: String = "Wagdy"
    var birthdate: Date = Calendar.current.date(byAdding: .year, value: -23, to: Date()) ?? Date()
    var height: String = "190"
    var weight: String = "105"
    var email: String = "minawagdy2228@gmail.com"

    // MARK: - Data Sources (Predefined lists)
    let allAllergies: [String]
    let allConditions: [String]

    // MARK: - Selected States
    var selectedConditions: Set<String>
    var selectedAllergies: Set<String>

    // MARK: - Custom Items States
    var customConditions: [String] = []
    var customAllergies: [String] = []

    // MARK: - Bottom Sheet States
    var showConditionSearchSheet = false
    var showAllergySearchSheet = false

    var conditionSearchQuery = ""
    var allergySearchQuery = ""

    var isLoading = false
    
    // MARK: - Backend Mocks (To be replaced with real API calls)
    private let backendConditions = ["Asthma", "COPD", "Arthritis", "Thyroid Disorder", "Osteoporosis", "Kidney Disease"]
    private let backendAllergies = ["Shellfish", "Soy", "Eggs", "Tree Nuts", "Wheat", "Sesame"]

    init() {
        let fetchedAllergies = ["Peanuts", "Dairy", "Gluten"]
        let fetchedConditions = ["Diabetes", "Hypertension", "Celiac Disease"]

        self.allAllergies = fetchedAllergies
        self.allConditions = fetchedConditions

        self.selectedAllergies = Set(fetchedAllergies)
        self.selectedConditions = Set(fetchedConditions)
    }
    
    // MARK: - Computed Filtered Results
    var filteredConditions: [String] {
        if conditionSearchQuery.isEmpty { return backendConditions }
        return backendConditions.filter { $0.localizedCaseInsensitiveContains(conditionSearchQuery) }
    }
    
    var filteredAllergies: [String] {
        if allergySearchQuery.isEmpty { return backendAllergies }
        return backendAllergies.filter { $0.localizedCaseInsensitiveContains(allergySearchQuery) }
    }

    // MARK: - Actions: Conditions
    func selectCustomCondition(_ condition: String) {
        if !customConditions.contains(condition) && !allConditions.contains(condition) {
            customConditions.append(condition)
        }
        selectedConditions.insert(condition)
        
        // Reset and close sheet
        conditionSearchQuery = ""
        showConditionSearchSheet = false
    }

    func removeCustomCondition(_ condition: String) {
        customConditions.removeAll { $0 == condition }
        selectedConditions.remove(condition)
    }

    // MARK: - Actions: Allergies
    func selectCustomAllergy(_ allergy: String) {
        if !customAllergies.contains(allergy) && !allAllergies.contains(allergy) {
            customAllergies.append(allergy)
        }
        selectedAllergies.insert(allergy)
        
        // Reset and close sheet
        allergySearchQuery = ""
        showAllergySearchSheet = false
    }

    func removeCustomAllergy(_ allergy: String) {
        customAllergies.removeAll { $0 == allergy }
        selectedAllergies.remove(allergy)
    }
}
