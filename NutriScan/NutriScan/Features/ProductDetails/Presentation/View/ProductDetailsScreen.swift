//
//  ProductDetailsScreen.swift
//  NutriScan
//
//  Created by albaraa alsayed on 10/02/1448 AH.
//

import SwiftUI

struct ProductDetailsScreen: View {
    let scanId: String

    var body: some View {
        VStack(spacing: 0) {
            HStack{
                HStack(spacing: 16) {
                    BackButton {
                        
                    }
                    Text("Product Details")
                        .font(Font.AppFont.subtitle1)
                        .foregroundStyle(Color(red: 255, green: 255, blue: 255))
                }
                Spacer()
                Image(.bookmarkStroke)
                    .padding(8)
                    .background{
                            RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(Color.Teal.teal700)
                    }
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 16)
            
            ProductSheetView()
        }
        .background(Color.Teal.teal1000)
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

#Preview {
    ProductDetailsScreen(scanId: "preview-id")
}
