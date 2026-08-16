//
//  DailyProductsSection.swift
//  NutriScan
//
//  Created by albaraa alsayed on 22/07/2026.
//

import SwiftUI
import Shimmer

enum MealRemovalKind: Equatable {
    case one
    case all
}

struct MealRemovalRequest: Identifiable {
    let meal: CalorieMeal
    let kind: MealRemovalKind

    var id: String { "\(meal.scanId)-\(kind == .one ? "one" : "all")" }
}

struct DailyProductsSection: View {
    let dailyKcal: Int
    let meals: [CalorieMeal]
    var mutatingMealIDs: Set<String> = []
    var isLoading = false
    var showsHeader = true
    var onAddFoodTap: () -> Void = {}
    var onRemoveMealRequest: ((MealRemovalRequest) -> Void)? = nil

    @State private var showCard = false
    @State private var isTapped = false

    var body: some View {
        VStack(spacing: 8) {
            if showsHeader {
                DailyProductsHeader(dailyKcal: dailyKcal, isLoading: isLoading)
            }

            ZStack {
                if isLoading {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(0..<2, id: \.self) { _ in
                                CalorieMealLoadingCard()
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 12)
                    }
                    .accessibilityHidden(true)
                } else if meals.isEmpty {
                    VStack(spacing: 8) {
                        AddCircleButton(
                            accessibilityLabel: LocalizationKeys.Calories.addFood.localized,
                            accessibilityHint: LocalizationKeys.Accessibility.opensSavedFoods.localized,
                            size: 60,
                            action: onAddFoodTap
                        )
                        Text(LocalizationKeys.Calories.addFood.localized)
                            .foregroundStyle(Color.CaloriesSemantic.dailyProductsAddFoodText)
                            .font(Font.AppFont.textSecondary)
                    }
                } else {
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 10) {
                            ForEach(meals, id: \.scanId) { meal in
                                CalorieMealCard(
                                    meal: meal,
                                    isMutating: mutatingMealIDs.contains(meal.scanId),
                                    onRemoveOne: {
                                        onRemoveMealRequest?(
                                            MealRemovalRequest(meal: meal, kind: .one)
                                        )
                                    },
                                    onRemoveAll: {
                                        onRemoveMealRequest?(
                                            MealRemovalRequest(meal: meal, kind: .all)
                                        )
                                    }
                                )
                            }

                            AddFoodCarouselCard(action: onAddFoodTap)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 12)
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        isLoading || !meals.isEmpty
                            ? Color.CaloriesSemantic.dailyProductsCarouselBackground
                            : Color.CaloriesSemantic.dailyProductsEmptyCardBackground
                    )
            )
            .overlay {
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        Color.CaloriesSemantic.dailyProductsCardBorder,
                        style: StrokeStyle(lineWidth: 1, dash: [5])
                    )
            }
            .contentShape(RoundedRectangle(cornerRadius: 24))
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
            .allowsHitTesting(!isLoading)
        }
    }
}

struct DailyProductsHeader: View {
    let dailyKcal: Int
    var isLoading = false

    var body: some View {
        HStack(spacing: 4) {
            Text(LocalizationKeys.Calories.dailyProducts.localized)
                .font(Font.AppFont.title4)
                .foregroundStyle(Color.CaloriesSemantic.dailyProductsTitle)

            Spacer()

            Group {
                if isLoading {
                    CaloriesTextShimmer(
                        width: 42,
                        height: 18,
                        cornerRadius: 9,
                        color: Color.CaloriesSemantic.dailyProductsBadgeText.opacity(0.65)
                    )
                } else {
                    Text("\(dailyKcal)")
                        .foregroundStyle(Color.CaloriesSemantic.dailyProductsBadgeText)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .font(Font.AppFont.textCaption)
                        .contentTransition(.numericText())
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: dailyKcal)
                        .accessibilityIdentifier("calories.dailyKcal")
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.CaloriesSemantic.dailyProductsBadgeBackground)
            )

            Text("Kcal")
                .foregroundStyle(Color.CaloriesSemantic.dailyProductsKcalLabel)
                .font(Font.AppFont.textCaption)
        }
        .accessibilityElement(children: .contain)
    }
}

