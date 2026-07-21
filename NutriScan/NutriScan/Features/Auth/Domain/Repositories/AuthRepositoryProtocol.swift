//
//  AuthRepositoryProtocol.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 19/07/2026.
//

import Foundation

protocol AuthRepositoryProtocol {
    func register(request: RegisterRequest) async throws -> RegisterResult
    func resendVerification(email: String) async throws -> ResendVerificationResult
    func login(request: LoginRequest) async throws -> LoginResult
    func forgotPassword(email: String) async throws -> ForgotPasswordResult
}
