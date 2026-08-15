//
//  LocalizationKeys.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 15/08/2026.
//

import Foundation

struct LocalizationKeys {
    struct Common {
        static let back: String.LocalizationValue = "common.back"
        static let cancel: String.LocalizationValue = "common.cancel"
        static let continueAction: String.LocalizationValue = "common.continue"
        static let done: String.LocalizationValue = "common.done"
        static let error: String.LocalizationValue = "common.error"
        static let ok: String.LocalizationValue = "common.ok"
        static let retry: String.LocalizationValue = "common.retry"
        static let save: String.LocalizationValue = "common.save"
    }
    
    struct Auth {
        struct Login {
            static let title: String.LocalizationValue = "auth.login.title"
            static let emailTitle: String.LocalizationValue = "auth.login.email_title"
            static let emailPlaceholder: String.LocalizationValue = "auth.login.email_placeholder"
            static let passwordTitle: String.LocalizationValue = "auth.login.password_title"
            static let passwordPlaceholder: String.LocalizationValue = "auth.login.password_placeholder"
            static let forgotPassword: String.LocalizationValue = "auth.login.forgot_password"
            static let signIn: String.LocalizationValue = "auth.login.sign_in"
            static let noAccount: String.LocalizationValue = "auth.login.no_account"
            static let signUp: String.LocalizationValue = "auth.login.sign_up"
            static let or: String.LocalizationValue = "auth.login.or"
            static let failedTitle: String.LocalizationValue = "auth.login.failed_title"
            static let failedUnknown: String.LocalizationValue = "auth.login.failed_unknown"
            static let tryAgain: String.LocalizationValue = "auth.login.try_again"
        }
    }
    
    struct Validation {
        struct Email {
            static let required: String.LocalizationValue = "validation.email.required"
            static let invalid: String.LocalizationValue = "validation.email.invalid"
        }
        
        struct Password {
            static let required: String.LocalizationValue = "validation.password.required"
            static let minLength: String.LocalizationValue = "validation.password.min_length"
            static let mismatch: String.LocalizationValue = "validation.password.mismatch"
        }
    }
}

// MARK: - Convenience Extension
extension String.LocalizationValue {
    /// Resolves localized string using current AppLanguage
    var localized: String {
        AppLanguage.localized(self)
    }
}
