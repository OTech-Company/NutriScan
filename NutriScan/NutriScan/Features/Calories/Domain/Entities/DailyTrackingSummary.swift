//
//  DailyTrackingSummary.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

struct DailyTrackingSummary {
    let id: Int
    let date: String
    let targetWaterCnt: Int
    let waterCnt: Int
    let stepsCnt: Int
    let mealCount: Int
}

extension DailyTrackingSummary {
    init(from dto: DailyTrackingSummaryDTO) {
        self.id = dto.id
        self.date = dto.date
        self.targetWaterCnt = dto.targetWaterCnt
        self.waterCnt = dto.waterCnt
        self.stepsCnt = dto.stepsCnt
        self.mealCount = dto.mealCount
    }
}
