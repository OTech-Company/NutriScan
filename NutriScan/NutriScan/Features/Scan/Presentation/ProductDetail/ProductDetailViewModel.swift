//
//  ProductDetailViewModel.swift
//  NutriScan
//
//  Created by Osama Hosam on 19/07/2026.
//


import Foundation

@MainActor
final class ProductDetailViewModel: ObservableObject {

    @Published private(set) var product: Product?
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    let barcode: String
    private let lookupProductUseCase: LookupProductUseCase

    nonisolated init(
        barcode: String,
        lookupProductUseCase: LookupProductUseCase = DIContainer.shared.resolve(type: LookupProductUseCase.self)
    ) {
        self.barcode = barcode
        self.lookupProductUseCase = lookupProductUseCase
    }

    func loadIfNeeded() {
        guard product == nil, !isLoading else { return }
        Task { await load() }
    }

    private func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            product = try await lookupProductUseCase.execute(barcode: barcode)
        } catch let error as ProductError {
            errorMessage = error.userMessage
        } catch {
            errorMessage = ProductError.unknown.userMessage
        }
    }
}