//
//  HomeGreetingSection.swift
//  NutriScan
//

import SwiftUI

struct HomeGreetingSection: View {
    let userName: String
    var onNotificationTap: () -> Void = {}

    var body: some View {
        HStack(spacing: 12) {

            Circle()
                .fill(Color.Teal.teal800)
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 22))
                )

            VStack(alignment: .leading, spacing: 2) {
                Text("Hello, \(userName)!")
                    .font(Font.AppFont.title3)
                    .foregroundColor(Color.HomeSemantic.greetingTitle)

                Text("Your Health Comes First")
                    .font(Font.AppFont.textSecondary)
                    .foregroundColor(Color.HomeSemantic.greetingSubtitle)
            }

            Spacer()

            Button(action: onNotificationTap) {
                Image(systemName: "bell")
                    .font(.system(size: 22))
                    .foregroundColor(Color.HomeSemantic.greetingBell)
            }
        }
    }
}

#Preview("Light") {
    HomeGreetingSection(userName: "Youssef")
        .padding(20)
        .background(Color.Teal.teal100)
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    HomeGreetingSection(userName: "Youssef")
        .padding(20)
        .background(Color.Teal.teal1600)
        .preferredColorScheme(.dark)
}
