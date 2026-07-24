import Foundation

protocol ScanAPIServicing {
    func uploadScan(imageData: Data, filename: String) async throws -> String
    func fetchScanResult(scanId: String) async throws -> ScanResultDTO
    func fetchScanHistory(page: Int, size: Int) async throws -> ScanHistoryResponseDTO
    func observeScanResult(scanId: String) -> AsyncThrowingStream<ScanResultDTO, Error>
}

final class ScanAPIService: ScanAPIServicing {

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func uploadScan(imageData: Data, filename: String) async throws -> String {
        let endpoint = ScanEndpoint.uploadScan
        guard let url = endpoint.fullURL else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue

        if endpoint.requiresAuth,
           let accessToken = try? KeychainManager.shared.get(key: .accessToken),
           !accessToken.isEmpty {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        var form = MultipartFormData()
        form.files.append(
            MultipartFormData.FilePart(
                name: "image",
                filename: filename,
                mimeType: "image/jpeg",
                data: imageData
            )
        )
        request.httpBody = form.encode()
        request.setValue(form.contentTypeHeader, forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown(URLError(.badServerResponse))
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                throw NetworkError.apiError(apiError)
            }
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }

        let dto = try JSONDecoder().decode(ScanUploadResponseDTO.self, from: data)
        return dto.scanId
    }

    func fetchScanResult(scanId: String) async throws -> ScanResultDTO {
        let endpoint = ScanEndpoint.getScanResult(scanId: scanId)
        let dto: ScanResultDTO = try await networkService.request(endpoint)
        return dto
    }

    func fetchScanHistory(page: Int, size: Int) async throws -> ScanHistoryResponseDTO {
        let endpoint = ScanEndpoint.getScanHistory(page: page, size: size)
        let dto: ScanHistoryResponseDTO = try await networkService.request(endpoint)
        return dto
    }

    func observeScanResult(scanId: String) -> AsyncThrowingStream<ScanResultDTO, Error> {
        AsyncThrowingStream { continuation in
            let wsURLString = "wss://nutriscan.dev/api/v1/scans/\(scanId)/ws"
            guard let wsURL = URL(string: wsURLString) else {
                continuation.finish(throwing: NetworkError.invalidURL)
                return
            }

            let session = URLSession(configuration: .default)
            let task = session.webSocketTask(with: wsURL)

            var accessToken: String?
            if let token = try? KeychainManager.shared.get(key: .accessToken), !token.isEmpty {
                accessToken = token
            }

            let receiveTask = Task { @Sendable in
                do {
                    while !Task.isCancelled {
                        let message = try await task.receive()
                        switch message {
                        case .string(let text):
                            guard let data = text.data(using: .utf8) else { continue }
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .useDefaultKeys
                            let dateFormatter = ISO8601DateFormatter()
                            dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                            decoder.dateDecodingStrategy = .custom { decoder in
                                let container = try decoder.singleValueContainer()
                                let dateString = try container.decode(String.self)
                                if let date = dateFormatter.date(from: dateString) {
                                    return date
                                }
                                let fallbackFormatter = ISO8601DateFormatter()
                                fallbackFormatter.formatOptions = [.withInternetDateTime]
                                guard let date = fallbackFormatter.date(from: dateString) else {
                                    throw DecodingError.dataCorruptedError(
                                        in: container,
                                        debugDescription: "Invalid date format: \(dateString)"
                                    )
                                }
                                return date
                            }
                            if let dto = try? decoder.decode(ScanResultDTO.self, from: data) {
                                continuation.yield(dto)
                                if dto.status != "PROCESSING" {
                                    continuation.finish()
                                    task.cancel(with: .goingAway, reason: nil)
                                    return
                                }
                            }
                        case .data:
                            break
                        @unknown default:
                            break
                        }
                    }
                } catch {
                    continuation.finish(throwing: error)
                }
            }

            task.resume()

            Task {
                do {
                    try await Task.sleep(nanoseconds: 100_000_000)
                } catch {}

                if !Task.isCancelled {
                    task.resume()
                }
            }

            continuation.onTermination = { @Sendable _ in
                receiveTask.cancel()
                task.cancel(with: .goingAway, reason: nil)
            }
        }
    }
}
