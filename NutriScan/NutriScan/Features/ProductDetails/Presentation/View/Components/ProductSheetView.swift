//
//  ProductSheetView.swift
//  NutriScan
//
//  Created by albaraa alsayed on 10/02/1448 AH.
//

import Shimmer
import SwiftUI

struct ProductSheetView: View {
    let state: ProductDetailsUIState
    
    init(state: ProductDetailsUIState = .mock) {
        self.state = state
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ProductHeaderSection(state: state.headerState)
                ProductSafetySection(state: state.safetyState)
                if !state.familyAlertsState.alerts.isEmpty {
                    ProductFamilyAlertsSection(state: state.familyAlertsState)
                }
                ProductIngredientsSection(state: state.ingredientsState)
                ProductNutritionSection(state: state.nutritionState)
                Spacer(minLength: 24)
            }
            .padding(.horizontal, 22)
            .padding(.top, 24)
            .padding(.bottom, 48) // Safe area compensation
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Rectangle()
                .fill(Color(light: .white, dark: Color.Teal.teal1600))
                .clipShape(
                    .rect(
                        topLeadingRadius: 24,
                        topTrailingRadius: 24
                    )
                )
                .ignoresSafeArea(edges: .bottom)
        }
    }
}

struct ProductDetailsShimmerView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorScheme) private var colorScheme

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                imageAndTitlePlaceholder
                safetyPlaceholder
                familyAlertsPlaceholder
                ingredientsPlaceholder
                nutritionPlaceholder
                Spacer(minLength: 24)
            }
            .padding(.horizontal, 22)
            .padding(.top, 24)
            .padding(.bottom, 48)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Rectangle()
                .fill(sheetBackground)
                .clipShape(
                    .rect(
                        topLeadingRadius: 24,
                        topTrailingRadius: 24
                    )
                )
                .ignoresSafeArea(edges: .bottom)
        }
        .redacted(reason: .placeholder)
        .shimmering(
            active: !reduceMotion,
            animation: .linear(duration: 1).repeatForever(autoreverses: false),
            gradient: shimmerGradient,
            bandSize: 0.24,
            mode: .overlay(blendMode: .sourceAtop)
        )
        .accessibilityHidden(true)
    }

    private var imageAndTitlePlaceholder: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 24)
                .fill(placeholderColor)
                .frame(maxWidth: .infinity, minHeight: 192, maxHeight: 192)

            HStack(alignment: .bottom, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    placeholder(width: 168, height: 22, radius: 6)
                    placeholder(width: 118, height: 22, radius: 6)
                }

                Spacer(minLength: 8)

                VStack(alignment: .trailing, spacing: 6) {
                    placeholder(width: 70, height: 10, radius: 4)
                    placeholder(width: 104, height: 20, radius: 6)
                }
            }
        }
    }

    private var safetyPlaceholder: some View {
        VStack(alignment: .leading, spacing: 12) {
            placeholder(width: 132, height: 18, radius: 5)
            placeholder(height: 14, radius: 5)
            placeholder(width: 220, height: 14, radius: 5)
            Capsule()
                .fill(placeholderColor)
                .frame(width: 92, height: 28)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(sectionBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var ingredientsPlaceholder: some View {
        VStack(alignment: .leading, spacing: 12) {
            placeholder(width: 116, height: 18, radius: 5)

            ForEach(0..<3, id: \.self) { index in
                HStack(spacing: 10) {
                    Circle()
                        .fill(placeholderColor)
                        .frame(width: 28, height: 28)

                    VStack(alignment: .leading, spacing: 6) {
                        placeholder(width: index == 1 ? 150 : 112, height: 12, radius: 4)
                        placeholder(width: index == 2 ? 180 : 210, height: 9, radius: 4)
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(sectionBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var familyAlertsPlaceholder: some View {
        VStack(alignment: .leading, spacing: 12) {
            placeholder(width: 148, height: 18, radius: 5)

            ForEach(0..<2, id: \.self) { index in
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        placeholder(width: 96, height: 14, radius: 5)
                        placeholder(width: index == 0 ? 74 : 64, height: 20, radius: 10)
                    }

                    placeholder(height: 13, radius: 5)
                    placeholder(width: index == 0 ? 188 : 160, height: 13, radius: 5)
                    placeholder(width: index == 0 ? 142 : 126, height: 13, radius: 5)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(placeholderColor.opacity(0.55))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(sectionBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var nutritionPlaceholder: some View {
        VStack(alignment: .leading, spacing: 12) {
            placeholder(width: 138, height: 18, radius: 5)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(0..<4, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 8) {
                        placeholder(width: index.isMultiple(of: 2) ? 72 : 94, height: 10, radius: 4)
                        placeholder(width: 54, height: 18, radius: 5)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(placeholderColor.opacity(0.55))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(sectionBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private func placeholder(
        width: CGFloat? = nil,
        height: CGFloat,
        radius: CGFloat
    ) -> some View {
        RoundedRectangle(cornerRadius: radius)
            .fill(placeholderColor)
            .frame(width: width, height: height)
            .frame(maxWidth: width == nil ? .infinity : nil, alignment: .leading)
    }

    private var placeholderColor: Color {
        Color(light: Color.Gray.gray200, dark: Color.Teal.teal1400)
    }

    private var sectionBackground: Color {
        Color(light: Color.Gray.gray100, dark: Color.Teal.teal1500)
    }

    private var sheetBackground: Color {
        Color(light: .white, dark: Color.Teal.teal1600)
    }

    private var shimmerGradient: Gradient {
        let highlight = colorScheme == .dark
            ? Color.white.opacity(0.28)
            : Color.white.opacity(0.72)
        return Gradient(colors: [.clear, highlight, .clear])
    }
}

struct ProductFamilyAlertsSection: View {
    let state: ProductFamilyAlertsUIState

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "person.2.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.Red.red500)
                Text("Family alerts")
                    .font(Font.AppFont.subtitle2)
                    .foregroundStyle(Color(light: Color.Gray.gray1000, dark: Color.Teal.teal500))
            }

            Text("Based on this scan, these profiles may need extra caution:")
                .font(Font.AppFont.textCaption)
                .foregroundStyle(Color(light: Color.Gray.gray800, dark: Color.Teal.teal500))

            VStack(spacing: 10) {
                ForEach(state.alerts) { alert in
                    ProductFamilyAlertCard(state: alert)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.Red.red100.opacity(0.8),
                            Color(light: Color.Gray.gray100, dark: Color.Teal.teal1500)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .strokeBorder(Color.Red.red500.opacity(0.18), lineWidth: 1)
        }
    }
}

struct ProductFamilyAlertCard: View {
    let state: ProductFamilyAlertUIState

    private var severityColor: Color {
        switch state.severity.uppercased() {
        case "UNSAFE":
            return Color.Red.red500
        case "CAUTION":
            return Color.Yellow.yellow500
        case "SAFE":
            return Color.Teal.teal700
        default:
            return Color.Teal.teal1000
        }
    }

    private var severityBackground: Color {
        switch state.severity.uppercased() {
        case "UNSAFE":
            return Color.Red.red100
        case "CAUTION":
            return Color.Yellow.yellow500.opacity(0.18)
        case "SAFE":
            return Color.Teal.teal100
        default:
            return Color.Teal.teal200
        }
    }

    private var iconName: String {
        switch state.severity.uppercased() {
        case "UNSAFE":
            return "exclamationmark.triangle.fill"
        case "CAUTION":
            return "exclamationmark.circle.fill"
        case "SAFE":
            return "checkmark.seal.fill"
        default:
            return "person.crop.circle.badge.questionmark"
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center, spacing: 8) {
                    Text(state.targetProfile)
                        .font(Font.AppFont.subtitle2)
                        .foregroundStyle(Color(light: Color.Teal.teal1000, dark: Color.Teal.teal400))
                        .lineLimit(1)

                    Text(state.severity.uppercased())
                        .font(Font.AppFont.textSecondary.weight(.bold))
                        .foregroundStyle(severityColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background {
                            Capsule()
                                .fill(severityBackground)
                        }
                }

                Text(state.reason)
                    .font(Font.AppFont.textCaption)
                    .foregroundStyle(Color(light: Color.Gray.gray800, dark: Color.Teal.teal500))
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 8)

            Image(systemName: iconName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(severityColor)
                .padding(10)
                .background {
                    Circle()
                        .fill(severityBackground)
                }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(light: .white, dark: Color.Teal.teal1600).opacity(0.88))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(severityColor.opacity(0.15), lineWidth: 1)
        }
    }
}

#Preview {
    VStack(alignment: .center) {
        ProductSheetView()
    }
    .background(Color.black)
}
