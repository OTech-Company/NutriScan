//
//  DailyProductsSection.swift
//  NutriScan
//
//  Created by albaraa alsayed on 22/07/2026.
//

import SwiftUI

struct DailyProductsSection: View {
    let dailyKcal: Int
    let meals: [Meal]
    var onAddFoodTap: () -> Void = {}
    var onDeleteMealRequest: ((_ scanId: String) -> Void)? = nil

    @State private var showCard = false
    @State private var isTapped = false

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                Text("Daily Products")
                    .font(Font.AppFont.title4)
                    .foregroundStyle(Color.CaloriesSemantic.dailyProductsTitle)
                Spacer()
                Text("\(dailyKcal)")
                    .foregroundStyle(Color.CaloriesSemantic.dailyProductsBadgeText)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .font(Font.AppFont.textCaption)
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: dailyKcal)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.CaloriesSemantic.dailyProductsBadgeBackground)
                    )
                Text("Kcal")
                    .foregroundStyle(Color.CaloriesSemantic.dailyProductsKcalLabel)
                    .font(Font.AppFont.textCaption)
            }

            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.CaloriesSemantic.cardBackground)
                    .overlay {
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(
                                Color.CaloriesSemantic.dailyProductsCardBorder,
                                style: StrokeStyle(lineWidth: 1, dash: [5])
                            )
                    }

                if meals.isEmpty {
                    VStack(spacing: 8) {
                        AddCircleButton(size: 60, action: onAddFoodTap)
                        Text("Add Food")
                            .foregroundStyle(Color.CaloriesSemantic.dailyProductsAddFoodText)
                            .font(Font.AppFont.textSecondary)
                    }
                } else {
                    VStack(spacing: 0) {
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                ForEach(meals, id: \.scanId) { meal in
                                    MealRowView(meal: meal)
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            Button(role: .destructive) {
                                                onDeleteMealRequest?(meal.scanId)
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                }
                            }
                        }
                        .scrollIndicators(.hidden)

                        Button(action: onAddFoodTap) {
                            HStack(spacing: 6) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundStyle(Color.CaloriesSemantic.dailyProductsBadgeBackground)
                                Text("Add Food")
                                    .font(Font.AppFont.textSecondary)
                                    .foregroundStyle(Color.CaloriesSemantic.dailyProductsAddFoodText)
                            }
                            .padding(.vertical, 10)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.top, 8)
                    .padding(.bottom, 4)
                }
            }
            .frame(minHeight: 140, maxHeight: meals.isEmpty ? 140 : 280)
            .scaleEffect(showCard ? 1.0 : 0.85)
            .opacity(showCard ? 1 : 0)
            .scaleEffect(isTapped ? 0.97 : 1.0)
            .onTapGesture {
                if meals.isEmpty {
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) { isTapped = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { isTapped = false }
                    }
                    onAddFoodTap()
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.15)) {
                    showCard = true
                }
            }
        }
    }
}

private struct MealRowView: View {
    let meal: Meal

    var body: some View {
        HStack(spacing: 10) {
            CachedImage(
                urlString: meal.imageUrl,
                failureImageName: "",
                contentMode: .fill
            )
            .frame(width: 44, height: 44)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(meal.productName)
                    .font(Font.AppFont.textDefault)
                    .foregroundStyle(Color.CaloriesSemantic.dailyProductsTitle)
                    .lineLimit(1)
                Text("×\(meal.mealCnt) serving")
                    .font(Font.AppFont.textCaption)
                    .foregroundStyle(Color.CaloriesSemantic.dailyProductsAddFoodText)
            }

            Spacer()

            Text("\(meal.nutritionFacts.calories * meal.mealCnt) Kcal")
                .font(Font.AppFont.textCaption)
                .foregroundStyle(Color.CaloriesSemantic.dailyProductsBadgeText)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.CaloriesSemantic.dailyProductsBadgeBackground)
                )
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
}

#Preview("Light — Empty") {
    DailyProductsSection(dailyKcal: 0, meals: [])
        .padding()
        .background(Color.CaloriesSemantic.background)
        .preferredColorScheme(.light)
}

#Preview("Light — With Meals") {
    let mockMeal = Meal(
        scanId: "abc-123",
        productName: "Greek Yogurt",
        imageUrl: "",
        mealCnt: 1,
        nutritionFacts: MealNutritionFacts(
            calories: 120, proteinGrams: 10,
            carbsGrams: 15, fatG: 2,
            fiberGrams: 0, sugarG: 8, sodiumMg: 50
        )
    )
    DailyProductsSection(dailyKcal: 120, meals: [mockMeal, mockMeal])
        .padding()
        .background(Color.CaloriesSemantic.background)
        .preferredColorScheme(.light)
}
