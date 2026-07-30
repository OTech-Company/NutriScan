//
//  DailyTrackingTodayDTO.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 30/07/2026.
//

import Foundation

struct DailyTrackingTodayDTO: Decodable {
    let id: Int?
    let date: String?
    let meals: [DailyTrackingTodayMealDTO]?
}

struct DailyTrackingTodayMealDTO: Decodable {
    let scanId: String
    let mealCnt: Int
    let productName: String?
}
