import SwiftUI

struct ScanScreen: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var router: AppRouter
    @StateObject private var viewModel: ScanViewModel

    init(viewModel: ScanViewModel = ScanViewModel.makeDefault()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            cameraBackground
                .ignoresSafeArea()

            rectangleViewfinder
                .padding(.horizontal, 24)
                .ignoresSafeArea()

            VStack {
                topBar
                Spacer()
                scanStateCard
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
            }

            // Barcode detected pill button
            if let barcode = viewModel.detectedBarcode, let position = viewModel.barcodePosition {
                barcodePillButton(barcode: barcode)
                    .position(x: position.x, y: position.y + 40)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: viewModel.detectedBarcode)
        .animation(.spring(response: 0.3, dampingFraction: 0.9), value: viewModel.barcodePosition)
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

    // MARK: - Camera Background

    private var cameraBackground: some View {
        BarcodeScannerView(
            onDetect: { code, position in
                viewModel.onBarcodeDetected(code, at: position)
            },
            onPhotoCapture: { imageData in
                viewModel.onPhotoCaptured(imageData)
            }
        )
    }

    // MARK: - Rectangle Viewfinder

    private var rectangleViewfinder: some View {
        VStack {
            Spacer()
            ZStack {
                Rectangle()
                    .stroke(Color.white.opacity(0.8), lineWidth: 2)
                    .frame(height: 260)

                // Scanning wave animation
                TimelineView(.animation(minimumInterval: 1.0 / 60.0)) { timeline in
                    let time = timeline.date.timeIntervalSinceReferenceDate
                    let cycle = time.remainder(dividingBy: 2.0)
                    let progress = cycle / 2.0
                    let yOffset = (progress - 0.5) * 260

                    scanningWave(yOffset: yOffset)
                }
                .frame(height: 260)
                .clipped()

                cornerBrackets
            }
            Spacer()
        }
    }

    private func scanningWave(yOffset: CGFloat) -> some View {
        GeometryReader { geo in
            let width = geo.size.width

            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: width, y: 0))
            }
            .stroke(
                LinearGradient(
                    colors: [Color.teal.opacity(0), Color.teal, Color.teal, Color.teal.opacity(0)],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                style: StrokeStyle(lineWidth: 2, lineCap: .round)
            )
            .shadow(color: .teal, radius: 8)
            .offset(y: yOffset)
        }
    }

    private var cornerBrackets: some View {
        GeometryReader { geo in
            let cornerLength: CGFloat = 28
            let cornerRadius: CGFloat = 16
            let w = geo.size.width
            let h = geo.size.height

            Path { path in
                path.move(to: CGPoint(x: 0, y: cornerLength))
                path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius),
                           radius: cornerRadius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
                path.addLine(to: CGPoint(x: cornerLength, y: 0))

                path.move(to: CGPoint(x: w - cornerLength, y: 0))
                path.addArc(center: CGPoint(x: w - cornerRadius, y: cornerRadius),
                           radius: cornerRadius, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)
                path.addLine(to: CGPoint(x: w, y: cornerLength))

                path.move(to: CGPoint(x: w, y: h - cornerLength))
                path.addArc(center: CGPoint(x: w - cornerRadius, y: h - cornerRadius),
                           radius: cornerRadius, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
                path.addLine(to: CGPoint(x: w - cornerLength, y: h))

                path.move(to: CGPoint(x: cornerLength, y: h))
                path.addArc(center: CGPoint(x: cornerRadius, y: h - cornerRadius),
                           radius: cornerRadius, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
                path.addLine(to: CGPoint(x: 0, y: h - cornerLength))
            }
            .stroke(Color.white, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
        }
    }

    // MARK: - Scan State Card

    @ViewBuilder
    private var scanStateCard: some View {
        if let imageData = viewModel.capturedImageData {
            if viewModel.isSubmitting {
                processingCard(imageData: imageData)
            } else if let scan = viewModel.latestScan {
                if viewModel.isLoadingDetail {
                    processingCard(imageData: imageData)
                } else if let detail = viewModel.scanDetail {
                    if detail.status == .completed {
                        resultCard(detail: detail, imageData: imageData, scanId: scan.scanId)
                    } else if detail.status == .failed {
                        failedCard(imageData: imageData)
                    } else {
                        processingCard(imageData: imageData)
                    }
                } else {
                    processingCard(imageData: imageData)
                }
            } else {
                processingCard(imageData: imageData)
            }
        }
    }

    // MARK: - Processing Card

    private func processingCard(imageData: Data) -> some View {
        HStack(spacing: 12) {
            capturedImageThumbnail(imageData)

            VStack(alignment: .leading, spacing: 2) {
                Text("FANMILK")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.7))
                Text("Analyzing...")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                badge(text: "Processing", color: .orange)
            }

            Spacer()

            ProgressView()
                .tint(.white)
        }
        .padding(12)
        .background(Color.Teal.teal800.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.2), radius: 10, y: 4)
    }

    // MARK: - Result Card

    private func resultCard(detail: ScanDetail, imageData: Data, scanId: String) -> some View {
        ZStack(alignment: .trailing) {
            Button {
                router.path.append(AnyRoute(ScanRoute.scanDetail(scanId: scanId, imageData: imageData)))
            } label: {
                HStack(spacing: 12) {
                    capturedImageThumbnail(imageData)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("FANMILK")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.7))
                        Text(detail.foodSafetyResponse?.summary ?? "Scan complete")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .lineLimit(1)

                        if let verdict = detail.foodSafetyResponse?.verdict {
                            badge(text: verdict.rawValue.capitalized, color: verdict == .safe ? .teal : .red)
                        }
                    }

                    Spacer()
                }
            }

            Button {
                viewModel.toggleSaveFavorite()
            } label: {
                Image(systemName: viewModel.isSaved ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.trailing, 4)
        }
        .padding(12)
        .background(Color.Teal.teal800.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.2), radius: 10, y: 4)
    }

    // MARK: - Failed Card

    private func failedCard(imageData: Data) -> some View {
        HStack(spacing: 12) {
            capturedImageThumbnail(imageData)

            VStack(alignment: .leading, spacing: 2) {
                Text("FANMILK")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.7))
                Text("Scan Failed")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                badge(text: "Failed", color: .red)
            }

            Spacer()

            Image(systemName: "arrow.counterclockwise")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
        }
        .padding(12)
        .background(Color.Teal.teal800.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.2), radius: 10, y: 4)
        .onTapGesture {
            viewModel.reset()
        }
    }

    // MARK: - Helpers

    private func barcodePillButton(barcode: String) -> some View {
        Button {
            viewModel.lookupByBarcode()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .semibold))
                Text(barcode)
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.black.opacity(0.7))
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
        }
    }

    private func capturedImageThumbnail(_ imageData: Data) -> some View {
        Group {
            if let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Color(.systemGray5)
                    .overlay(Image(systemName: "photo").foregroundColor(.secondary))
            }
        }
        .frame(width: 48, height: 48)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func badge(text: String, color: Color) -> some View {
        Text(text)
            .font(.caption2)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color)
            .clipShape(Capsule())
    }

    // MARK: - Top bar

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
