//
//  PaginationRetryFooter.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 29/07/2026.
//

import SwiftUI

struct PaginationRetryFooter: View {
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Failed to load more")
                .font(.AppFont.textCaption)
                .foregroundColor(Color(light: .Gray.gray600, dark: .Gray.gray400))
            
            Button(action: onRetry) {
                Text("Tap to Retry")
                    .font(.AppFont.textCaption)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.Teal.teal1000)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }
}

#Preview("Pagination Footer") {
    PaginationRetryFooter(onRetry: {})
}
