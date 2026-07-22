//
//  AuthRoute.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//


import SwiftUI

enum AuthRoute: Route {
    case register
    case forgotPassword
    case verificationPending(email: String)

    @ViewBuilder
    var destination: some View {
        switch self {
        case .register:
            RegisterView()
        case .forgotPassword:
            ForgotPasswordView()
        case .verificationPending(let email):
            VerificationPendingView(email: email)
        }
    }
}