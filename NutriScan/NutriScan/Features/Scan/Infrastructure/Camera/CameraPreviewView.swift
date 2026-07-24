import SwiftUI
import AVFoundation

struct CameraPreviewView: UIViewRepresentable {

    let cameraManager: CameraManager

    func makeUIView(context: Context) -> CameraPreviewUIView {
        let view = CameraPreviewUIView()
        view.previewLayer = cameraManager.sessionPreviewLayer
        view.previewLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(view.previewLayer)
        return view
    }

    func updateUIView(_ uiView: CameraPreviewUIView, context: Context) {}
}

final class CameraPreviewUIView: UIView {
    var previewLayer: AVCaptureVideoPreviewLayer!

    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
    }
}
