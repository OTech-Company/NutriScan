import SwiftUI

/// Pure View layer: renders state from `ScanViewModel` and forwards user
/// intents to it. No networking, no use-case calls, no business rules here.
struct ScanScreen: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var router: AppRouter
    @StateObject private var viewModel: ScanViewModel

    init(viewModel: ScanViewModel = .makeDefault()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            BarcodeScannerView { code in
                viewModel.onBarcodeDetected(code)
            }
            .ignoresSafeArea()

            ScanMask()
                .ignoresSafeArea()

            VStack {
                topBar
                Spacer()
                cornerBracketFrame
                    .padding(.horizontal, 40)
                Spacer()

                if let product = viewModel.detectedProduct {
                    ProductMatchCard(product: product) {
                        viewModel.addTapped()
                        router.path.append(AnyRoute(ScanRoute.productDetail(barcode: product.barcode)))
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .alert(
            "Couldn't find that product",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.dismissError() } }
            ),
            presenting: viewModel.errorMessage
        ) { _ in
            Button("OK") { viewModel.dismissError() }
        } message: { message in
            Text(message)
        }
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
        GeometryReader { geo in
            CornerBracketsShape()
                .stroke(Color.white, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: geo.size.width, height: 260)
        }
        .frame(height: 260)
    }
}

// MARK: - Preview

#Preview {
    ScanScreen()
}
