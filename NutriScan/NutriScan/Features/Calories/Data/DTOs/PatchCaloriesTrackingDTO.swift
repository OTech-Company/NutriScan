//
//  PatchCaloriesTrackingDTO.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

struct PatchCaloriesTrackingDTO: Encodable {
    let targetWaterCnt: Int?
    let waterCnt: Int?
    let stepsCnt: Int?
    let stepsKcal: Double?
    let exerciseKcal: Double?
    let exerciseMin: Double?
}
