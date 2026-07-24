import SwiftUI

struct NutritionCard: View {
    let nutrition: NutritionFacts

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(Color.ScanSemantic.nutritionLabel)
                    .font(.system(size: 16))

                Text("Nutrition Facts")
                    .font(Font.AppFont.plusJakartaSansSemiBold16)
                    .foregroundColor(Color.ScanSemantic.ingredientTitle)
            }

            VStack(spacing: 0) {
                nutritionRow(label: "Calories", value: "\(nutrition.calories)", unit: "kcal")
                Divider().background(Color.ScanSemantic.nutritionDivider)
                nutritionRow(label: "Protein", value: formatValue(nutrition.proteinGrams), unit: "g")
                Divider().background(Color.ScanSemantic.nutritionDivider)
                nutritionRow(label: "Carbs", value: formatValue(nutrition.carbsGrams), unit: "g")
                Divider().background(Color.ScanSemantic.nutritionDivider)
                nutritionRow(label: "Fat", value: formatValue(nutrition.fatGrams), unit: "g")
                Divider().background(Color.ScanSemantic.nutritionDivider)
                nutritionRow(label: "Fiber", value: formatValue(nutrition.fiberGrams), unit: "g")
                Divider().background(Color.ScanSemantic.nutritionDivider)
                nutritionRow(label: "Sugar", value: formatValue(nutrition.sugarGrams), unit: "g")
                Divider().background(Color.ScanSemantic.nutritionDivider)
                nutritionRow(label: "Sodium", value: formatValue(nutrition.sodiumMg), unit: "mg")
            }
        }
    }

    private func nutritionRow(label: String, value: String, unit: String) -> some View {
        HStack {
            Text(label)
                .font(Font.AppFont.textDefault)
                .foregroundColor(Color.ScanSemantic.nutritionLabel)

            Spacer()

            HStack(spacing: 4) {
                Text(value)
                    .font(Font.AppFont.textPrimary)
                    .foregroundColor(Color.ScanSemantic.nutritionValue)
                Text(unit)
                    .font(Font.AppFont.textCaption)
                    .foregroundColor(Color.ScanSemantic.nutritionLabel)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 4)
    }

    private func formatValue(_ value: Double) -> String {
        value.truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", value)
            : String(format: "%.1f", value)
    }
}
