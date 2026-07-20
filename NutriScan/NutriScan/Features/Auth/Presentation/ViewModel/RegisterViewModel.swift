//
//  RegisterViewModel.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 15/07/2026.
//

import Foundation
import Observation

enum RegisterField: String {
    case firstName
    case lastName
    case email
    case username
    case password
    case confirmPassword
}

@Observable
final class RegisterViewModel {

    // MARK: - Fields
    var firstName       = ValidatedField()
    var lastName        = ValidatedField()
    var email           = ValidatedField()
    var password        = ValidatedField()
    var confirmPassword = ValidatedField()

    // MARK: - Status
    var isLoading: Bool = false
    var generalError: String? = nil

    // MARK: - UseCase
    private let registerUseCase: RegisterUseCase

    init(registerUseCase: RegisterUseCase = RegisterUseCase()) {
        self.registerUseCase = registerUseCase
    }

    // MARK: - Field Validation

    func validate(field: RegisterField) {
        switch field {
        case .firstName:
            firstName.validate(using: AppValidator.firstNameValidator)
        case .lastName:
            lastName.validate(using: AppValidator.lastNameValidator)
        case .email:
            email.validate(using: AppValidator.emailValidator)
        case .password:
            password.validate(using: AppValidator.passwordValidator)
            if !confirmPassword.value.isEmpty {
                validate(field: .confirmPassword)
            }
        case .confirmPassword:
            confirmPassword.validate {
                AppValidator.repeatPasswordValidator(value: $0, password: password.value)
            }
        case .username:
            break
        }
    }

    // MARK: - Full validation (used by signUp)
    @discardableResult
    func validateAll() -> Bool {
        validate(field: .firstName)
        validate(field: .lastName)
        validate(field: .email)
        validate(field: .password)
        validate(field: .confirmPassword)
        
        return firstName.state == .success
            && lastName.state == .success
            && email.state == .success
            && password.state == .success
            && confirmPassword.state == .success
    }


    func signUp() async -> Bool {

        guard validateAll() else { return false }
        
        isLoading = true
        generalError = nil
        
        defer { isLoading = false }
        
        let request = RegisterRequest(
            firstName: firstName.value,
            lastName: lastName.value,
            email: email.value,
            username: email.value,
            password: password.value
        )
        
        do {
            let result = try await registerUseCase.execute(request: request)
            return true
        } catch let error as NetworkError {
            switch error {
            case .apiError(let apiError):
                handleAPIError(apiError)
            default:
                generalError = error.localizedDescription
            }
            return false
        } catch {
            generalError = error.localizedDescription
            return false
        }
    }

    private func setError(_ message: String, for field: RegisterField) {
        switch field {
        case .firstName:
            firstName.state = .error
            firstName.error = message
        case .lastName:
            lastName.state = .error
            lastName.error = message
        case .email, .username:
            email.state = .error
            email.error = message
        case .password:
            password.state = .error
            password.error = message
        case .confirmPassword:
            confirmPassword.state = .error
            confirmPassword.error = message
        }
    }

    private func handleAPIError(_ apiError: APIErrorResponse) {
        guard let details = apiError.details, !details.isEmpty else {
            generalError = apiError.message ?? "Validation failed"
            return
        }
        
        for detail in details {
            if let field = RegisterField(rawValue: detail.field) {
                setError(detail.issue, for: field)
            } else {
                generalError = detail.issue
            }
        }
    }
}
