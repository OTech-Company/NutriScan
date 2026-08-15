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
    var body: some View {
        VStack(spacing: 24) {
            Image(emptyState.image)
            
            VStack(spacing: 8){
                Text(emptyState.title)
                    .foregroundStyle(Color(light: Color.Gray.gray1600, dark: Color.Teal.teal500))
                    .font(Font.AppFont.title3)
                    .multilineTextAlignment(.center)
                
                Text(emptyState.description)
                    .font(Font.AppFont.textPrimary)
                    .foregroundStyle(Color(light: Color.Gray.gray600, dark: Color.Teal.teal1300))
                    .multilineTextAlignment(.center)
            }
            
            Button(action: action){
                Text((actionLabel ?? emptyState.actionLabel).uppercased())
                    .foregroundStyle(Color(light: Color.Teal.teal100, dark: Color.Teal.teal1600))
                    .font(Font.AppFont.textSecondary)
                    .padding(.horizontal, 32)
                    .frame(height: 44)
                
            }
            .background{
                RoundedRectangle(cornerRadius: 24)
                    .foregroundStyle(Color.Teal.teal1000)
                
            }
        }
        .padding(22)
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
