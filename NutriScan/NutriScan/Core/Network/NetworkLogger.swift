//
//  NetworkLogger.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 26/07/2026.
//

import Foundation

enum NetworkLogger {
    /// Bodies larger than this are just summarized (size only) instead of
    /// JSON-pretty-printed and dumped to the console. Printing megabytes of
    /// text (e.g. a base64 image inside a multipart body) to the Xcode
    /// console is itself slow and can make requests *feel* slow even though
    /// the network call already finished.
    private static let maxLoggedBodySize = 20_000 // ~20 KB

    static func log(request: URLRequest) {
        #if DEBUG
        print("\n================ 🌐 OUTGOING REQUEST 🌐 ================")
        if let method = request.httpMethod, let url = request.url {
            print("➡️ [\(method)] \(url.absoluteString)")
        }

        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("📋 Headers:")
            for (key, value) in headers {
                if key.lowercased() == "authorization" {
                    let prefix = value.prefix(15)
                    print("   - \(key): \(prefix)...***")
                } else {
                    print("   - \(key): \(value)")
                }
            }
        }

        if let body = request.httpBody {
            print("📦 Body:")
            printBody(body)
        }
        print("========================================================\n")
        #endif
    }

    static func log(response: HTTPURLResponse, data: Data?, startTime: Date) {
        #if DEBUG
        let duration = String(format: "%.2f", Date().timeIntervalSince(startTime) * 1000)
        let statusCode = response.statusCode
        let icon = (200...299).contains(statusCode) ? "✅" : "❌"

        print("\n================ 📥 INCOMING RESPONSE 📥 ================")
        if let url = response.url {
            print("\(icon) [\(statusCode)] \(url.absoluteString) (\(duration) ms)")
        }

        if let data = data, !data.isEmpty {
            print("📦 Response Body:")
            printBody(data)
        }
        print("========================================================\n")
        #endif
    }

    static func log(error: Error, for request: URLRequest, startTime: Date) {
        #if DEBUG
        let duration = String(format: "%.2f", Date().timeIntervalSince(startTime) * 1000)
        print("\n================ 💥 REQUEST ERROR 💥 ================")
        if let method = request.httpMethod, let url = request.url {
            print("❌ [\(method)] \(url.absoluteString) (waited \(duration) ms)")
        }
        print("🔴 Error: \(error.localizedDescription)")
        print("====================================================\n")
        #endif
    }

    #if DEBUG
    /// Prints a body, but skips expensive pretty-printing/decoding and
    /// console spam for large payloads (images, big multipart bodies, etc.).
    private static func printBody(_ body: Data) {
        guard body.count <= maxLoggedBodySize else {
            print("   [\(body.count) bytes — skipped logging, too large]")
            return
        }

        if let jsonString = prettyPrintJSON(data: body) {
            print(jsonString)
        } else if let bodyString = String(data: body, encoding: .utf8) {
            print(bodyString)
        } else {
            print("   [\(body.count) bytes of binary data]")
        }
    }

    private static func prettyPrintJSON(data: Data) -> String? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
              let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
              let prettyString = String(data: prettyData, encoding: .utf8) else {
            return nil
        }
        return prettyString
    }
    #endif
}
