import PhotosUI
import SwiftUI

struct ScanScreen: View {
    private enum AlertDestination: String, Identifiable {
        case scanError
        var id: String { rawValue }
    }

    @EnvironmentObject private var router: AppRouter
    @StateObject private var viewModel: ScanViewModel
    @State private var gallerySelection: PhotosPickerItem?
    @State private var alert: AlertDestination?

    // Adjusted sizes and offsets to prevent viewfinder overlay
    private let viewfinderHeight: CGFloat = 500
    private let viewfinderHorizontalPadding: CGFloat = 24
    private let viewfinderOffsetY: CGFloat = -70

    init(viewModel: ScanViewModel = ScanViewModel.makeDefault()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    private static func jpegNormalized(_ data: Data) -> Data {
        guard let image = UIImage(data: data),
              let jpeg = image.jpegData(compressionQuality: 0.9) else {
            return data
        }
        return jpeg
    }

    var body: some View {
        GeometryReader { geo in
            let viewfinderWidth = geo.size.width - (viewfinderHorizontalPadding * 2)
            let viewfinderY = (geo.size.height - viewfinderHeight) / 2 + viewfinderOffsetY

            ZStack {
                // MARK: - Camera Feed & Mask
                BarcodeScannerView(
                    onDetect: { code, position, size in
                        viewModel.onBarcodeDetected(code, at: position, size: size)
                    },
                    onLost: {
                        viewModel.scheduleDismissBarcode()
                    },
                    onPhotoCapture: { imageData in
                        viewModel.onPhotoCaptured(imageData)
                    }
                )
                .ignoresSafeArea()

                ScanMask(windowHeight: viewfinderHeight, verticalOffset: viewfinderOffsetY)
                    .ignoresSafeArea()

                ScanViewfinderView(isScanning: !viewModel.isSubmitting && viewModel.latestScan == nil)
                    .frame(width: viewfinderWidth, height: viewfinderHeight)
                    .position(x: geo.size.width / 2, y: viewfinderY + (viewfinderHeight / 2))

                // MARK: - Barcode Highlight Overlay
                if let barcode = viewModel.detectedBarcode,
                   let position = viewModel.barcodePosition {
                    BarcodeOverlayView(
                        barcode: barcode,
                        barcodeSize: viewModel.barcodeSize
                    ) {
                        viewModel.lookupByBarcode()
                    }
                    .position(x: position.x, y: position.y + (viewModel.barcodeSize.height / 2) - 12)
                    .animation(.spring(response: 0.3, dampingFraction: 0.9), value: viewModel.barcodePosition)
                }

                // MARK: - Bottom Controls & Status Card
                VStack(spacing: 12) {
                    Spacer()

                    // Product Result / Status Card
                    ScanStateCardView(
                        isSubmitting: viewModel.isSubmitting,
                        latestScan: viewModel.latestScan,
                        isLoadingDetail: viewModel.isLoadingDetail,
                        scanDetail: viewModel.scanDetail,
                        capturedImageData: viewModel.capturedImageData,
                        isSaved: viewModel.isSaved,
                        onSave: { viewModel.toggleSaveFavorite() },
                        onRetry: { viewModel.reset() },
                        onTapDetail: { detail in
                            router.path.append(AnyRoute(
                                ScanRoute.scanDetail(detail: detail, imageData: viewModel.capturedImageData ?? Data())
                            ))
                        }
                    )
                    .padding(.horizontal, 16)

                    // Bottom Row (Gallery Picker Button)
                    HStack {
                        GalleryButton {
                            viewModel.presentGallery()
                        }
                        .padding(.leading, 16)

                        Spacer()
                    }
                }
                .padding(.bottom, CustomAnimatedTabBar.contentClearance + 12)
            }
        }
        .ignoresSafeArea()
        .toolbar(.hidden, for: .navigationBar)
        .onDisappear {
            viewModel.reset()
        }
        .photosPicker(
            isPresented: $viewModel.isGalleryPresented,
            selection: $gallerySelection,
            matching: .images
        )
        .onChange(of: gallerySelection) { _, newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self) {
                    let jpegData = Self.jpegNormalized(data)
                    viewModel.onPhotoCaptured(jpegData)
                }
                gallerySelection = nil
            }
        }
        .onChange(of: viewModel.errorMessage) { _, message in
            alert = message == nil ? nil : .scanError
        }
        .customAlert(
            item: $alert,
            config: { _ in
                CustomAlertConfig(
                    type: .error,
                    title: LocalizationKeys.Scan.scanFailed.localized,
                    message: viewModel.errorMessage ?? LocalizationKeys.Common.unknownError.localized,
                    primaryButton: CustomAlertButton(LocalizationKeys.Common.ok.localized)
                )
            },
            primaryAction: { _ in viewModel.dismissError() }
        )
    }
}

#Preview {
    ScanScreen()
}
