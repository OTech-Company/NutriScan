//
//  CaloriesHistoryStateViews.swift
//  NutriScan
//
//  Created by albaraa alsayed on 20/02/1448 AH.
//

import SwiftUI

struct CaloriesHistoryDateFilterSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDate: Date

    let onApply: (Date) -> Void

    init(initialDate: Date, onApply: @escaping (Date) -> Void) {
        _selectedDate = State(initialValue: initialDate)
        self.onApply = onApply
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                DatePicker(
                    "History date",
                    selection: $selectedDate,
                    in: ...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .tint(Color.Teal.teal1000)

                Button {
                    onApply(selectedDate)
                    dismiss()
                } label: {
                    Text("Apply Date")
                        .font(Font.AppFont.textDefault)
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.Teal.teal1000)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(.plain)
            }
            .padding(22)
            .navigationTitle("Filter by Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

struct CaloriesHistoryFilterChip: View {
    let label: String
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "calendar")
            Text(label)
                .lineLimit(1)
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Remove date filter")
        }
        .font(Font.AppFont.textSecondary)
        .foregroundStyle(Color.Teal.teal1000)
        .padding(.leading, 14)
        .padding(.trailing, 2)
        .frame(height: 44)
        .background(Color.CaloriesHistorySemantic.calendarButtonBackground)
        .clipShape(Capsule())
        .accessibilityElement(children: .contain)
    }
}

#Preview("Date Filter Sheet") {
    CaloriesHistoryDateFilterSheet(initialDate: Date()) { _ in }
}

#Preview("Filter Chip Light") {
    CaloriesHistoryFilterChip(label: "03-08-2026", onRemove: {})
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.CaloriesHistorySemantic.background)
        .preferredColorScheme(.light)
}

#Preview("Filter Chip Dark") {
    CaloriesHistoryFilterChip(label: "03-08-2026", onRemove: {})
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.CaloriesHistorySemantic.background)
        .preferredColorScheme(.dark)
}
