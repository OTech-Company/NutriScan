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
        }
        .toolbar(.hidden, for: .navigationBar)
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
            onDetect: { _ in },
            onPhotoCapture: { imageData in
                viewModel.onPhotoCaptured(imageData)
            }
        )
    }

    // MARK: - Rectangle Viewfinder

    private var rectangleViewfinder: some View {
        VStack {
            Spacer()
            Rectangle()
                .stroke(Color.white.opacity(0.8), lineWidth: 2)
                .frame(height: 260)
                .overlay(
                    cornerBrackets
                )
            Spacer()
        }
    }

    private var cornerBrackets: some View {
        GeometryReader { geo in
            let cornerLength: CGFloat = 28
            let cornerRadius: CGFloat = 16
            let w = geo.size.width
            let h = geo.size.height

            Path { path in
                // Top-left
                path.move(to: CGPoint(x: 0, y: cornerLength))
                path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius),
                           radius: cornerRadius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
                path.addLine(to: CGPoint(x: cornerLength, y: 0))

                // Top-right
                path.move(to: CGPoint(x: w - cornerLength, y: 0))
                path.addArc(center: CGPoint(x: w - cornerRadius, y: cornerRadius),
                           radius: cornerRadius, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)
                path.addLine(to: CGPoint(x: w, y: cornerLength))

                // Bottom-right
                path.move(to: CGPoint(x: w, y: h - cornerLength))
                path.addArc(center: CGPoint(x: w - cornerRadius, y: h - cornerRadius),
                           radius: cornerRadius, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
                path.addLine(to: CGPoint(x: w - cornerLength, y: h))

                // Bottom-left
                path.move(to: CGPoint(x: cornerLength, y: h))
                path.addArc(center: CGPoint(x: cornerRadius, y: h - cornerRadius),
                           radius: cornerRadius, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
                path.addLine(to: CGPoint(x: 0, y: h - cornerLength))
            }
            .stroke(Color.white, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
        }
    }

    // MARK: - Scan State Card (changes based on load state)

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

    // MARK: - Processing Card (spinner)

    private var processingCard: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray5))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: "photo")
                        .foregroundColor(.secondary)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text("FANMILK")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.7))
                Text("Analyzing...")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
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

    // MARK: - Result Card (safe/unsafe)

    private func resultCard(detail: ScanDetail, scanId: String) -> some View {
        Button {
            router.path.append(AnyRoute(ScanRoute.scanDetail(scanId: scanId)))
        } label: {
            HStack(spacing: 12) {
                if let url = detail.imageUrl, let imageURL = URL(string: url) {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().scaledToFit()
                        default:
                            Color(.systemGray5)
                        }
                    }
                    .frame(width: 48, height: 48)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray5))
                        .frame(width: 48, height: 48)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.secondary)
                        )
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("FANMILK")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.7))
                    Text(detail.foodSafetyResponse?.summary ?? "Scan complete")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                }

                Spacer()

                if detail.foodSafetyResponse?.verdict == .safe {
                    Image(systemName: "bookmark.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                } else {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.yellow)
                }
            }
        }
        .padding(12)
        .background(cardBackground(for: detail))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.2), radius: 10, y: 4)
    }

    private func cardBackground(for detail: ScanDetail) -> Color {
        switch detail.foodSafetyResponse?.verdict {
        case .safe:
            return Color.Teal.teal800.opacity(0.9)
        case .unsafe:
            return Color.Red.red500.opacity(0.9)
        case .caution:
            return Color.orange.opacity(0.9)
        default:
            return Color.Teal.teal800.opacity(0.9)
        }
    }

    // MARK: - Failed Card

    private var failedCard: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.Red.red500.opacity(0.3))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text("Scan Failed")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.7))
                Text("Tap to retry")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
            }

            Spacer()

            Image(systemName: "arrow.counterclockwise")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
        }
        .padding(12)
        .background(Color.Red.red500.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.2), radius: 10, y: 4)
        .onTapGesture {
            viewModel.reset()
        }
    }

    // MARK: - Top bar

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
}

// MARK: - Preview

#Preview {
    ScanScreen()
}