private struct CalorieMealLoadingCard: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 8) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.CaloriesSemantic.shimmerPlaceholder)
                    .frame(width: 44, height: 44)

                VStack(alignment: .leading, spacing: 6) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.CaloriesSemantic.shimmerPlaceholder)
                        .frame(width: 76, height: 10)
                    Capsule()
                        .fill(Color.CaloriesSemantic.shimmerPlaceholder)
                        .frame(width: 34, height: 16)
                }
            }

            Spacer(minLength: 0)

            RoundedRectangle(cornerRadius: 8)
                .fill(Color.CaloriesSemantic.shimmerPlaceholder)
                .frame(width: 70, height: 24)
        }
        .padding(10)
        .frame(width: 160, height: 116)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.CaloriesSemantic.dailyProductCardBackground)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.CaloriesSemantic.dailyProductCardBorder, lineWidth: 1)
        }
        .redacted(reason: .placeholder)
        .shimmering(active: !reduceMotion)
    }
}

private struct CalorieMealCard: View {
    let meal: CalorieMeal
    let isMutating: Bool
    let onRemoveOne: () -> Void
    let onRemoveAll: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 8) {
                productImage

                VStack(alignment: .leading, spacing: 4) {
                    Text(meal.productName.isEmpty ? LocalizationKeys.Calories.unknownProduct.localized : meal.productName)
                        .font(Font.AppFont.textCaption)
                        .foregroundStyle(Color.CaloriesSemantic.dailyProductTitleText)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("x\(meal.mealCnt)")
                        .font(Font.AppFont.textCaption)
                        .foregroundStyle(Color.CaloriesSemantic.dailyProductQuantityBadgeText)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(Color.CaloriesSemantic.dailyProductQuantityBadgeBackground)
                        )
                }
            }

            Spacer(minLength: 0)

            HStack(spacing: 6) {
                Text("\(meal.nutritionFacts.calories * meal.mealCnt) Kcal")
                    .font(Font.AppFont.textCaption)
                    .foregroundStyle(Color.CaloriesSemantic.dailyProductKcalBadgeText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.CaloriesSemantic.dailyProductKcalBadgeBackground)
                    )

                Spacer(minLength: 0)

                if meal.mealCnt > 1 {
                    actionButton(
                        icon: "minus",
                        color: Color.CaloriesSemantic.dailyProductRemoveOneBackground,
                        action: onRemoveOne
                    )
                }

                actionButton(
                    icon: "trash",
                    color: Color.CaloriesSemantic.dailyProductRemoveAllBackground,
                    action: onRemoveAll
                )
            }
        }
        .padding(10)
        .frame(width: 160, height: 116)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.CaloriesSemantic.dailyProductCardBackground)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.CaloriesSemantic.dailyProductCardBorder, lineWidth: 1)
        }
        .accessibilityAction(named: LocalizationKeys.Calories.removeOneServingTitle.localized) {
            if meal.mealCnt > 1 { onRemoveOne() }
        }
        .accessibilityAction(named: LocalizationKeys.Calories.removeMealTitle.localized) {
            onRemoveAll()
        }
    }

    private var productImage: some View {
        CachedImage(
            urlString: meal.imageUrl,
            failureImageName: "",
            contentMode: .fill
        )
        .frame(width: 44, height: 44)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func actionButton(icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(Color.CaloriesSemantic.dailyProductActionIcon)
                .frame(width: 26, height: 26)
                .background(
                    Circle()
                        .fill(color)
                )
        }
        .buttonStyle(.plain)
        .disabled(isMutating)
        .opacity(isMutating ? 0.45 : 1)
    }
}

private struct AddFoodCarouselCard: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(Color.CaloriesSemantic.dailyProductQuantityBadgeBackground)
                Text(LocalizationKeys.Calories.addFood.localized)
                    .font(Font.AppFont.textCaption)
                    .foregroundStyle(Color.CaloriesSemantic.dailyProductAddCardText)
            }
            .frame(width: 96, height: 116)
        }
        .buttonStyle(.plain)
    }
}
//
//#Preview("Light — Empty") {
//    DailyProductsSection(dailyKcal: 0, meals: [])
//        .padding()
//        .background(Color.CaloriesSemantic.background)
//        .preferredColorScheme(.light)
//}
//
//#Preview("Light — With Meals") {
//    let mockMeal = CalorieMeal(
//        scanId: "abc-123",
//        productName: "Greek Yogurt",
//        imageUrl: "",
//        mealCnt: 1,
//        nutritionFacts: MealNutritionFacts(
//            calories: 120, proteinGrams: 10,
//            carbsGrams: 15, fatG: 2,
//            fiberGrams: 0, sugarG: 8, sodiumMg: 50
//        )
//    )
//    DailyProductsSection(dailyKcal: 120, meals: [mockMeal, mockMeal])
//        .padding()
//        .background(Color.CaloriesSemantic.background)
//        .preferredColorScheme(.light)
//}
