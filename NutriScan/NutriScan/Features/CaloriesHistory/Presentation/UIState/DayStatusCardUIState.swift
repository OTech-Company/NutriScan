//
//  DayStatusCardUIState.swift
//  NutriScan
//
//  Created by albaraa alsayed on 19/02/1448 AH.
//

import Foundation

struct DayStatusCardUIState: Identifiable {
    let id: UUID
    let type: DayStatusCard
    let primaryValue: String
    let secondaryValue: String?

    init(
        id: UUID = UUID(),
        type: DayStatusCard,
        primaryValue: String,
        secondaryValue: String? = nil
    ) {
        self.id = id
        self.type = type
        self.primaryValue = primaryValue
        self.secondaryValue = secondaryValue
    }
}
