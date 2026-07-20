//
//  MultipartFormData.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 20/07/2026.
//

import Foundation

struct MultipartFormData {
    struct Field {
        let name: String
        let value: String
    }

    struct FilePart {
        let name: String
        let filename: String
        let mimeType: String
        let data: Data
    }

    let boundary = UUID().uuidString
    var fields: [Field] = []
    var files: [FilePart] = []

    var contentTypeHeader: String {
        "multipart/form-data; boundary=\(boundary)"
    }

    func encode() -> Data {
        var body = Data()

        for field in fields {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(field.name)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(field.value)\r\n".data(using: .utf8)!)
        }

        for file in files {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.filename)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(file.mimeType)\r\n\r\n".data(using: .utf8)!)
            body.append(file.data)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
}
