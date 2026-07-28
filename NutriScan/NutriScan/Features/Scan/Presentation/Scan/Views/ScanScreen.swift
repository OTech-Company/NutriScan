import SwiftUI

struct ScanScreen: View {

    @StateObject private var viewModel: ScanViewModel

    private let viewfinderHeight: CGFloat = 520
    private let viewfinderHorizontalPadding: CGFloat = 20

    init(viewModel: ScanViewModel = ScanViewModel.makeDefault()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        GeometryReader { geo in
            let viewfinderWidth = geo.size.width - (viewfinderHorizontalPadding * 2)
            let viewfinderY = (geo.size.height - viewfinderHeight) / 2

            ZStack {
                // Camera feed (full screen including safe areas)
                BarcodeScannerView(
                    onDetect: { code, position in
                        viewModel.onBarcodeDetected(code, at: position)
                    },
                    onPhotoCapture: { imageData in
                        viewModel.onPhotoCaptured(imageData)
                    }
                )
                .ignoresSafeArea()

                // Dark overlay with scan window cutout
                ScanMask(windowHeight: viewfinderHeight)
                    .ignoresSafeArea()

                // Viewfinder brackets + scanning wave
                ScanViewfinderView()
                    .frame(width: viewfinderWidth, height: viewfinderHeight)
                    .position(x: geo.size.width / 2, y: viewfinderY + (viewfinderHeight / 2))

                // Barcode detected overlay pill
                if let barcode = viewModel.detectedBarcode,
                   let position = viewModel.barcodePosition {
                    BarcodeOverlayView(barcode: barcode) {
                        viewModel.lookupByBarcode()
                    }
                    .position(x: position.x, y: position.y - 30)
                    .animation(.spring(response: 0.3, dampingFraction: 0.9), value: viewModel.barcodePosition)
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

// MARK: - Preview

#Preview {
    ScanScreen()
}
