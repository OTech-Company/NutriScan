//
//  CachedAnimatedImage.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 24/07/2026.
//

import Foundation
import SwiftUI
import Kingfisher
import Shimmer

public struct CachedAnimatedImage: View {

    private let urlString: String?
    private let failureImageName: String
    private let contentMode: SwiftUI.ContentMode

    public init(
        urlString: String?,
        failureImageName: String,
        contentMode: SwiftUI.ContentMode = .fill
    ) {
        self.urlString = urlString
        self.failureImageName = failureImageName
        self.contentMode = contentMode
    }

    public var body: some View {
        if let urlString, let url = URL(string: urlString) {
            KFAnimatedImage(url)
                .configure { view in
                    view.framePreloadCount = 3
                    view.contentMode = contentMode == .fill ? .scaleAspectFill : .scaleAspectFit
                }
                .placeholder {
                    Rectangle()
                        .fill(Color.gray.opacity(0.15))
                        .redacted(reason: .placeholder)
                        .shimmering()
                }
                .onFailure { _ in }
                .cancelOnDisappear(true)
        } else {
            failureView
        }
    }

    private var failureView: some View {
        ZStack {
            Color.gray.opacity(0.1)
            Image(failureImageName)
                .resizable()
                .aspectRatio(contentMode: contentMode)
        }
    }
}
