//
//  GetNotificationPreferencesUseCase.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//

import Foundation

protocol GetNotificationPreferencesUseCaseProtocol {
    func execute() -> [NotificationCategory: Bool]
}

final class GetNotificationPreferencesUseCase: GetNotificationPreferencesUseCaseProtocol {
    private let repository: NotificationPreferencesRepositoryProtocol
    
    init(repository: NotificationPreferencesRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> [NotificationCategory: Bool] {
        var preferences: [NotificationCategory: Bool] = [:]
        for category in NotificationCategory.allCases {
            preferences[category] = repository.isEnabled(for: category)
        }
        return preferences
    }
}
