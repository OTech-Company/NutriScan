//
//  DayStatusCardUIState.swift
//  NutriScan
//
//  Created by albaraa alsayed on 19/02/1448 AH.
//

import Foundation

struct DayStatusCardUIState: Identifiable, Equatable {
    var id: DayStatusCard { type }

    let type: DayStatusCard
    let primaryValue: String
    let secondaryValue: String?

    init(
        type: DayStatusCard,
        primaryValue: String,
        secondaryValue: String? = nil
    ) {
        self.type = type
        self.primaryValue = primaryValue
        self.secondaryValue = secondaryValue
    }
}
