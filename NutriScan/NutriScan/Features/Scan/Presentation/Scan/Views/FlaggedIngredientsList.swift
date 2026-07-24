import SwiftUI

struct FlaggedIngredientsList: View {
    let ingredients: [FlaggedIngredient]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(Color.ScanSemantic.ingredientTitle)
                    .font(.system(size: 16))

                Text("Flagged Ingredients")
                    .font(Font.AppFont.plusJakartaSansSemiBold16)
                    .foregroundColor(Color.ScanSemantic.ingredientTitle)
            }

            VStack(spacing: 0) {
                ForEach(Array(ingredients.enumerated()), id: \.element.id) { index, ingredient in
                    ingredientRow(ingredient)

                    if index < ingredients.count - 1 {
                        Divider()
                            .background(Color.ScanSemantic.nutritionDivider)
                            .padding(.leading, 36)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func ingredientRow(_ ingredient: FlaggedIngredient) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: ingredient.type.icon)
                .font(.system(size: 14))
                .foregroundColor(Color.ScanSemantic.ingredientTypeBadge)
                .frame(width: 24, height: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(ingredient.ingredient)
                    .font(Font.AppFont.textPrimary)
                    .foregroundColor(Color.ScanSemantic.ingredientName)

                Text(ingredient.reason)
                    .font(Font.AppFont.textSecondary)
                    .foregroundColor(Color.ScanSemantic.ingredientReason)
            }

            Spacer()

            Text(ingredient.type.displayName)
                .font(Font.AppFont.lexendDecaMedium11)
                .foregroundColor(Color.ScanSemantic.ingredientTypeBadge)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.ScanSemantic.verdictUnsafeBackground)
                .clipShape(Capsule())
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 4)
    }
}
