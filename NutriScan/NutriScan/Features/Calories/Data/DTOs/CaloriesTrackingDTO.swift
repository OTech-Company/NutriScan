//
//  CaloriesTrackingDTO.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

struct CaloriesTrackingDTO: Decodable {
    let id: Int?
    let date: String?
    let targetWaterCnt: Int?
    let waterCnt: Int?
    let stepsCnt: Int?
    let stepsKcal: Double?
    let exerciseKcal: Double?
    let exerciseMin: Double?
    let totalMealKcal: Int?
    let meals: [CalorieMealsDTO]?

    private enum CodingKeys: String, CodingKey {
        case id, date, targetWaterCnt, waterCnt, stepsCnt
        case stepsKcal, exerciseKcal, exerciseMin, totalMealKcal, meals
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        date = try container.decodeIfPresent(String.self, forKey: .date)
        targetWaterCnt = try container.decodeIfPresent(Int.self, forKey: .targetWaterCnt)
        waterCnt = try container.decodeIfPresent(Int.self, forKey: .waterCnt)
        stepsCnt = try container.decodeIfPresent(Int.self, forKey: .stepsCnt)
        stepsKcal = try container.decodeIfPresent(Double.self, forKey: .stepsKcal)
        exerciseKcal = try container.decodeIfPresent(Double.self, forKey: .exerciseKcal)
        exerciseMin = try container.decodeIfPresent(Double.self, forKey: .exerciseMin)
        totalMealKcal = try container.decodeIfPresent(Int.self, forKey: .totalMealKcal)
        meals = try container.decodeIfPresent([CalorieMealsDTO].self, forKey: .meals)
    }
}
