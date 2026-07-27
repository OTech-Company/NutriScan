//
//  ScanHistoryErrorView.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 27/07/2026.
//

import SwiftUI

struct ScanHistoryErrorView: View {
    let errorMessage: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color(light: .Gray.gray200, dark: .Teal.teal1400))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 32))
                    .foregroundColor(.orange)
            }
            
            Text("Something went wrong")
                .font(.AppFont.title3)
                .foregroundColor(Color(light: .Gray.gray900, dark: .Gray.gray100))
            
            Text(errorMessage)
                .font(.AppFont.textSecondary)
                .foregroundColor(Color(light: .Gray.gray600, dark: .Gray.gray300))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: onRetry) {
                Text("Retry")
                    .font(.AppFont.textDefault)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.Teal.teal1000)
                    .clipShape(Capsule())
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

//#Preview {
//    ScanHistoryErrorView()
//}
