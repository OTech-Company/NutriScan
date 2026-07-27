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

    func addMeal(date: String, meal: Meal) async throws -> Meal
    func updateMeal(date: String, scanId: String, meal: Meal) async throws -> Meal
    func deleteMeal(date: String, scanId: String) async throws

    func updateWaterAndSteps(date: String, targetWaterCnt: Int?, waterCnt: Int?, stepsCnt: Int?) async throws
    func deleteTracking(date: String) async throws
}
