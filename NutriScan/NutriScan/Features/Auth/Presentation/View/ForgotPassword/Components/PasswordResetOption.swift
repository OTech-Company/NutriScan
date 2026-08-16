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
        case .email: return LocalizationKeys.Auth.ForgotPassword.optionEmailTitle.localized
        case .twoFactor: return LocalizationKeys.Auth.ForgotPassword.option2faTitle.localized
        case .googleAuth: return LocalizationKeys.Auth.ForgotPassword.optionGauthTitle.localized
        case .sms: return LocalizationKeys.Auth.ForgotPassword.optionSmsTitle.localized
        }
    }
    
    var subtitle: String {
        switch self {
        case .email: return LocalizationKeys.Auth.ForgotPassword.optionEmailDesc.localized
        case .twoFactor: return LocalizationKeys.Auth.ForgotPassword.option2faDesc.localized
        case .googleAuth: return LocalizationKeys.Auth.ForgotPassword.optionGauthDesc.localized
        case .sms: return LocalizationKeys.Auth.ForgotPassword.optionSmsDesc.localized
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
