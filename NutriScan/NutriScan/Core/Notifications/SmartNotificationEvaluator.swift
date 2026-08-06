//
//  SmartNotificationEvaluator.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 06/08/2026.
//


import Foundation

protocol SmartNotificationEvaluatorProtocol {
    func shouldDeliverNotification(with identifier: String) async -> Bool
}

final class SmartNotificationEvaluator: SmartNotificationEvaluatorProtocol {

    private let getTodayCaloriesTrackingUseCase: GetTodayCaloriesTrackingUseCaseProtocol

    init(getTodayCaloriesTrackingUseCase: GetTodayCaloriesTrackingUseCaseProtocol) {
        self.getTodayCaloriesTrackingUseCase = getTodayCaloriesTrackingUseCase
    }

    func shouldDeliverNotification(with identifier: String) async -> Bool {
        // Resolve enum type from string identifier
        guard let smartType = SmartNotificationIdentifier(rawValue: identifier) else {
            return true
        }

        // Fetch current today's calories tracking if available
        let tracking = try? await getTodayCaloriesTrackingUseCase.execute()

        switch smartType {
        case .breakfastNudge:
            // 09:00 FOOD - Only if no breakfast (no meals) logged yet today
            guard let tracking = tracking else { return true }
            return tracking.meals.isEmpty

        case .morningWaterPace:
            // 11:00 WATER - Only if behind pace (water < 2 glasses)
            guard let tracking = tracking else { return true }
            return tracking.waterCnt < 2

        case .lunchNudge:
            // 13:30 FOOD - Only if no lunch logged yet (< 2 meals logged today)
            guard let tracking = tracking else { return true }
            return tracking.meals.count < 2

        case .middayWaterPace:
            // 14:00 WATER - Only if behind pace (water < 4 glasses)
            guard let tracking = tracking else { return true }
            return tracking.waterCnt < 4

        case .afternoonStepsMove:
            // 16:00 STEPS - Only if steps well below goal at 16:00 (steps < 4000)
            guard let tracking = tracking else { return true }
            return tracking.stepsCnt < 4000

        case .eveningWaterPace:
            // 17:00 WATER - Only if behind pace (water < 6 glasses)
            guard let tracking = tracking else { return true }
            return tracking.waterCnt < 6

        case .dinnerNudge:
            // 19:30 FOOD - Dinner nudge, only if under-logged (< 3 meals or < 1200 kcal)
            guard let tracking = tracking else { return true }
            return tracking.meals.count < 3 || tracking.calculatedMealCalories < 1200

        case .workoutNudge:
            // 20:30 WORKOUT - Only if no exercise logged today (0 minutes & 0 kcal)
            guard let tracking = tracking else { return true }
            return tracking.exerciseMin == 0 && tracking.exerciseKcal == 0

        case .streakProtection:
            // 21:30 STREAK - Only if today isn't yet safe (no meals logged or calories == 0)
            guard let tracking = tracking else { return true }
            return tracking.meals.isEmpty || tracking.calculatedMealCalories == 0

        case .dailyQuoteSummary, .healthNewsNudge, .scanReengagement:
            // Guaranteed daily touch / News / Weekly scan re-engagement
            return true
        }
    }
}