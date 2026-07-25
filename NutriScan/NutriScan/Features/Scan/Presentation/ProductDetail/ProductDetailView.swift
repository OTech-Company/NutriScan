import SwiftUI

struct ProductDetailView: View {

    @StateObject private var viewModel: ProductDetailViewModel

    init(scanId: String) {
        _viewModel = StateObject(wrappedValue: ProductDetailViewModel(scanId: scanId))
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading scan details...")
            } else if let detail = viewModel.scanDetail {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        headerSection(detail: detail)

                        if let safety = detail.foodSafetyResponse {
                            safetySection(safety)
                        }

                        if let nutrition = detail.nutritionFacts {
                            nutritionSection(nutrition)
                        }
                    }
                    .padding()
                }
            } else {
                Text(viewModel.errorMessage ?? "No scan data.")
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Scan Result")
        .onAppear { viewModel.loadIfNeeded() }
    }

    // MARK: - Header

    private func headerSection(detail: ScanDetail) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let url = detail.imageUrl, let imageURL = URL(string: url) {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFit()
                    default:
                        Rectangle()
                            .fill(Color(.systemGray6))
                            .frame(height: 200)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            HStack {
                Text(detail.status.rawValue.uppercased())
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(detail.status == .completed ? Color.green : Color.orange)
                    .clipShape(Capsule())

                if let date = detail.scannedAt {
                    Text(date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    // MARK: - Safety

    private func safetySection(_ safety: ScanFoodSafetyResponse) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Safety")
                .font(.headline)

            HStack {
                Text("Verdict:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(safety.verdict.rawValue)
                    .font(.subheadline.bold())
                    .foregroundColor(safety.verdict == .safe ? .green : .red)
            }

            if !safety.summary.isEmpty {
                Text(safety.summary)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            if !safety.flaggedIngredients.isEmpty {
                Text("Flagged Ingredients")
                    .font(.subheadline.bold())
                    .padding(.top, 4)

                ForEach(safety.flaggedIngredients.indices, id: \.self) { index in
                    let ingredient = safety.flaggedIngredients[index]
                    VStack(alignment: .leading, spacing: 2) {
                        Text(ingredient.ingredient)
                            .font(.subheadline.bold())
                        Text(ingredient.reason)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 2)
                }
            }
        }
    }

    // MARK: - Nutrition

    private func nutritionSection(_ nutrition: ScanNutritionFacts) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Nutrition Facts")
                .font(.headline)

            VStack(alignment: .leading, spacing: 4) {
                nutritionRow(label: "Calories", value: "\(nutrition.calories)")
                nutritionRow(label: "Protein", value: String(format: "%.1fg", nutrition.proteinGrams))
                nutritionRow(label: "Carbs", value: String(format: "%.1fg", nutrition.carbsGrams))
                nutritionRow(label: "Fat", value: String(format: "%.1fg", nutrition.fatG))
                nutritionRow(label: "Fiber", value: String(format: "%.1fg", nutrition.fiberGrams))
                nutritionRow(label: "Sugar", value: String(format: "%.1fg", nutrition.sugarG))
                nutritionRow(label: "Sodium", value: String(format: "%.0fmg", nutrition.sodiumMg))
            }
        }
    }

    private func nutritionRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline.bold())
        }
        .padding(.vertical, 2)
        Divider()
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(scanId: "3fa85f64-5717-4562-b3fc-2c963f66afa6")
    }
}
