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

    /// Called when the user completes a swipe. The closure receives a callback
    /// `onResult(_ success: Bool)` which the parent must invoke with the API result.
    var onAddToDaily: ((_ onResult: @escaping (Bool) -> Void) -> Void)? = nil

    // MARK: - Local State

    /// Controls the "Are you sure?" removal confirmation alert.
    @State private var showRemoveAlert = false

    /// When true, the SwipeToActionButton snaps back — used after an API failure.
    @State private var resetSwipe = false

    /// Controls the add-meal failure alert.
    @State private var showAddMealErrorAlert = false
    @State private var addMealErrorMessage = ""

    var body: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .topTrailing) {
                CachedImage(
                    urlString: favUIState.image,
                    failureImageName: "testImage",
                    contentMode: .fill
                )
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                // Bookmark / Remove button — shows confirmation alert before removing
                Button(action: {
                    showRemoveAlert = true
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
            }

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

            SwipeToActionButton(
                actionTitle: "Swipe right to add",
                action: {
                    onAddToDaily? { success in
                        if success {
                            // "Added!" is already showing inside SwipeToActionButton —
                            // it will auto-reset after 1.5s. Nothing more needed here.
                        } else {
                            // Force the slider back and show an error alert
                            resetSwipe = true
                            // Give onChange a moment to fire, then flip back so the
                            // binding is ready for the next swipe
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                resetSwipe = false
                            }
                            showAddMealErrorAlert = true
                        }
                    }
                },
                shouldReset: resetSwipe
            )
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .background(Color.Favorites.cardColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .customLightShadow()
        // MARK: - Remove Confirmation Alert
        .customAlert(
            isPresented: $showRemoveAlert,
            type: .delete,
            title: "Remove Product",
            description: "Are you sure you want to remove \"\(favUIState.title)\" from your favorites?",
            primaryButtonTitle: "Remove",
            primaryButtonColor: Color.Red.red500,
            primaryAction: {
                onRemove?()
            },
            secondaryButtonTitle: "Cancel",
            secondaryAction: { }
        )
        // MARK: - Add Meal Failure Alert
        .customAlert(
            isPresented: $showAddMealErrorAlert,
            type: .error,
            title: "Couldn't Add Meal",
            description: addMealErrorMessage.isEmpty
                ? "Something went wrong while adding this product to your daily meals. Please try again."
                : addMealErrorMessage,
            primaryButtonTitle: "Try Again",
            primaryAction: {
                // Re-trigger the swipe action
                onAddToDaily? { success in
                    if !success {
                        showAddMealErrorAlert = true
                    }
                }
            },
            secondaryButtonTitle: "Dismiss",
            secondaryAction: {
                addMealErrorMessage = ""
            }
        )
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
