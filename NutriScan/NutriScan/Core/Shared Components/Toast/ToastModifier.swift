//
//  ToastModifier.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 20/07/2026.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    private var toastManager = ToastManager.shared
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .top) {
                if let toast = toastManager.currentToast {
                    ToastView(toast: toast) {
                        toastManager.dismiss()
                    }
                    .padding(.top, 16)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .gesture(
                        DragGesture(minimumDistance: 10, coordinateSpace: .local)
                            .onEnded { value in
                                if value.translation.height < -15 {
                                    toastManager.dismiss()
                                }
                            }
                    )
                }
            }
            .animation(.spring(), value: toastManager.currentToast)
    }
}

extension View {
    func toastable() -> some View {
        self.modifier(ToastModifier())
    }
}
