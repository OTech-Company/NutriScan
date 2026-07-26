//
//  HomeRoute.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//
import SwiftUI

enum HomeRoute: Route {
    case mealDetail(id: String)
    case summary
    case news
    case scanDetail(scanId: String)

    @ViewBuilder
    var destination: some View {
        switch self {
        case .mealDetail(let id):
            MealDetailView(mealId: id)
        case .summary:
            HomeSummaryView()
        case .news:
            NewsView()
        case .scanDetail(let scanId):
            ProductDetailsScreen(scanId: scanId)
        }
    }
}

