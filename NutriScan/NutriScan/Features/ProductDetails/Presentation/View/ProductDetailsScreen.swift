import SwiftUI

struct ProductDetailsScreen: View {
    @EnvironmentObject private var router: AppRouter
    @State private var viewModel: ProductDetailsViewModel
    @State private var activeAlert: ActiveAlert = .none
    @MainActor
    init(scanId: String) {
        _viewModel = State(wrappedValue: ProductDetailsViewModel(scanId: scanId))
    }

    /// Init with pre-loaded ScanDetail — no API call needed.
    init(scanDetail: ScanDetail) {
        _viewModel = State(wrappedValue: ProductDetailsViewModel(scanDetail: scanDetail))
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                HStack(spacing: 16) {
                    BackButton(action: { router.pop() }, style: .onTeal)
                    Text("Product Details")
                        .font(Font.AppFont.subtitle1)
                        .foregroundStyle(Color.white)
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
        .navigationBarBackButtonHidden(true)
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
