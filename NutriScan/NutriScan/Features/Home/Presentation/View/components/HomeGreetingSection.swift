//
//  HomeGreetingSection.swift
//  NutriScan
//
import SwiftUI

struct HomeGreetingSection: View {
    let userName: String
    let userImageURL: String?
    var onNotificationTap: () -> Void = {}

    var body: some View {
        HStack(spacing: 12) {

            // User Profile Image or Fallback Icon
            Group {
                if let urlString = userImageURL, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        default:
                            fallbackImageView
                        }
                    }
                } else {
                    fallbackImageView
                }
            }
            .frame(width: 48, height: 48)
            .clipShape(Circle())

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

    private var fallbackImageView: some View {
        Circle()
            .fill(Color.Teal.teal800)
            .overlay(
                Image(systemName: "person.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 22))
            )
    }
}

#Preview("Light") {
    HomeGreetingSection(userName: "Youssef", userImageURL: nil)
        .padding(20)
        .background(Color.Teal.teal100)
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    HomeGreetingSection(userName: "Youssef", userImageURL: nil)
        .padding(20)
        .background(Color.Teal.teal1600)
        .preferredColorScheme(.dark)
}
