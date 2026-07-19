//
//  BirthdateSelectionView.swift
//  NutriScan
//
//  Created by albaraa alsayed on 19/07/2026.
//

import SwiftUI

struct BirthdateSelectionView: View {
    @Binding var birthdate: Date
    @State private var isPickerPresented = false

    private var age: Int {
        Calendar.current.dateComponents([.year], from: birthdate, to: Date()).year ?? 0
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: birthdate)
    }

    var body: some View {
        VStack(spacing: 24) {
            HStack(spacing: 6) {
                Text("\(age)")
                    .font(Font.AppFont.title2)
                    .foregroundStyle(Color.Teal.teal1600)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.Teal.teal700)
                    )
                
                Text("Years")
                    .font(Font.AppFont.title2)
                    .foregroundStyle(Color.Teal.teal1600)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 72)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.Teal.teal500)
                    .frame(height: 95)
            )
            .customTealShadow()

            Button {
                isPickerPresented = true
            } label: {
                HStack {
                    Text(formattedDate)
                        .font(Font.AppFont.textPrimary)
                        .foregroundStyle(Color.ProfileSetupSemantic.calenderText)
                    Spacer()
                    Image(systemName: "calendar")
                        .foregroundStyle(Color.ProfileSetupSemantic.calenderText)
                }
                .padding(.horizontal, 16)
                .frame(height: 52)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.ProfileSetupSemantic.calenderBoarder, lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
        .sheet(isPresented: $isPickerPresented) {
            NavigationStack {
                DatePicker(
                    "Birthdate",
                    selection: $birthdate,
                    in: ...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding()
            }
            .presentationDetents([.height(320)])
        }
    }
}
