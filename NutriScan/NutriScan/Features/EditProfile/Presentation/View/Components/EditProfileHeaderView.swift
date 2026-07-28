//
//  ProfileHeaderView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 19/07/2026.
//
import SwiftUI
import PhotosUI

struct EditProfileHeaderView: View {
    let name: String
    let email: String
    var avatarURL: String? = AppConstants.defaultUserAvatarURL
    var customImage: UIImage? = nil // Added to display locally picked image instantly
    var isEditing: Bool = false     // Controls whether picking is enabled
    @Binding var selectedItem: PhotosPickerItem? // Binding to the picker item

    var body: some View {
        HStack(spacing: EditProfileSemantics.Spacing.headerRowSpacing) {
            // Wrap the avatar stack in a PhotosPicker if editing is active
            Group {
                if isEditing {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        avatarContainerView
                    }
                    .buttonStyle(.plain)
                } else {
                    avatarContainerView
                }
            }

            VStack(
                alignment: .leading,
                spacing: EditProfileSemantics.Spacing.headerNameSpacing
            ) {
                Text(name)
                    .font(Font.AppFont.title2)
                    .foregroundColor(Color.EditProfileSemantics.profileName)
                Text(email)
                    .font(Font.AppFont.textSecondary)
                    .foregroundColor(Color.EditProfileSemantics.profileEmail)
            }
        }
    }

    private var avatarContainerView: some View {
        ZStack(alignment: .topTrailing) {
            ZStack {
                Circle()
                    .stroke(
                        Color.EditProfileSemantics.avatarBorder,
                        lineWidth: 2
                    )
                    .frame(
                        width: EditProfileSemantics.Sizes.outerAvatarDiameter,
                        height: EditProfileSemantics.Sizes.outerAvatarDiameter
                    )

                // Show local picked image if available, otherwise fall back to URL string
                if let uiImage = customImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: EditProfileSemantics.Sizes.avatarDiameter,
                            height: EditProfileSemantics.Sizes.avatarDiameter
                        )
                        .clipShape(Circle())
                } else {
                    CachedImage(
                        urlString: avatarURL ?? AppConstants.defaultUserAvatarURL,
                        failureImageName: "person.circle.fill",
                        contentMode: .fill
                    )
                    .frame(
                        width: EditProfileSemantics.Sizes.avatarDiameter,
                        height: EditProfileSemantics.Sizes.avatarDiameter
                    )
                    .clipShape(Circle())
                }
            }

            // Pencil badge overlay
            ZStack {
                Circle()
                    .fill(Color.white)
                    .stroke(Color.white, lineWidth: 2)
                    .frame(
                        width: EditProfileSemantics.Sizes.outerEditBadgeDiameter,
                        height: EditProfileSemantics.Sizes.outerEditBadgeDiameter
                    )

                Image(systemName: "pencil")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(
                        Color.EditProfileSemantics.editBadgeIcon
                    )
                    .frame(
                        width: EditProfileSemantics.Sizes.editBadgeDiameter,
                        height: EditProfileSemantics.Sizes.editBadgeDiameter
                    )
                    .background(
                        Circle().fill(
                            Color.EditProfileSemantics.editBadgeBackground))
            }
            .offset(x: 4, y: -4)
        }
    }
}
