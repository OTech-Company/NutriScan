//
//  FavoritesErrorView.swift
//  NutriScan
//

import SwiftUI

/// Full-screen error view shown when the initial load (page 0) fails
/// and there is no existing data to display.
struct FavoritesErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color(light: Color.Red.red100, dark: Color.Teal.teal1400))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "wifi.exclamationmark")
                    .font(.system(size: 32))
                    .foregroundColor(Color(light: Color.Red.red500, dark: Color.Red.red500))
            }
            
            Text("Something Went Wrong")
                .font(.AppFont.title3)
                .foregroundColor(Color(light: .Gray.gray900, dark: .Gray.gray100))
            
            Text(message)
                .font(.AppFont.textSecondary)
                .foregroundColor(Color(light: .Gray.gray600, dark: .Gray.gray300))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: onRetry) {
                Text("Try Again")
                    .font(.AppFont.textSecondary)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Color.Teal.teal1000)
                    .clipShape(Capsule())
            }
            .padding(.top, 8)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

/// Inline footer shown at the bottom of the grid when a pagination
/// request fails. Existing data remains visible above.


#Preview("Error View") {
    FavoritesErrorView(message: "Could not connect to the server. Please check your internet connection and try again.", onRetry: {})
}


