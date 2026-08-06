//
//  ImageCompressor.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 06/08/2026.
//

import UIKit

struct ImageCompressor: ImageCompressing {
    let maxDimension: CGFloat
    let jpegQuality: CGFloat

    init(maxDimension: CGFloat = 1024, jpegQuality: CGFloat = 0.7) {
        self.maxDimension = maxDimension
        self.jpegQuality = jpegQuality
    }

    func compress(_ data: Data) -> Data {
        guard let image = UIImage(data: data) else { return data }

        let scale = min(1, maxDimension / max(image.size.width, image.size.height))
        let targetSize = CGSize(
            width: image.size.width * scale,
            height: image.size.height * scale
        )

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let resized = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }

        return resized.jpegData(compressionQuality: jpegQuality) ?? data
    }
}
