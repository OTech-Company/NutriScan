//
//  CaloriesHistoryMapper.swift
//  NutriScan
//
//  Created by albaraa alsayed on 20/02/1448 AH.
//

import Foundation

enum CaloriesHistoryMapper {
    static func map(_ dto: CaloriesHistoryPageDTO) -> CaloriesHistoryPage {
        CaloriesHistoryPage(
            days: (dto.content ?? []).compactMap { try? map($0) },
            totalElements: dto.totalElements ?? 0,
            totalPages: dto.totalPages ?? 0,
            currentPage: dto.number ?? dto.pageable?.pageNumber ?? 0,
            pageSize: dto.size ?? dto.pageable?.pageSize ?? 0,
            numberOfElements: dto.numberOfElements ?? 0,
            isFirst: dto.first ?? true,
            isLast: dto.last ?? true
        )
    }

    static func map(_ dto: CaloriesHistorySummaryDTO) throws -> CaloriesHistoryDay {
        let identity = try identity(id: dto.id, date: dto.date)
        return CaloriesHistoryDay(
            id: identity.id,
            date: identity.date,
            targetWaterCount: dto.targetWaterCnt ?? 0,
            waterCount: dto.waterCnt ?? 0,
            stepCount: dto.stepsCnt ?? 0,
            stepCalories: dto.stepsKcal ?? 0,
            exerciseCalories: dto.exerciseKcal ?? 0,
            exerciseMinutes: dto.exerciseMin ?? 0,
            totalMealCalories: dto.totalMealKcal ?? 0,
            mealCount: dto.mealCount ?? 0,
            meals: []
        )
    }

    static func map(_ dto: CaloriesHistoryDetailDTO) throws -> CaloriesHistoryDay {
        let identity = try identity(id: dto.id, date: dto.date)
        let meals = (dto.meals ?? []).map(map)
        return CaloriesHistoryDay(
            id: identity.id,
            date: identity.date,
            targetWaterCount: dto.targetWaterCnt ?? 0,
            waterCount: dto.waterCnt ?? 0,
            stepCount: dto.stepsCnt ?? 0,
            stepCalories: dto.stepsKcal ?? 0,
            exerciseCalories: dto.exerciseKcal ?? 0,
            exerciseMinutes: dto.exerciseMin ?? 0,
            totalMealCalories: dto.totalMealKcal ?? 0,
            mealCount: meals.reduce(0) { $0 + $1.count },
            meals: meals
        )
    }

    private static func identity(id: Int?, date: String?) throws -> (id: Int, date: Date) {
        guard let id else { throw CaloriesHistoryError.invalidIdentity }
        guard let date, let parsedDate = CaloriesHistoryDateCodec.date(from: date) else {
            throw CaloriesHistoryError.invalidDate
        }
        return (id, parsedDate)
    }

    private static func map(_ dto: CaloriesHistoryMealDTO) -> CaloriesHistoryMeal {
        CaloriesHistoryMeal(
            scanID: dto.scanId ?? "",
            productName: dto.productName ?? "",
            imageURL: dto.imageUrl ?? "",
            count: dto.mealCnt ?? 0,
            nutritionFacts: map(dto.nutritionFacts)
        )
    }

    private static func map(_ dto: CaloriesHistoryNutritionFactsDTO?) -> CaloriesHistoryNutritionFacts {
        CaloriesHistoryNutritionFacts(
            calories: dto?.calories ?? 0,
            proteinGrams: dto?.proteinGrams ?? 0,
            carbsGrams: dto?.carbsGrams ?? 0,
            fatGrams: dto?.fatG ?? 0,
            fiberGrams: dto?.fiberGrams ?? 0,
            sugarGrams: dto?.sugarG ?? 0,
            sodiumMilligrams: dto?.sodiumMg ?? 0
        )
    }
}
