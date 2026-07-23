//
//  ChipSelectionManager.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 22/07/2026.
//
import SwiftUI
import Combine

@Observable
final class ChipSelectionManager {
    private(set) var allItems: [String] = []
    var chips: [ProfileChipItem] = []
    var searchQuery = ""
    var showSearchSheet = false

    /// Reference items (id + name) used to map selected chip names back to backend IDs.
    private var availableItems: [ReferenceItem] = []

    func configure(availableItems: [ReferenceItem], existingSelections: [ReferenceItem]) {
        self.availableItems = availableItems
        self.allItems = availableItems.map { $0.name }
        self.chips = existingSelections.map {
            ProfileChipItem(name: $0.name, isSelected: true, isNewlyAdded: false)
        }
    }

    var filteredItems: [String] {
        let activeNames = Set(chips.map { $0.name })
        let unselected = allItems.filter { !activeNames.contains($0) }
        guard !searchQuery.isEmpty else { return unselected }
        return unselected.filter { $0.localizedCaseInsensitiveContains(searchQuery) }
    }

    var selectedIds: [Int] {
        chips.filter { $0.isSelected }
            .compactMap { chip in availableItems.first(where: { $0.name == chip.name })?.id }
            .sorted()
    }

    var selectedNames: Set<String> {
        Set(chips.filter { $0.isSelected }.map { $0.name })
    }

    func select(_ item: String) {
        if !chips.contains(where: { $0.name == item }) {
            chips.append(ProfileChipItem(name: item, isSelected: true, isNewlyAdded: true))
        }
        searchQuery = ""
        showSearchSheet = false
    }

    func toggle(_ item: String) {
        guard let index = chips.firstIndex(where: { $0.name == item }) else { return }
        chips[index].isSelected.toggle()
    }

    func remove(_ item: String) {
        chips.removeAll { $0.name == item && $0.isNewlyAdded }
    }
}
