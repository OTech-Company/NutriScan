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
            return "Full name is required"
        }
        if displayName.count < 3 || displayName.count > 20 {
            return "Full name must be between 3 and 20 characters"
        }
        return nil
    }

    static func firstNameValidator(_ name: String?) -> String? {
        guard let name = name, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return "First name is required"
        }
        if name.count < 2 || name.count > 50 {
            return "First name must be between 2 and 50 characters"
        }
        return nil
    }

    static func lastNameValidator(_ name: String?) -> String? {
        guard let name = name, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return "Last name is required"
        }
        if name.count < 2 || name.count > 50 {
            return "Last name must be between 2 and 50 characters"
        }
        return nil
    }

    static func validateMobile(_ value: String?) -> String? {
        guard let value = value, !value.isEmpty else {
            return "Mobile number is required"
        }
        if value.count != 11 {
            return "Mobile number must be 11 digits"
        }
        let pattern = #"^(010|011|012|015)\d{8}$"#
        let regexPredicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        if !regexPredicate.evaluate(with: value) {
            return "Invalid mobile number"
        }
        return nil
    }

    static func validateVerifyCode(_ value: String?) -> String? {
        guard let value = value, !value.isEmpty else {
            return "Verification code is required"
        }

        if value.count != 6 {
            return "Verification code must be 6 digits"
        }

        let pattern = #"^[0-9]{6}$"#
        let regexPredicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        if !regexPredicate.evaluate(with: value) {
            return "Invalid verification code"
        }

        return nil
    }

    static func passwordValidator(_ value: String?) -> String? {
        guard let value = value, !value.isEmpty else {
            return "Password is required"
        }
        if value.count < 8 {
            return "Password must be at least 8 characters"
        }
        return nil
    }

    static func repeatPasswordValidator(value: String?, password: String?) -> String? {
        if let validationError = passwordValidator(value) {
            return validationError
        }
        if value != password {
            return "Passwords do not match"
        }
        return nil
    }

    static func emailValidator(_ value: String?) -> String? {
        guard let value = value, !value.isEmpty else {
            return "Email is required"
        }
        let pattern = #"^(([^<>()\[\]\\.,;:\s@\"]+(\.[^<>()\[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$"#
        let regexPredicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        if !regexPredicate.evaluate(with: value) {
            return "Invalid email address"
        }
        return nil
    }

    static func validateRequiredTextField(_ value: String?) -> String? {
        guard let value = value, !value.isEmpty else {
            return "This field is required"
        }
        return nil
    }
    
    // MARK: - New Physical Measurement Validators
    
    static func heightValidator(_ value: String?) -> String? {
        guard let value = value, !value.isEmpty else {
            return "Height is required"
        }
        guard let h = Double(value), h >= 50, h <= 300 else {
            return "Invalid height"
        }
        return nil
    }
    
    static func weightValidator(_ value: String?) -> String? {
        guard let value = value, !value.isEmpty else {
            return "Weight is required"
        }
        guard let w = Double(value), w >= 20, w <= 500 else {
            return "Invalid weight"
        }
        return nil
    }
}
