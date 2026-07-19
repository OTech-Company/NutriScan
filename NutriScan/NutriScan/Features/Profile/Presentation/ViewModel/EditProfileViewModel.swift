//
//  EditProfileViewModel.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 19/07/2026.
//
import SwiftUI
import Combine

@Observable
final class EditProfileViewModel {
    var name: String = ""
    var username: String = ""
    var email: String = ""
    var password: String = ""

    var availableConditions = ["Diabetes", "Hypertension", "Celiac Disease"]
    var availableAllergies = ["Peanuts", "Gluten", "Dairy"]

    var selectedConditions: Set<String> = ["Celiac Disease"]
    var selectedAllergies: Set<String> = []

    var showAddConditionSheet = false
    var showAddAllergySheet = false
    var isLoading = false

    // TODO: wire to ProfileUseCase for fetch/save once backend integration lands
}
