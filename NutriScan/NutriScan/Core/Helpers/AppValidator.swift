//
//  AppValidator.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 15/07/2026.
//

import Foundation

struct AppValidator {
    
    static func displayNameValidator(_ displayName: String?) -> String? {
        guard let displayName = displayName, !displayName.isEmpty else {
            return LocalizationKeys.Validation.Name.fullRequired.localized
        }
        if displayName.count < 3 || displayName.count > 20 {
            return LocalizationKeys.Validation.Name.fullLength.localized
        }
        return nil
    }

    static func firstNameValidator(_ name: String?) -> String? {
        guard let name = name, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return LocalizationKeys.Validation.Name.firstRequired.localized
        }
        if name.count < 2 || name.count > 50 {
            return LocalizationKeys.Validation.Name.firstLength.localized
        }
        return nil
    }

    static func lastNameValidator(_ name: String?) -> String? {
        guard let name = name, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return LocalizationKeys.Validation.Name.lastRequired.localized
        }
        if name.count < 2 || name.count > 50 {
            return LocalizationKeys.Validation.Name.lastLength.localized
        }
        return nil
    }

    static func validateMobile(_ value: String?) -> String? {
        guard let value = value, !value.isEmpty else {
            return LocalizationKeys.Validation.Mobile.required.localized
        }
        if value.count != 11 {
            return LocalizationKeys.Validation.Mobile.length.localized
        }
        let pattern = #"^(010|011|012|015)\d{8}$"#
        let regexPredicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        if !regexPredicate.evaluate(with: value) {
            return LocalizationKeys.Validation.Mobile.invalid.localized
        }
        return nil
    }

    static func validateVerifyCode(_ value: String?) -> String? {
        guard let value = value, !value.isEmpty else {
            return LocalizationKeys.Validation.VerifyCode.required.localized
        }

        if value.count != 6 {
            return LocalizationKeys.Validation.VerifyCode.length.localized
        }

        let pattern = #"^[0-9]{6}$"#
        let regexPredicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        if !regexPredicate.evaluate(with: value) {
            return LocalizationKeys.Validation.VerifyCode.invalid.localized
        }

        return nil
    }

    static func passwordValidator(_ value: String?) -> String? {
        guard let value = value, !value.isEmpty else {
            return LocalizationKeys.Validation.Password.required.localized
        }
        if value.count < 8 {
            return LocalizationKeys.Validation.Password.minLength.localized
        }
        return nil
    }

    static func repeatPasswordValidator(value: String?, password: String?) -> String? {
        if let validationError = passwordValidator(value) {
            return validationError
        }
        if value != password {
            return LocalizationKeys.Validation.Password.mismatch.localized
        }
        return nil
    }

    static func emailValidator(_ value: String?) -> String? {
        guard let value = value, !value.isEmpty else {
            return LocalizationKeys.Validation.Email.required.localized
        }
        let pattern = #"^(([^<>()\[\]\\.,;:\s@\"]+(\.[^<>()\[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$"#
        let regexPredicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        if !regexPredicate.evaluate(with: value) {
            return LocalizationKeys.Validation.Email.invalid.localized
        }
        return nil
    }

    static func validateRequiredTextField(_ value: String?) -> String? {
        guard let value = value, !value.isEmpty else {
            return LocalizationKeys.Common.fieldRequired.localized
        }
        return nil
    }
    
    // MARK: - New Physical Measurement Validators
    
    static func heightValidator(_ value: String?) -> String? {
        guard let value = value, !value.isEmpty else {
            return LocalizationKeys.Validation.Height.required.localized
        }
        guard let h = Double(value), h >= 50, h <= 300 else {
            return LocalizationKeys.Validation.Height.invalid.localized
        }
        return nil
    }
    
    static func weightValidator(_ value: String?) -> String? {
        guard let value = value, !value.isEmpty else {
            return LocalizationKeys.Validation.Weight.required.localized
        }
        guard let w = Double(value), w >= 20, w <= 500 else {
            return LocalizationKeys.Validation.Weight.invalid.localized
        }
        return nil
    }
}
