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
    
    init(scanId: String) {
        _viewModel = State(wrappedValue: ProductDetailsViewModel(scanId: scanId))
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
    ProductDetailsScreen(scanId: "mock-1234")
}
