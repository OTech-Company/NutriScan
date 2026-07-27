//
//  DailyTrackingSummaryDTO.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

struct DailyTrackingSummaryDTO: Decodable {
    let id: Int
    let date: String
    let targetWaterCnt: Int
    let waterCnt: Int
    let stepsCnt: Int
    let mealCount: Int
}
