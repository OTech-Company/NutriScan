//
//  PasswordResetOption.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 16/07/2026.
//

import Foundation

enum PasswordResetOption: String, CaseIterable, Identifiable {
    case email = "Email"
    case twoFactor = "2FA"
    case googleAuth = "Google Auth"
    case sms = "SMS"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .email: return "Send via Email"
        case .twoFactor: return "Send via 2FA"
        case .googleAuth: return "Send via Google Auth"
        case .sms: return "Send via SMS"
        }
    }
    
    var subtitle: String {
        switch self {
        case .email: return "Reset password via email."
        case .twoFactor: return "Reset password via 2FA."
        case .googleAuth: return "Reset password via G-Auth."
        case .sms: return "Reset password via SMS."
        }
    }
    
    var iconName: String {
        switch self {
        case .email: return "email_icon"
        case .twoFactor: return "password_icon"
        case .googleAuth: return "google_auth_icon"
        case .sms: return "send_sms_icon"
        }
    }
}
