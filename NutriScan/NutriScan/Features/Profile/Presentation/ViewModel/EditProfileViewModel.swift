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
    var name: String = "Mina Wagdy"
    var username: String = ""
    var email: String = "minawagdy2228@gmail.com"
    var password: String = ""
    
    // MARK: - Data Sources (Predefined lists)
    let allAllergies: [String]
    let allConditions: [String]
    
    // MARK: - Selected States
    var selectedConditions: Set<String>
    var selectedAllergies: Set<String>

    // MARK: - Custom Items States
    var customConditions: [String] = []
    var customAllergies: [String] = []

    // MARK: - Input States
    var isAddingCondition = false
    var isAddingAllergy = false

    var conditionInput = ""
    var allergyInput = ""

    var isLoading = false
    
    init() {
        let fetchedAllergies = ["Peanuts", "Dairy", "Gluten"]
        let fetchedConditions = ["Diabetes", "Hypertension", "Celiac Disease"]

        self.allAllergies = fetchedAllergies
        self.allConditions = fetchedConditions

        self.selectedAllergies = Set(fetchedAllergies)
        self.selectedConditions = Set(fetchedConditions)
    }

    // MARK: - Actions: Conditions
    func submitCondition() {
        let trimmed = conditionInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            isAddingCondition = false
            return
        }

        let allExisting = allConditions + customConditions
        
        // Prevent duplicates (case-insensitive)
        if let existing = allExisting.first(where: { $0.caseInsensitiveCompare(trimmed) == .orderedSame }) {
            selectedConditions.insert(existing)
        } else {
            customConditions.append(trimmed)
            selectedConditions.insert(trimmed)
        }

        conditionInput = ""
        isAddingCondition = false
    }

    func removeCustomCondition(_ condition: String) {
        customConditions.removeAll { $0 == condition }
        selectedConditions.remove(condition)
    }

    // MARK: - Actions: Allergies
    func submitAllergy() {
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

    func removeCustomAllergy(_ allergy: String) {
        customAllergies.removeAll { $0 == allergy }
        selectedAllergies.remove(allergy)
    }
}
