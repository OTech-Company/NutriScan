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
    var name: String = ""
    var username: String = ""
    var email: String = ""
    var password: String = ""
    // MARK: - Data Sources (The "All" lists)
    // These can be statically initialized, or fetched from a local database/repository.
    let allAllergies: [String]
    let allConditions: [String]
    var availableConditions = ["Diabetes", "Hypertension", "Celiac Disease"]
    var availableAllergies = ["Peanuts", "Gluten", "Dairy"]

    var selectedConditions: Set<String>
    var selectedAllergies: Set<String>

    var showAddConditionSheet = false
    var showAddAllergySheet = false
    var isLoading = false
    init() {
        // Define the available options
        let fetchedAllergies = [
            "Peanuts", "Dairy", "Gluten",
        ]
        let fetchedConditions = [
            "Diabetes", "Hypertension", "Celiac Disease",
        ]

        self.allAllergies = fetchedAllergies
        self.allConditions = fetchedConditions

        // Initialize the selected sets with all available options by default
        self.selectedAllergies = Set(fetchedAllergies)
        self.selectedConditions = Set(fetchedConditions)
    }
    // TODO: wire to ProfileUseCase for fetch/save once backend integration lands
    // MARK: - Actions
    func handleAddOtherAllergy() {
        // Logic to present a text field alert or bottom sheet
        print("Add other allergy tapped")
    }

    func handleAddOtherCondition() {
        // Logic to present a text field alert or bottom sheet
        print("Add other condition tapped")
    }
}
