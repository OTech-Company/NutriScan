//
//  ToastManager.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 20/07/2026.
//

import SwiftUI
import Observation

@Observable
@MainActor
final class ToastManager {
    static let shared = ToastManager()
    
    var currentToast: Toast?
    private var dismissTask: Task<Void, Never>?
    
    private init() {}
    
    /// Shows a new toast and schedules auto-dismissal. 
    /// If another toast is currently displayed, it cancels the previous dismiss task to avoid premature disappearance.
    func show(_ toast: Toast, duration: TimeInterval = 2.5) {
        dismissTask?.cancel()
        currentToast = toast
        
        dismissTask = Task {
            try? await Task.sleep(for: .seconds(duration))
            guard !Task.isCancelled else { return }
            withAnimation(.spring()) {
                self.currentToast = nil
            }
        }
    }
    
    func dismiss() {
        dismissTask?.cancel()
        dismissTask = nil
        withAnimation(.spring()) {
            currentToast = nil
        }
    }
}
