//
//  ScanHistoryEmptyStateView.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 27/07/2026.
//

import SwiftUI

struct ScanHistoryEmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color(light: .Gray.gray200, dark: .Teal.teal1400))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 32))
                    .foregroundColor(Color(light: .Gray.gray600, dark: .Gray.gray400))
            }
            
            Text("No Scan History")
                .font(.AppFont.title3)
                .foregroundColor(Color(light: .Gray.gray900, dark: .Gray.gray100))
            
            Text("Your scanned products will appear here.")
                .font(.AppFont.textSecondary)
                .foregroundColor(Color(light: .Gray.gray600, dark: .Gray.gray300))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}


#Preview {
    ScanHistoryEmptyStateView()
}
