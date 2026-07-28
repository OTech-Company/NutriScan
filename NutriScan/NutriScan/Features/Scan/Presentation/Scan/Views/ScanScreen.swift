import SwiftUI

struct ScanScreen: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var router: AppRouter
    @StateObject private var viewModel: ScanViewModel

    private let viewfinderHeight: CGFloat = 520

    init(viewModel: ScanViewModel = ScanViewModel.makeDefault()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            // Camera feed (full screen background)
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

            // Viewfinder with corner brackets + scanning wave
            viewfinder

            // Barcode detected overlay pill
            if let barcode = viewModel.detectedBarcode,
               let position = viewModel.barcodePosition {
                barcodeOverlay(barcode: barcode, position: position)
                    .animation(.spring(response: 0.3, dampingFraction: 0.9), value: viewModel.barcodePosition)
            }

            // Top bar (fixed at top)
            VStack {
                topBar
                Spacer()
            }

            // Product card (fixed at bottom, not affected by other elements)
            VStack {
                Spacer()
                scanStateCard
                    .padding(.horizontal, 16)
                    .padding(.bottom, 40)
            }
        }
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

    // MARK: - Viewfinder

    private var viewfinder: some View {
        VStack {
            Spacer()
            ZStack {
                // Viewfinder rectangle border
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    .frame(height: viewfinderHeight)

                // Corner brackets
                CornerBracketsShape(cornerLength: 32, cornerRadius: 20)
                    .stroke(Color.white, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                    .frame(height: viewfinderHeight)

                // Scanning wave animation
                scanningWave
                    .frame(height: viewfinderHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding(.horizontal, 20)
            Spacer()
        }
    }

    // MARK: - Scanning Wave

    private var scanningWave: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 60.0)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            let cycle = time.remainder(dividingBy: 2.5)
            let progress = cycle / 2.5
            let yOffset = (progress - 0.5) * viewfinderHeight

            GeometryReader { geo in
                // Main bright line
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.Teal.teal1000.opacity(0),
                                Color.Teal.teal1000.opacity(0.6),
                                Color.Teal.teal1000,
                                Color.Teal.teal1000.opacity(0.6),
                                Color.Teal.teal1000.opacity(0)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 2)
                    .offset(y: yOffset)

                // Glow above the line
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.Teal.teal1000.opacity(0),
                                Color.Teal.teal1000.opacity(0.12)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 60)
                    .offset(y: yOffset - 60)

                // Glow below the line
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.Teal.teal1000.opacity(0.12),
                                Color.Teal.teal1000.opacity(0)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 60)
                    .offset(y: yOffset + 2)
            }
        }
    }

    // MARK: - Barcode Overlay

    private func barcodeOverlay(barcode: String, position: CGPoint) -> some View {
        Button {
            viewModel.lookupByBarcode()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "barcode.viewfinder")
                    .font(.system(size: 16, weight: .semibold))
                Text(barcode)
                    .font(.system(size: 15, weight: .medium, design: .monospaced))
                    .lineLimit(1)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Capsule()
                            .stroke(Color.Teal.teal1000.opacity(0.6), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
        }
        .position(x: position.x, y: position.y - 30)
        .transition(.scale.combined(with: .opacity))
    }

    // MARK: - Scan State Card

    @ViewBuilder
    private var scanStateCard: some View {
        if viewModel.isSubmitting {
            processingCard
        } else if let scan = viewModel.latestScan {
            if viewModel.isLoadingDetail {
                processingCard
            } else if let detail = viewModel.scanDetail {
                if detail.status == .completed {
                    resultCard(detail: detail, scanId: scan.scanId)
                } else if detail.status == .failed {
                    failedCard
                } else {
                    processingCard
                }
            } else {
                processingCard
            }
        }
    }

    // MARK: - Processing Card

    private var processingCard: some View {
        ProductMatchCard(
            status: .processing,
            imageData: viewModel.capturedImageData,
            productName: nil,
            brandName: nil,
            scanSummary: nil
        )
    }

    // MARK: - Result Card

    private func resultCard(detail: ScanDetail, scanId: String) -> some View {
        let status: ProductMatchStatus = {
            switch detail.foodSafetyResponse?.verdict {
            case .safe:  return .safe
            case .unsafe, .caution: return .unsafe
            default:     return .processing
            }
        }()

        return ProductMatchCard(
            status: status,
            imageData: viewModel.capturedImageData,
            productName: detail.productName,
            brandName: nil,
            scanSummary: detail.foodSafetyResponse?.summary,
            onSave: {
                viewModel.toggleSaveFavorite()
            }
        )
        .onTapGesture {
            router.path.append(AnyRoute(ScanRoute.scanDetail(scanId: scanId, imageData: viewModel.capturedImageData ?? Data())))
        }
    }

    // MARK: - Failed Card

    private var failedCard: some View {
        ProductMatchCard(
            status: .unsafe,
            imageData: viewModel.capturedImageData,
            productName: "Scan Failed",
            brandName: nil,
            scanSummary: "Could not analyze product",
            onRetry: {
                viewModel.reset()
            }
        )
        .onTapGesture {
            viewModel.reset()
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            BackButton(action: { dismiss() }, style: .onTeal)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}

// MARK: - Preview

#Preview {
    ScanScreen()
}
