import SwiftUI

struct ScanResultCard: View {
    let result: ScanResult
    let onRetake: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            headerSection

            if let summary = result.summary, !summary.isEmpty {
                summarySection(summary)
            }

            if !result.flaggedIngredients.isEmpty {
                FlaggedIngredientsList(ingredients: result.flaggedIngredients)
            }

            if let nutrition = result.nutritionFacts {
                NutritionCard(nutrition: nutrition)
            }

            retakeButton
        }
        .padding(20)
        .background(Color.ScanSemantic.resultCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(
            color: Color.ScanSemantic.resultCardShadow,
            radius: 20, x: 0, y: -4
        )
    }

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Scan Result")
                    .font(Font.AppFont.title4)
                    .foregroundColor(Color.ScanSemantic.ingredientTitle)

                if let date = result.scannedAt {
                    Text(date, style: .relative)
                        .font(Font.AppFont.textCaption)
                        .foregroundColor(Color.ScanSemantic.ingredientReason)
                }
            }

            Spacer()

            VerdictBadge(verdict: result.verdict)
        }
    }

    private func summarySection(_ summary: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "info.circle.fill")
                .foregroundColor(Color.ScanSemantic.summaryIcon)
                .font(.system(size: 18))
                .padding(.top, 2)

            Text(summary)
                .font(Font.AppFont.textDefault)
                .foregroundColor(Color.ScanSemantic.summaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .background(Color.ScanSemantic.summaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var retakeButton: some View {
        Button(action: onRetake) {
            HStack(spacing: 8) {
                Image(systemName: "camera.rotate.fill")
                    .font(.system(size: 16, weight: .semibold))
                Text("Scan Again")
                    .font(Font.AppFont.plusJakartaSansSemiBold16)
            }
            .foregroundColor(Color.ScanSemantic.retakeButtonText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.ScanSemantic.retakeButtonBackground)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}
