import SwiftUI
import AVFoundation

// MARK: - Camera Preview + Barcode Detection + Photo Capture

final class BarcodeScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, AVCapturePhotoCaptureDelegate {

    var onDetect: ((String, CGPoint, CGSize) -> Void)?
    var onLost: (() -> Void)?
    var onPhotoCapture: ((Data) -> Void)?

    private let session = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var photoOutput = AVCapturePhotoOutput()
    private var lastDetectedCode: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        checkPermissionsAndSetup()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(capturePhoto),
            name: .captureScanPhoto,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
    }

    private func checkPermissionsAndSetup() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async { self?.setupSession() }
                }
            }
        default:
            break
        }
    }

    private func setupSession() {
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else { return }

        session.beginConfiguration()

        if session.canAddInput(input) {
            session.addInput(input)
        }

        let metadataOutput = AVCaptureMetadataOutput()
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
            metadataOutput.metadataObjectTypes = [
                .ean8, .ean13, .upce, .code128, .code39, .qr, .pdf417
            ]
        }

        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }

        session.commitConfiguration()

        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        layer.frame = view.bounds
        view.layer.addSublayer(layer)
        previewLayer = layer

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.startRunning()
        }
    }

    @objc private func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard let data = photo.fileDataRepresentation() else { return }
        DispatchQueue.main.async { [weak self] in
            self?.onPhotoCapture?(data)
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput,
                         didOutput metadataObjects: [AVMetadataObject],
                         from connection: AVCaptureConnection) {
        guard let previewLayer = previewLayer,
              let rawObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let stringValue = rawObject.stringValue,
              let transformed = previewLayer.transformedMetadataObject(for: rawObject) as? AVMetadataMachineReadableCodeObject
        else {
            if lastDetectedCode != nil {
                lastDetectedCode = nil
                onLost?()
            }
            return
        }

        let bounds = transformed.bounds
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let size = bounds.size

        if stringValue != lastDetectedCode {
            lastDetectedCode = stringValue
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }

        onDetect?(stringValue, center, size)
    }

    func stop() {
        session.stopRunning()
    }

    func start() {
        if !session.isRunning {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.session.startRunning()
            }
        }
    }
}

struct BarcodeScannerView: UIViewControllerRepresentable {
    var onDetect: (String, CGPoint, CGSize) -> Void
    var onLost: () -> Void
    var onPhotoCapture: ((Data) -> Void)?

    func makeUIViewController(context: Context) -> BarcodeScannerController {
        let controller = BarcodeScannerController()
        controller.onDetect = onDetect
        controller.onLost = onLost
        controller.onPhotoCapture = onPhotoCapture
        return controller
    }

    func updateUIViewController(_ uiViewController: BarcodeScannerController, context: Context) {}
}

extension Notification.Name {
    static let captureScanPhoto = Notification.Name("captureScanPhoto")
}
