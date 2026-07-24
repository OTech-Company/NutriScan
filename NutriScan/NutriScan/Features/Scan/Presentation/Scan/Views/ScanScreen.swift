import SwiftUI
import PhotosUI

struct ScanScreen: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ScanViewModel

    init(viewModel: ScanViewModel = ScanViewModel.makeDefault()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            cameraLayer
            ScanMask()
            cornerBrackets
                .padding(.horizontal, 40)
                .ignoresSafeArea()

            VStack {
                topBar
                Spacer()

                bottomContent
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            viewModel.startCamera()
        }
        .onDisappear {
            viewModel.stopCamera()
        }
        .alert(
            "Scan Error",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.dismissError() } }
            )
        ) {
            Button("OK", role: .cancel) { viewModel.dismissError() }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    @ViewBuilder
    private var cameraLayer: some View {
        if let capturedImage = viewModel.capturedImage {
            Image(uiImage: capturedImage)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        } else {
            CameraPreviewView(cameraManager: viewModel.cameraManager)
                .ignoresSafeArea()
        }
    }

    private var cornerBrackets: some View {
        CornerBracketsShape()
            .stroke(
                Color.ScanSemantic.viewfinderStroke,
                style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
            )
            .frame(height: 260)
    }

    @ViewBuilder
    private var bottomContent: some View {
        switch viewModel.state {
        case .idle, .capturing:
            idleControls
                .transition(.move(edge: .bottom).combined(with: .opacity))

        case .uploading, .processing:
            ScanningIndicator()
                .transition(.scale.combined(with: .opacity))

        case .result:
            if let result = viewModel.scanResult {
                ScrollView {
                    ScanResultCard(result: result) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                            viewModel.retake()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }

    private var idleControls: some View {
        VStack(spacing: 16) {
            CaptureButton {
                viewModel.capturePhoto()
            }

            PhotoPickerButton {
                viewModel.showGallery = true
            }
        }
        .padding(.bottom, 120)
        .photosPicker(
            isPresented: $viewModel.showGallery,
            selection: $viewModel.gallerySelection,
            matching: .images
        )
    }

    private var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.ScanSemantic.captureOuterRing)
                    .frame(width: 44, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.ScanSemantic.captureOuterRing, lineWidth: 1.5)
                    )
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}
