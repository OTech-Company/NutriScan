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
            .frame(width: 48, height: 48)
            .clipShape(Circle()) // Ensures the CachedImage remains perfectly round

            VStack(alignment: .leading, spacing: 2) {
                Text("Hello, \(userName)!")
                    .font(Font.AppFont.title3)
                    .foregroundColor(Color.HomeSemantic.greetingTitle)

                Text("Your Health Comes First")
                    .font(Font.AppFont.textSecondary)
                    .foregroundColor(Color.HomeSemantic.greetingSubtitle)
            }

            Spacer()

            Button {
                Task {
                    let service = DIContainer.shared.resolve(type: NotificationServiceProtocol.self)
                    
                    let granted = await service.requestAuthorizationIfNeeded()
                    guard granted else {
                        print("⚠️ الإذن مرفوض — روح Settings وفعّل الإشعارات لهذا التطبيق")
                        return
                    }
                    
                    do {
                        try await service.schedule(AppNotification.streakReminder)
                        print("✅ الإشعار اتجدول بنجاح")
                    } catch {
                        print("❌ فشل الجدولة: \(error)")
                    }
                }
            } label: {
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
