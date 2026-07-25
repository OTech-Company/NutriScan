//
//  ProductDetailView.swift
//  NutriScan
//
//  Created by Osama Hosam on 19/07/2026.
//


import SwiftUI

struct ProductDetailView: View {

    @StateObject private var viewModel: ProductDetailViewModel

    init(barcode: String) {
        _viewModel = StateObject(wrappedValue: ProductDetailViewModel(barcode: barcode))
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading product…")
            } else if let product = viewModel.product {
                VStack(alignment: .leading, spacing: 12) {
                    Text(product.brand.uppercased())
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(product.name)
                        .font(.title2.bold())
                    Text("Barcode: \(product.barcode)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding()
            } else {
                Text(viewModel.errorMessage ?? "No product data.")
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Product")
        .onAppear { viewModel.loadIfNeeded() }
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(barcode: "6223000123456")
    }
}
