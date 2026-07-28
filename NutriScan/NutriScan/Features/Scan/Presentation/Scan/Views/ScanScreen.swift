import SwiftUI

struct ScanScreen: View {

    @EnvironmentObject private var router: AppRouter
    @StateObject private var viewModel: ScanViewModel

    private let viewfinderHeight: CGFloat = 520
    private let viewfinderHorizontalPadding: CGFloat = 20
    private let viewfinderOffsetY: CGFloat = -40

    init(viewModel: ScanViewModel = ScanViewModel.makeDefault()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        GeometryReader { geo in
            let viewfinderWidth = geo.size.width - (viewfinderHorizontalPadding * 2)
            let viewfinderY = (geo.size.height - viewfinderHeight) / 2 + viewfinderOffsetY

            ZStack {
                BarcodeScannerView(
                    onDetect: { code, position in
                        viewModel.onBarcodeDetected(code, at: position)
                    },
                    onPhotoCapture: { imageData in
                        viewModel.onPhotoCaptured(imageData)
                    }
                )
                .ignoresSafeArea()

                ScanMask(windowHeight: viewfinderHeight, verticalOffset: viewfinderOffsetY)
                    .ignoresSafeArea()

                ScanViewfinderView()
                    .frame(width: viewfinderWidth, height: viewfinderHeight)
                    .position(x: geo.size.width / 2, y: viewfinderY + (viewfinderHeight / 2))

                if let barcode = viewModel.detectedBarcode,
                   let position = viewModel.barcodePosition {
                    BarcodeOverlayView(barcode: barcode) {
                        viewModel.lookupByBarcode()
                    }
                    .position(x: position.x, y: position.y - 30)
                    .animation(.spring(response: 0.3, dampingFraction: 0.9), value: viewModel.barcodePosition)
                }

                VStack {
                    Spacer()
                    ScanStateCardView(
                        isSubmitting: viewModel.isSubmitting,
                        latestScan: viewModel.latestScan,
                        isLoadingDetail: viewModel.isLoadingDetail,
                        scanDetail: viewModel.scanDetail,
                        capturedImageData: viewModel.capturedImageData,
                        onSave: { viewModel.toggleSaveFavorite() },
                        onRetry: { viewModel.reset() },
                        onTapDetail: { detail in
                            router.path.append(AnyRoute(
                                ScanRoute.scanDetail(detail: detail, imageData: viewModel.capturedImageData ?? Data())
                            ))
                        }
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 130)
                }
            }
        }
        .ignoresSafeArea()
        .toolbar(.hidden, for: .navigationBar)
        .onDisappear {
            viewModel.reset()
        }
        .customAlert(
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.dismissError() } }
            ),
            type: .error,
            title: "Scan Failed",
            description: viewModel.errorMessage ?? "Unknown error",
            primaryButtonTitle: "OK",
            primaryButtonColor: Color.Red.red500,
            primaryAction: { viewModel.dismissError() }
        )
    }
}

#Preview {
    ScanScreen()
}
