//
//  ProductHeaderSection.swift
//  NutriScan
//
//  Created by albaraa alsayed on 10/02/1448 AH.
//

import SwiftUI

struct ProductHeaderSection: View {
    let state: ProductHeaderUIState
    
    var body: some View {
        VStack(spacing: 16) {
            CachedImage(
                urlString: state.imageUrl,
                failureImageName: "",
                contentMode: .fill
            )
            .frame(maxWidth: .infinity, minHeight: 192, maxHeight: 192)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay {
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(Color.Teal.teal1000, style: StrokeStyle(lineWidth: 3))
            }
            
            HStack(alignment: .bottom) {
                Text(state.productName)
                    .font(Font.AppFont.title1)
                    .foregroundStyle(Color(light: Color.Teal.teal1000, dark: Color.Teal.teal400))
                Spacer()
                VStack(alignment: .center, spacing: 0) {
                    Text("Scanned at")
                        .foregroundStyle(Color(light: Color.Gray.gray500, dark: Color.Teal.teal1300))
                        .font(Font.AppFont.textSecondary.weight(.bold))
                    Text(state.scannedAt)
                        .foregroundStyle(Color.Teal.teal800)
                        .font(Font.AppFont.textSecondary.weight(.bold))
                        .padding(.horizontal, 4)
                        .background {
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundStyle(Color.Teal.teal200)
                        }
                }
            }
        }
    }
}

#Preview {
    ProductHeaderSection(state: ProductDetailsUIState.mock.headerState)
        .padding()
}
