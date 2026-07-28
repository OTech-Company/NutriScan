//
//  ProductDetailsScreen.swift
//  NutriScan
//
//  Created by albaraa alsayed on 10/02/1448 AH.
//

import SwiftUI

struct ProductDetailsScreen: View {
    @State private var viewModel: ProductDetailsViewModel
    @State private var activeAlert: ActiveAlert = .none
    @MainActor
    init(scanId: String) {
        _viewModel = State(wrappedValue: ProductDetailsViewModel(scanId: scanId))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack{
                HStack(spacing: 16) {
                    BackButton(action: {}, style: .onTeal)
                    Text("Product Details")
                        .font(Font.AppFont.subtitle1)
                        .foregroundStyle(Color(red: 255, green: 255, blue: 255))
                }
                Spacer()
                
                if let isFavorite = viewModel.uiState?.isFavorite {
                    Image(isFavorite ? .bookmarkFill : .bookmarkStroke)
                        .padding(8)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(Color.Teal.teal700)
                        }
                        .onTapGesture {
                            viewModel.toggleFavorite()
                        }
                } else {
                    Image(.bookmarkStroke)
                        .padding(8)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(Color.Teal.teal700)
                        }
                }
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 16)
            
            if viewModel.isLoading {
                Spacer()
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
                Spacer()
            } else if let uiState = viewModel.uiState {
                ProductSheetView(state: uiState)
            } else {
                Spacer()
            }
        }
        .background(Color.Teal.teal1000)
        .ignoresSafeArea(.container, edges: .bottom)
        .task {
            await viewModel.loadProductDetails()
        }
        .onChange(of: viewModel.failureMessage) { _, message in
            if message != nil {
                activeAlert = .error
            }
        }
        .customAlert(activeAlert: $activeAlert, config: { alert in
            switch alert {
            case .error:
                return CustomAlertConfig(
                    type: .error,
                    title: "Error",
                    description: viewModel.failureMessage ?? "An unknown error occurred",
                    primaryButtonTitle: "Retry",
                    primaryButtonColor: Color.Red.red500
                )
            default:
                return CustomAlertConfig(type: .error, title: "Error", description: "")
            }
        }, primaryAction: { _ in
            viewModel.failureMessage = nil
            Task { await viewModel.loadProductDetails() }
        })
    }
}

#Preview {
    struct MockProductDetailsRepo: ProductDetailsRepo {
        func getProductDetails(scanId: String) async throws -> ProductDetails {
            
            return ProductDetails(
                scanId: scanId,
                scannedAt: "2026-07-13",
                imageUrl: "https://www.heritagefoods.in/blog/wp-content/uploads/2020/12/shutterstock_539045662.jpg",
                productName: "Milk Product\nName",
                verdict: "Unsafe",
                summary: "Contains hazelnuts and milk, both of which match allergies on your profile.",
                flagedIngredients: [
                    ProductDetailsFlagedIngredient(ingredient: "Hazelnuts", reason: "Tree Nuts Allergy", type: "Matches allergy in your profile", name: []),
                    ProductDetailsFlagedIngredient(ingredient: "Skimmed Milk Powder", reason: "Lactose Intolerance", type: "Contains milk ingredient", name: [])
                ],
                calories: 80,
                proteinGrams: 0,
                carbsGrams: 0,
                fatG: 4.5,
                fiberGrams: 0,
                sugarG: 8.5,
                sodiumMg: 0,
                isFavorite: false
            )
        }
        
        func updateFavorite(scanId: String, isFavorite: Bool) async throws {
            try await Task.sleep(nanoseconds: 300_000_000)
        }
    }
    
    let mockRepo = MockProductDetailsRepo()
    let mockUseCase = GetProductDetailsUseCase(repository: mockRepo)
    
    DIContainer.shared.register(type: ProductDetailsRepo.self, component: mockRepo)
    DIContainer.shared.register(type: GetProductDetailsUseCase.self, component: mockUseCase)
    
    Thread.sleep(forTimeInterval: 0.1)
    
    return ProductDetailsScreen(scanId: "mock-1234")
}
