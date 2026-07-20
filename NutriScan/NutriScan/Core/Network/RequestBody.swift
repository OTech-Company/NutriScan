//
//  RequestBody.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 20/07/2026.
//

import Foundation

enum RequestBody {
    case none
    case json(Encodable)
    case formURLEncoded([String: String])
    case multipart(MultipartFormData)
}
