//
//  DailyTrackingRepo.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

protocol DailyTrackingRepo {

    func getTodayTracking() async throws -> DailyTracking
    func getTrackingByDate(date: String) async throws -> DailyTracking
    func getAllTracking(page: Int, size: Int) async throws -> (items: [DailyTrackingSummary], totalPages: Int)

    func addMeal(date: String, scanId: String, mealCnt: Int) async throws -> Meal
    func updateMealCount(date: String, scanId: String, mealCnt: Int) async throws -> Meal
    func deleteMeal(date: String, scanId: String) async throws

    func updateTracking(
        date: String,
        targetWaterCnt: Int?,
        waterCnt: Int?,
        stepsCnt: Int?,
        stepsKcal: Int?,
        exerciseKcal: Int?,
        exerciseMin: Double?,
        totalMealKcal: Int?
    ) async throws -> DailyTracking
    func deleteTracking(date: String) async throws
}
