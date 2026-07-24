//
//  CaloriesViewModel.swift
//  NutriScan
//
//  Created by albaraa alsayed on 22/07/2026.
//

import Foundation

@Observable
@MainActor
final class CaloriesViewModel {
    // MARK: - Daily Products
    private(set) var dailyKcal: Int = 2100
    
    // MARK: - Calorie Goals
    private(set) var currentTdee: Float = 2000
    private(set) var maxTdee: Float = 2350
    
    // MARK: - Exercise
    private(set) var exerciseKcal: Int = 250
    private(set) var exerciseMinutes: Int = 45
    
    // MARK: - Water Tracking
    private(set) var waterCurrent: Int = 4
    private(set) var waterGoal: Int = 8
    
    // Future Use Cases for fetching calorie goals can be injected here
    
    init() {}
    
    func onAppear() {
        // In the future, this will fetch data from use cases.
        // For now, mock data is set in the property defaults above.
    }
    
    // MARK: - Actions
    
    func addWater() {
        guard waterCurrent < waterGoal else { return }
        waterCurrent += 1
    }
    
    func addFood() {
        // TODO: Navigate to food logging screen
    }
    
    func addExercise() {
        // TODO: Navigate to exercise logging screen
    }
}
