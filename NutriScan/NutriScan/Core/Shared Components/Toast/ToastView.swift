//
//  ToastView.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 20/07/2026.
//

import SwiftUI

struct ToastView: View {
    let toast: Toast
    var onDismiss: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: toast.style.iconName)
                .font(.title3)
                .foregroundColor(toast.style.themeColor)
            
            Text(toast.message)
                .font(Font.AppFont.subtitle2)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.separator), lineWidth: 0.5)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 16)
    }
}
