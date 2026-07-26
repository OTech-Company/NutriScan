//
//  ProductDetailsScreen.swift
//  NutriScan
//
//  Created by albaraa alsayed on 10/02/1448 AH.
//

import SwiftUI

struct ProductDetailsScreen: View {

    @StateObject private var viewModel: ProductDetailsViewModel

    init(scanId: String) {
        _viewModel = StateObject(wrappedValue: ProductDetailsViewModel(scanId: scanId))
    }

    init(detail: ScanDetail) {
        _viewModel = StateObject(wrappedValue: ProductDetailsViewModel(detail: detail))
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack{
                HStack(spacing: 16) {
                    BackButton {
                        
                    }
                    Text("Product Details")
                        .font(Font.AppFont.subtitle1)
                        .foregroundStyle(Color(red: 255, green: 255, blue: 255))
                }
                Spacer()
                Image(.bookmarkStroke)
                    .padding(8)
                    .background{
                            RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(Color.Teal.teal700)
                    }
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 16)
            
            if viewModel.isLoading {
                Spacer()
                ProgressView("Loading scan details...")
                Spacer()
            } else if let state = viewModel.uiState {
                ProductSheetView(state: state)
            } else {
                Spacer()
                Text(viewModel.errorMessage ?? "No scan data.")
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
        .background(Color.Teal.teal1000)
        .ignoresSafeArea(.container, edges: .bottom)
        .onAppear {
            viewModel.loadIfNeeded()
        }
    }
}

#Preview {
    ProductDetailsScreen(scanId: "preview-id")
}
