import SwiftUI
import AVFoundation

// MARK: - Camera Preview + Barcode Detection + Photo Capture

final class BarcodeScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, AVCapturePhotoCaptureDelegate {

    var onDetect: ((String, CGPoint, CGSize) -> Void)?
    var onPhotoCapture: ((Data) -> Void)?

    private let session = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var photoOutput = AVCapturePhotoOutput()
    private var lastDetectedCode: String?
    private var lastDetectionTime: Date = .distantPast

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
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let stringValue = object.stringValue,
              let previewLayer = previewLayer else { return }

        // Use Apple's built-in coordinate conversion — works correctly with .resizeAspectFill
        let center = previewLayer.layerPointConverted(fromMetadataOutputPoint: object.bounds.origin)
            .applying(CGAffineTransform(scaleX: 1, y: -1))
            .applying(CGAffineTransform(translationX: 0, y: previewLayer.bounds.height))

        // Calculate barcode size in view coordinates
        let topLeft = previewLayer.layerPointConverted(fromMetadataOutputPoint: object.bounds.origin)
        let bottomRight = previewLayer.layerPointConverted(
            fromMetadataOutputPoint: CGPoint(
                x: object.bounds.origin.x + object.bounds.width,
                y: object.bounds.origin.y + object.bounds.height
            )
        )
        let barcodeSize = CGSize(
            width: abs(bottomRight.x - topLeft.x),
            height: abs(bottomRight.y - topLeft.y)
        )

        let now = Date()
        let isFirstDetection = stringValue != lastDetectedCode || lastDetectedCode == nil

        if isFirstDetection {
            lastDetectedCode = stringValue
            lastDetectionTime = now

            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }

        // Always update position so the pill follows the barcode
        onDetect?(stringValue, center, barcodeSize)
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
    var onPhotoCapture: ((Data) -> Void)?

    func makeUIViewController(context: Context) -> BarcodeScannerController {
        let controller = BarcodeScannerController()
        controller.onDetect = onDetect
        controller.onPhotoCapture = onPhotoCapture
        return controller
    }

    func updateUIViewController(_ uiViewController: BarcodeScannerController, context: Context) {}
}

extension Notification.Name {
    static let captureScanPhoto = Notification.Name("captureScanPhoto")
}
