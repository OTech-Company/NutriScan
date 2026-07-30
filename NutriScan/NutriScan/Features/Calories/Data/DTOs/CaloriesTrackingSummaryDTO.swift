//
//  CaloriesTrackingSummaryDTO.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

struct CaloriesTrackingSummaryDTO: Decodable {
    let id: Int?
    let date: String?
    let targetWaterCnt: Int?
    let waterCnt: Int?
    let stepsCnt: Int?
    let mealCount: Int?

    private enum CodingKeys: String, CodingKey {
        case id, date, targetWaterCnt, waterCnt, stepsCnt, mealCount
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        date = try container.decodeIfPresent(String.self, forKey: .date)
        targetWaterCnt = try container.decodeIfPresent(Int.self, forKey: .targetWaterCnt)
        waterCnt = try container.decodeIfPresent(Int.self, forKey: .waterCnt)
        stepsCnt = try container.decodeIfPresent(Int.self, forKey: .stepsCnt)
        mealCount = try container.decodeIfPresent(Int.self, forKey: .mealCount)
    }
}
