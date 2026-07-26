//
//  NetworkLogger.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 26/07/2026.
//

import Foundation

enum NetworkLogger {
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
            if let jsonString = prettyPrintJSON(data: body) {
                print(jsonString)
            } else if let bodyString = String(data: body, encoding: .utf8) {
                print(bodyString)
            } else {
                print("   [\(body.count) bytes of binary data]")
            }
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
            if let jsonString = prettyPrintJSON(data: data) {
                print(jsonString)
            } else if let bodyString = String(data: data, encoding: .utf8) {
                print(bodyString)
            } else {
                print("   [\(data.count) bytes of data]")
            }
        }
        print("========================================================\n")
        #endif
    }

    static func log(error: Error, for request: URLRequest) {
        #if DEBUG
        print("\n================ 💥 REQUEST ERROR 💥 ================")
        if let method = request.httpMethod, let url = request.url {
            print("❌ [\(method)] \(url.absoluteString)")
        }
        print("🔴 Error: \(error.localizedDescription)")
        print("====================================================\n")
        #endif
    }

    private static func prettyPrintJSON(data: Data) -> String? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
              let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
              let prettyString = String(data: prettyData, encoding: .utf8) else {
            return nil
        }
        return prettyString
    }
}
