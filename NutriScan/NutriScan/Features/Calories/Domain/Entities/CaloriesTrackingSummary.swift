//
//  CaloriesTrackingSummary.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

struct CaloriesTrackingSummary {
    let id: Int
    let date: String
    let targetWaterCnt: Int
    let waterCnt: Int
    let stepsCnt: Int
    let mealCount: Int
}

extension CaloriesTrackingSummary {
    init(from dto: CaloriesTrackingSummaryDTO) {
        self.id = dto.id ?? 0
        self.date = dto.date ?? ""
        self.targetWaterCnt = dto.targetWaterCnt ?? 0
        self.waterCnt = dto.waterCnt ?? 0
        self.stepsCnt = dto.stepsCnt ?? 0
        self.mealCount = dto.mealCount ?? 0
    }
}
