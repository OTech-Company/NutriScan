//
//  LoginView.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//


import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator

    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 16) {
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            Button("Log In") {
                // On real success from your AuthUseCase:
                flowCoordinator.didAuthenticate()
            }
            .buttonStyle(.borderedProminent)

            Button("Create Account") {
                router.push(AuthRoute.register)
            }
        }
        .padding()
        .navigationTitle("Log In")
    }
}