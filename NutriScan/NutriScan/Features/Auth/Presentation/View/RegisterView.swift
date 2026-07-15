//
//  RegisterView.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//


import SwiftUI

struct RegisterView: View {
    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator
    @Environment(\.colorScheme) private var colorScheme

    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 16) {
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            Button("Create Account") {
                // On real success from your AuthUseCase:
                flowCoordinator.didAuthenticate()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Register")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(colorScheme == .light ? .white : Color.Teal.teal1600)
    }
}
