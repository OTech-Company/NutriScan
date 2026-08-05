//
//  CaloriesTrackingRepo.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

protocol CaloriesTrackingRepo {

    func getTodayCaloriesTracking() async throws -> CaloriesTracking
    func getCaloriesTrackingByDate(date: String) async throws -> CaloriesTracking

    func addMeal(date: String, scanId: String, mealCnt: Int) async throws -> CalorieMeal
    func updateMealCount(date: String, scanId: String, mealCnt: Int) async throws -> CalorieMeal
    func deleteMeal(date: String, scanId: String) async throws

    func updateCaloriesTracking(
        date: String,
        targetWaterCnt: Int?,
        waterCnt: Int?,
        stepsCnt: Int?,
        stepsKcal: Double?,
        exerciseKcal: Double?,
        exerciseMin: Double?
    ) async throws -> CaloriesTracking
}
