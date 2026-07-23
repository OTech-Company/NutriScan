import SwiftUI

/// Pure View layer: renders state from `ScanViewModel` and forwards user
/// intents to it. No networking, no use-case calls, no business rules here.
struct ScanScreen: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var router: AppRouter
    @StateObject private var viewModel: ScanViewModel

    init(viewModel: ScanViewModel = ScanViewModel(
            lookupProductUseCase: LookupProductUseCaseImpl(
                repository: ProductRepositoryImpl() 
            )
        )) {
            _viewModel = StateObject(wrappedValue: viewModel)
        }
    var body: some View {
        ZStack {
            Group {
                BarcodeScannerView { code in
                    viewModel.onBarcodeDetected(code)
                }

                ScanMask()
            }
            .ignoresSafeArea()

            cornerBracketFrame
                .padding(.horizontal, 40)
                .ignoresSafeArea()

            VStack {
                topBar
                
                Spacer() // This pushes the product card down to the bottom

                if let product = viewModel.detectedProduct {
                    ProductMatchCard(product: product) {
                        viewModel.addTapped()
                        router.path.append(AnyRoute(ScanRoute.productDetail(barcode: product.barcode)))
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 120) // Adjust this value to raise the card above your custom tab bar safely
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .customAlert(
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.dismissError() } }
            ),
            type: .error,
            title: "Couldn't find that product",
            description: viewModel.errorMessage ?? "Unknown error",
            primaryButtonTitle: "OK",
            primaryButtonColor: Color.Red.red500,
            primaryAction: { viewModel.dismissError() }
        )
    }

    // MARK: Top bar

    private var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.teal)
                    .frame(width: 44, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.teal, lineWidth: 1.5)
                    )
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    // MARK: Corner bracket viewfinder

        private var cornerBracketFrame: some View {
            CornerBracketsShape()
                .stroke(Color.white, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                .frame(height: 260)
        }
}

// MARK: - Preview

#Preview {
    ScanScreen()
}
