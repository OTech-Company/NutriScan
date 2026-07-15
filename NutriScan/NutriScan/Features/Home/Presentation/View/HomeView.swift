//
//  empty.swift
//  NutriScan
//
//  Created by Osama Hosam on 13/07/2026.
//
import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var router: AppRouter
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 16) {
            Button("View Meal") {
                router.push(HomeRoute.mealDetail(id: "123"))
            }
            Button("See Summary") {
                router.presentSheet(HomeRoute.summary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(colorScheme == .light ? .white : Color.Teal.teal1600)
        .navigationTitle("Home")
    }
}
