//
//  HomeGreetingSection.swift
//  NutriScan
//
import SwiftUI

struct HomeGreetingSection: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let userName: String
    let userImageURL: String?
    var collapseProgress: CGFloat = 0
    var onProfileTap: () -> Void = {}
    var onNotificationTap: () -> Void = {}

    private var visualProgress: CGFloat {
        reduceMotion ? 0 : collapseProgress
    }

    private var avatarSize: CGFloat {
        48 - (12 * visualProgress)
    }

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onProfileTap) {
                HStack(spacing: 12) {
                    Group {
                        if let urlString = userImageURL, !urlString.isEmpty {
                            CachedImage(
                                urlString: urlString,
                                failureImageName: "person.fill",
                                contentMode: .fill
                            )
                        } else {
                            fallbackImageView
                        }
                    }
                    .frame(width: avatarSize, height: avatarSize)
                    .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Hello, \(userName)!")
                            .font(Font.AppFont.title3)
                            .foregroundColor(Color.HomeSemantic.greetingTitle)

                        Text(LocalizationKeys.Home.healthComesFirst.localized)
                            .font(Font.AppFont.textSecondary)
                            .foregroundColor(Color.HomeSemantic.greetingSubtitle)
                            .accessibilityIdentifier("home.greetingSubtitle")
                    }
                    .offset(y: reduceMotion ? 0 : 3 * visualProgress)
                }
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("home.profileButton")

            Spacer()

            Button {
                onNotificationTap()
            } label: {
                Image(systemName: "bell")
                    .font(.system(size: 22))
                    .foregroundColor(Color.HomeSemantic.greetingBell)
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel(LocalizationKeys.Notifications.notificationSettings.localized)
            .accessibilityIdentifier("home.notificationButton")
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
