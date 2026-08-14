//
//  FavoriteCardView.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 25/07/2026.
//

import SwiftUI

struct FavoriteCardView: View {

    let favUIState: FavUIState
    var onRemove: (() -> Void)? = nil
    var onProductTap: (() -> Void)? = nil

    /// Called when the user completes a swipe. The closure receives a callback
    /// `onResult(_ success: Bool)` which the parent must invoke with the API result.
    var onAddToDaily: ((_ onResult: @escaping (Bool) -> Void) -> Void)? = nil



    var body: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .topTrailing) {
                Button(action: { onProductTap?() }) {
                    CachedImage(
                        urlString: favUIState.image,
                        failureImageName: "testImage",
                        contentMode: .fill
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 140)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(FavoriteProductButtonStyle())
                .accessibilityLabel("View details for \(favUIState.title)")
                .accessibilityHint("Opens Product Details")

                // Bookmark / Remove button — triggers parent to show confirmation alert
                Button(action: {
                    onRemove?()
                }) {
                    Image("bookmark-fill")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color.Teal.teal1000)
                        .padding(8)
                        .background(Color.white.opacity(0.85))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                }
                .padding(8)
                .accessibilityLabel("Remove \(favUIState.title) from saved products")
            }

            Button(action: { onProductTap?() }) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(favUIState.title)
                            .font(Font.AppFont.textSecondary)
                            .foregroundStyle(Color.Favorites.titleColor)
                            .lineLimit(1)

                        Text(favUIState.condition.rawValue)
                            .font(Font.AppFont.textCaption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .foregroundStyle(Color.Teal.teal100)
                            .background(
                                Capsule().foregroundStyle(
                                    favUIState.condition == Condition.Safe ? Color.Teal.teal1000 : Color.Yellow.yellow500
                                )
                            )
                    }

                    Spacer()

                    VStack(spacing: 0) {
                        Text(String(favUIState.calories))
                        Text("Kcal")
                    }
                    .font(Font.AppFont.textCaption)
                    .foregroundStyle(Color.Favorites.caloriesColor)
                    .padding(.vertical, 2)
                    .padding(.horizontal, 4)
                    .background(Color.Teal.teal300)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(FavoriteProductButtonStyle())
            .accessibilityLabel("\(favUIState.title), \(favUIState.condition.rawValue), \(favUIState.calories) calories")
            .accessibilityHint("Opens Product Details")

            SwipeToActionButton(
                actionTitle: "Swipe right to add",
                action: { onSliderResult in
                    if let onAddToDaily {
                        onAddToDaily { success in
                            onSliderResult(success)
                        }
                    } else {
                        onSliderResult(false)
                    }
                }
            )
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .background(Color.Favorites.cardColor)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .customLightShadow()
    }
}

private struct FavoriteProductButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle())
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.98 : 1)
            .opacity(configuration.isPressed ? 0.86 : 1)
            .animation(.easeOut(duration: 0.14), value: configuration.isPressed)
    }
}

#Preview {
    VStack {
        FavoriteCardView(
            favUIState: FavUIState(id: "1", image: "testImage", title: "Milk Product", calories: 180, condition: .Caution)
        )
    }
    .padding(.horizontal, 80)
}
