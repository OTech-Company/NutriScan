//
//  FavoriteCardView.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 25/07/2026.
//

import SwiftUI

struct FavoriteCardView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image("testImage")
                .resizable()
                .scaledToFill()
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Milk Product")
                        .font(Font.AppFont.textSecondary)
                        .foregroundStyle(Color.Favorites.titleColor)
                    
                    Text("Safe")
                        .font(Font.AppFont.textCaption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .foregroundStyle(Color.Teal.teal100)
                        .background(Capsule().foregroundStyle(Color.Teal.teal1000))
                }
                
                Spacer()
                
                VStack(spacing: 0) {
                    Text("180")
                    Text("Kcal")
                }
                .font(Font.AppFont.textCaption)
                .foregroundStyle(Color.Favorites.caloriesColor)
                .padding(.vertical, 2)
                .padding(.horizontal, 8)
                .background(Color.Teal.teal300)
                .clipShape(RoundedRectangle(cornerRadius: 4))
            }
            
            SwipeToActionButton(actionTitle: "Swipe right to add") {
                print("Product successfully added...")
            }
  
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .background(Color.Favorites.cardColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .customLightShadow()
        

    }
}

#Preview {
    VStack {
        FavoriteCardView()
    }
    .padding(.horizontal, 80)
}
