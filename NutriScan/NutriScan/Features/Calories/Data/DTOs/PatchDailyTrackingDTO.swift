//
//  PatchDailyTrackingDTO.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

struct PatchDailyTrackingDTO: Encodable {
    let date: String
    let targetWaterCnt: Int?
    let waterCnt: Int?
    let stepsCnt: Int?
    let stepsKcal: Int?
    let exerciseKcal: Int?
    let exerciseMin: Double?
    let totalMealKcal: Int?
}
