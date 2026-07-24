//
//  DailyProductsSection.swift
//  NutriScan
//
//  Created by albaraa alsayed on 22/07/2026.
//

import SwiftUI

struct DailyProductsSection: View {
    let dailyKcal: Int
    var onAddFoodTap: () -> Void = {}
    
    @State private var showCard = false
    @State private var isTapped = false
    
    var body: some View {
        VStack(spacing: 8) {
            // Header row
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
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.CaloriesSemantic.dailyProductsBadgeBackground)
                    )
                Text("Kcal")
                    .foregroundStyle(Color.CaloriesSemantic.dailyProductsKcalLabel)
                    .font(Font.AppFont.textCaption)
            }
            
            // Add Food card
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
                
                VStack(spacing: 8) {
                    AddCircleButton(size: 60, action: onAddFoodTap)
                    Text("Add Food")
                        .foregroundStyle(Color.CaloriesSemantic.dailyProductsAddFoodText)
                        .font(Font.AppFont.textSecondary)
                }
            }
            .frame(height: 140)
            .scaleEffect(showCard ? 1.0 : 0.85)
            .opacity(showCard ? 1 : 0)
            .scaleEffect(isTapped ? 0.97 : 1.0)
            .onTapGesture {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                    isTapped = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isTapped = false
                    }
                }
                onAddFoodTap()
            }
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.15)) {
                    showCard = true
                }
            }
        }
    }
}

#Preview("Light") {
    DailyProductsSection(dailyKcal: 2100)
        .padding()
        .background(Color.CaloriesSemantic.background)
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    DailyProductsSection(dailyKcal: 2100)
        .padding()
        .background(Color.Teal.teal1600)
        .preferredColorScheme(.dark)
}
