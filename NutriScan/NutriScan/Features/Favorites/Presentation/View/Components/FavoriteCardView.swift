//
//  FavoriteCardView.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 25/07/2026.
//

import SwiftUI

struct FavoriteCardView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("testImage")
                .resizable()
                .scaledToFill()
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Milk Product")
                        .font(Font.AppFont.title3)
                        .foregroundStyle(Color.Teal.teal1400)
                    
                    Text("Safe")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 2)
                        .foregroundStyle(.white)
                        .background(Capsule().foregroundStyle(Color.Teal.teal1400))
                }
                
                Spacer()
                
                VStack(spacing: 0) {
                    Text("180")
                    Text("Kcal")
                }
                .foregroundStyle(Color.Teal.teal800)
                .padding(.vertical, 2)
                .padding(.horizontal, 8)
                .background(Color.Teal.teal200)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            SwipeToActionButton(actionTitle: "Swipe right to add") {
                print("Product successfully added...")
            }
  
        }
        .frame(height: 360)
        .padding(.vertical, 12)
        .padding(.horizontal, 12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .customTealShadow()
        

    }
}

#Preview {
    VStack {
        FavoriteCardView()
    }
    .padding(.horizontal, 80)
}
