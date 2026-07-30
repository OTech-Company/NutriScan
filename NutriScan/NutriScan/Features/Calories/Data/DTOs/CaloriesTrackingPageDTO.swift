//
//  CaloriesTrackingPageDTO.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

struct CaloriesTrackingPageDTO: Decodable {
    let content: [CaloriesTrackingSummaryDTO]?
    let totalElements: Int?
    let totalPages: Int?
    let first: Bool?
    let last: Bool?
    let number: Int?
    let size: Int?
    let numberOfElements: Int?

    private enum CodingKeys: String, CodingKey {
        case content, totalElements, totalPages, first, last, number, size, numberOfElements
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        content = try container.decodeIfPresent([CaloriesTrackingSummaryDTO].self, forKey: .content)
        totalElements = try container.decodeIfPresent(Int.self, forKey: .totalElements)
        totalPages = try container.decodeIfPresent(Int.self, forKey: .totalPages)
        first = try container.decodeIfPresent(Bool.self, forKey: .first)
        last = try container.decodeIfPresent(Bool.self, forKey: .last)
        number = try container.decodeIfPresent(Int.self, forKey: .number)
        size = try container.decodeIfPresent(Int.self, forKey: .size)
        numberOfElements = try container.decodeIfPresent(Int.self, forKey: .numberOfElements)
    }
}
