//
//  EditProfileViewModel.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 19/07/2026.
//
import Combine
import SwiftUI

@Observable
final class EditProfileViewModel {
    
    // MARK: - Validated Fields
    var firstName = ValidatedField(value: "Mina")
    var lastName = ValidatedField(value: "Wagdy")
    var height = ValidatedField(value: "190")
    var weight = ValidatedField(value: "105")
    
    // MARK: - Display Only
    var email: String = "minawagdy2228@gmail.com"
    var birthdate: Date = Calendar.current.date(byAdding: .year, value: -23, to: Date()) ?? Date()

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
    
    // MARK: - Validation Methods
    private func validateName(_ value: String) -> String? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return "Name is required." }
        if trimmed.count < 2 { return "Must be at least 2 characters." }
        
        let nameRegex = "^[\\p{L} .'-]+$" // Only letters, spaces, and hyphens
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        if !nameTest.evaluate(with: trimmed) { return "Please use valid characters." }
        
        return nil
    }
    
    private func validateHeight(_ value: String) -> String? {
        if value.isEmpty { return "Required." }
        guard let h = Double(value), h >= 50, h <= 300 else { return "Invalid height." }
        return nil
    }
    
    private func validateWeight(_ value: String) -> String? {
        if value.isEmpty { return "Required." }
        guard let w = Double(value), w >= 20, w <= 500 else { return "Invalid weight." }
        return nil
    }

    func validateAndSave() {
        let isFirstNameValid = firstName.validate(using: validateName)
        let isLastNameValid = lastName.validate(using: validateName)
        let isHeightValid = height.validate(using: validateHeight)
        let isWeightValid = weight.validate(using: validateWeight)
        
        guard isFirstNameValid, isLastNameValid, isHeightValid, isWeightValid else {
            return
        }
        
        // TODO: Proceed with backend save logic
        print("All fields are valid. Saving profile...")
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

    // MARK: - Actions: Conditions & Allergies
    func selectCustomCondition(_ condition: String) {
        if !customConditions.contains(condition) && !allConditions.contains(condition) {
            customConditions.append(condition)
        }
        selectedConditions.insert(condition)
        conditionSearchQuery = ""
        showConditionSearchSheet = false
    }

    func removeCustomCondition(_ condition: String) {
        customConditions.removeAll { $0 == condition }
        selectedConditions.remove(condition)
    }

    func selectCustomAllergy(_ allergy: String) {
        if !customAllergies.contains(allergy) && !allAllergies.contains(allergy) {
            customAllergies.append(allergy)
        }
        selectedAllergies.insert(allergy)
        allergySearchQuery = ""
        showAllergySearchSheet = false
    }

    func removeCustomAllergy(_ allergy: String) {
        customAllergies.removeAll { $0 == allergy }
        selectedAllergies.remove(allergy)
    }
}
