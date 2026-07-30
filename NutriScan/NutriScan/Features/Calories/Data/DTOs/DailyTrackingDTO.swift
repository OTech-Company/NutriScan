//
//  DailyTrackingDTO.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

struct DailyTrackingDTO: Decodable {
    let id: Int
    let date: String
    let targetWaterCnt: Int
    let waterCnt: Int
    let stepsCnt: Int
    let stepsKcal: Int
    let exerciseKcal: Int
    let exerciseMin: Double
    let totalMealKcal: Int
    let meals: [MealDTO]

    private enum CodingKeys: String, CodingKey {
        case id, date, targetWaterCnt, waterCnt, stepsCnt
        case stepsKcal, exerciseKcal, exerciseMin, totalMealKcal, meals
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        date = try container.decode(String.self, forKey: .date)
        targetWaterCnt = try container.decode(Int.self, forKey: .targetWaterCnt)
        waterCnt = try container.decode(Int.self, forKey: .waterCnt)
        stepsCnt = try container.decode(Int.self, forKey: .stepsCnt)
        stepsKcal = try container.decodeIfPresent(Int.self, forKey: .stepsKcal) ?? 0
        exerciseKcal = try container.decodeIfPresent(Int.self, forKey: .exerciseKcal) ?? 0
        exerciseMin = try container.decodeIfPresent(Double.self, forKey: .exerciseMin) ?? 0
        totalMealKcal = try container.decodeIfPresent(Int.self, forKey: .totalMealKcal) ?? 0
        meals = try container.decodeIfPresent([MealDTO].self, forKey: .meals) ?? []
    }
}
