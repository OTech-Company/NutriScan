//
//  EmptyStateView.swift
//  NutriScan
//
//  Created by albaraa alsayed on 17/02/1448 AH.
//

import SwiftUI

struct EmptyStateView: View {
    let emptyState: EmptyState
    let action: () -> Void
    var actionLabel: String? = nil
    var isCompact: Bool = false

    var body: some View {
        VStack(spacing: isCompact ? 12 : 24) {
            if isCompact {
                Image(emptyState.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100 ,height: 100)
            } else {
                Image(emptyState.image)
            }
            
            VStack(spacing: isCompact ? 4 : 8) {
                Text(emptyState.title)
                    .foregroundStyle(Color(light: Color.Gray.gray1600, dark: Color.Teal.teal500))
                    .font(isCompact ? Font.AppFont.textSecondary : Font.AppFont.title3)
                    .fontWeight(isCompact ? .bold : .semibold)
                    .multilineTextAlignment(.center)
                
                Text(emptyState.description)
                    .font(isCompact ? Font.AppFont.textCaption : Font.AppFont.textPrimary)
                    .foregroundStyle(Color(light: Color.Gray.gray600, dark: Color.Teal.teal1300))
                    .multilineTextAlignment(.center)
            }
            
            let resolvedLabel = (actionLabel ?? emptyState.actionLabel).trimmingCharacters(in: .whitespaces)
            if !resolvedLabel.isEmpty {
                Button(action: action) {
                    Text(resolvedLabel.uppercased())
                        .foregroundStyle(Color(light: Color.Teal.teal100, dark: Color.Teal.teal1600))
                        .font(isCompact ? Font.AppFont.textCaption : Font.AppFont.textSecondary)
                        .padding(.horizontal, isCompact ? 20 : 32)
                        .frame(height: isCompact ? 36 : 44)
                }
                .background {
                    RoundedRectangle(cornerRadius: isCompact ? 18 : 24)
                        .foregroundStyle(Color.Teal.teal1000)
                }
            }
        }
        .padding(isCompact ? 12 : 22)
    }
}

#Preview("error 404") {
    ZStack{
        Color(light: .white, dark: Color.Teal.teal1600)
        EmptyStateView(emptyState: .error404){
        }
    }
    .ignoresSafeArea()
}

#Preview("no connection") {
    ZStack{
        Color(light: .white, dark: Color.Teal.teal1600)
        EmptyStateView(emptyState: .noConnection){
        }
    }
    .ignoresSafeArea()
}

#Preview("No Saved"){
    ZStack{
        Color(light: .white, dark: Color.Teal.teal1600)
        EmptyStateView(emptyState: .noSaved){
        }
    }
    .ignoresSafeArea()
}

#Preview("no notification") {
    ZStack{
        Color(light: .white, dark: Color.Teal.teal1600)
        EmptyStateView(emptyState: .noNotifications){
        }
    }
    .ignoresSafeArea()
}

#Preview("no notification permission") {
    ZStack{
        Color(light: .white, dark: Color.Teal.teal1600)
        EmptyStateView(emptyState: .noNotificationPermission){
        }
    }
    .ignoresSafeArea()
}

#Preview("no scans") {
    ZStack{
        Color(light: .white, dark: Color.Teal.teal1600)
        EmptyStateView(emptyState: .noScans){
        }
    }
    .ignoresSafeArea()
}

#Preview("no search results") {
    ZStack{
        Color(light: .white, dark: Color.Teal.teal1600)
        EmptyStateView(emptyState: .noSearchResults){
        }
    }
    .ignoresSafeArea()
}
