//
//  DailyTrackingPageDTO.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

struct DailyTrackingPageDTO: Decodable {
    let content: [DailyTrackingSummaryDTO]
    let totalElements: Int
    let totalPages: Int
    let first: Bool
    let last: Bool
    let number: Int
    let size: Int
    let numberOfElements: Int
}
