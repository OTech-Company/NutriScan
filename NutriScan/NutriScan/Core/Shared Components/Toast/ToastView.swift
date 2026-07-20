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
            // Icon in a soft colored badge instead of a bare SF Symbol —
            // gives more visual weight and reads faster at a glance.
            ZStack {
                Circle()
                    .fill(toast.style.badgeColor)
                    .frame(width: 32, height: 32)

                Image(systemName: toast.style.iconName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(toast.style.themeColor)
            }
            .fixedSize()

            Text(toast.message)
                .font(Font.AppFont.lexendDecaMedium16)
                .foregroundColor(Color.ToastSemantic.message)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 8)

            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color.ToastSemantic.closeIcon)
                    .frame(width: 22, height: 22)
                    .background(Color.ToastSemantic.closeBackground)
                    .clipShape(Circle())
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .padding(.leading, 14)
        .padding(.trailing, 12)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.ToastSemantic.background)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.ToastSemantic.border, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
        .shadow(color: toast.style.themeColor.opacity(0.06), radius: 16, x: 0, y: 8)
        .padding(.horizontal, 16)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        ToastView(
            toast: Toast(style: .success, message: "Your account has been created successfully."),
            onDismiss: {}
        )
        ToastView(
            toast: Toast(style: .error, message: "Something went wrong. Please try again."),
            onDismiss: {}
        )
        ToastView(
            toast: Toast(style: .info, message: "Your session will expire soon."),
            onDismiss: {}
        )
        ToastView(
            toast: Toast(style: .warning, message: "Weak password strength."),
            onDismiss: {}
        )
    }
    .padding()
    .background(Color(.secondarySystemBackground))
}
