//
//  ValidatedField.swift
//  NutriScan
//

import Foundation

/// Bundles a text field's value, visual state, and error message into one
/// self-contained unit. Call `validate(using:)` to run any validator closure
/// and have `state` / `error` updated automatically.

struct ValidatedField {
    var value: String = ""
    var state: TextFieldState = .normal
    var error: String = ""

  
    @discardableResult
    mutating func validate(using validator: (String) -> String?) -> Bool {
        if let message = validator(value) {
            state = .error
            error = message
            return false
        }
        state = .success
        error = ""
        return true
    }
}
