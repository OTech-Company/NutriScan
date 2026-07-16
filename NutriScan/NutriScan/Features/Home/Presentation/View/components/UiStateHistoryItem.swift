//
//  UiStateHistoryItem.swift
//  NutriScan
//
//  Created by Youssef Abd El-Fatah on 15/07/2026.
//


struct UiStateHistoryItem: Identifiable, Equatable {
    let id: String
    let title: String
    let scannedAt: String
    let imageName: String?
    let status: StatusType
    
    // Custom initializer to easily generate items
    init(id: String, title: String, scannedAt: String, imageName: String?, status: StatusType) {
        self.id = id
        self.title = title
        self.scannedAt = scannedAt
        self.imageName = imageName
        self.status = status
    }
}
