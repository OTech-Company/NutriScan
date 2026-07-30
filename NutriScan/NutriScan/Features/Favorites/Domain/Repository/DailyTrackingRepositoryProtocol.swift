//
//  DailyTrackingRepositoryProtocol.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 30/07/2026.
//

import Foundation

protocol DailyTrackingRepositoryProtocol {
    /// Adds the product to daily meals (POST). If the product already exists on the server,
    /// it automatically falls back to a PUT to increment the count.
    func addOrIncrementMeal(scanId: String) async throws
}
