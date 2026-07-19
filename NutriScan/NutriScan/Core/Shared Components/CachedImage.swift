//
//  CachedImage.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 16/07/2026.
//

import Foundation
import SwiftUI
import Kingfisher
import Shimmer

public struct CachedImage: View {
    
    private let urlString: String?
    private let failureImageName: String
    private let contentMode: SwiftUI.ContentMode
    private let failurePadding: CGFloat

    public init(
        urlString: String?,
        failureImageName: String,
        contentMode: SwiftUI.ContentMode = .fill,
        failurePadding: CGFloat = 0
    ) {
        self.urlString = urlString
        self.failureImageName = failureImageName
        self.contentMode = contentMode
        self.failurePadding = failurePadding
    }

    public var body: some View {
        if let urlString, let url = URL(string: urlString) {
            KFImage(url)
                .placeholder {
                    shimmerPlaceholder
                }
                .onFailureView {
                    failureView
                }
                .resizable()
                .aspectRatio(contentMode: contentMode)
        } else {
            failureView
        }
    }

    private var shimmerPlaceholder: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.15))
            .redacted(reason: .placeholder)
            .shimmering()
    }

    private var failureView: some View {
        ZStack {
            Color.gray.opacity(0.1)
            Image(failureImageName)
                .resizable()
                .aspectRatio(contentMode: contentMode)
                .padding(failurePadding)
        }
    }
}
