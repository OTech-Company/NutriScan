//
//  DateSelectionField.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 21/07/2026.
//

import SwiftUI

struct DateSelectionField: View {
    @Binding var date: Date
    var dateRange: PartialRangeThrough<Date> = ...Date()

    @State private var isPickerPresented = false

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }

    var body: some View {
        Button {
            isPickerPresented = true
        } label: {
            HStack {
                Text(formattedDate)
                    .font(Font.AppFont.textPrimary)
                    .foregroundStyle(Color.DateSelectionFieldSemantics.calenderText)
                Spacer()
                Image(systemName: "calendar")
                    .foregroundStyle(Color.DateSelectionFieldSemantics.calenderText)
            }
            .padding(.horizontal, 16)
            .frame(height: 52)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.DateSelectionFieldSemantics.calenderBoarder, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $isPickerPresented) {
            NavigationStack {
                DatePicker(
                    "Birthdate",
                    selection: $date,
                    in: dateRange,
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
