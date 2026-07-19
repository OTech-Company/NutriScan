//
//  FlowChipsLayout.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 19/07/2026.
//

import SwiftUI

struct FlowChipsLayout: Layout {
    var horizontalSpacing: CGFloat = 8
    var verticalSpacing: CGFloat = 8

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        let rows = computeRows(maxWidth: maxWidth, subviews: subviews)

        let height = rows.reduce(CGFloat.zero) { partialHeight, row in
            partialHeight + row.maxHeight + (partialHeight > 0 ? verticalSpacing : 0)
        }

        let width = rows.map(\.width).max() ?? 0

        return CGSize(width: proposal.width ?? width, height: height)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        let rows = computeRows(maxWidth: bounds.width, subviews: subviews)

        var y = bounds.minY
        for row in rows {
            var x = bounds.minX
            for item in row.items {
                item.subview.place(
                    at: CGPoint(x: x, y: y),
                    proposal: ProposedViewSize(item.size)
                )
                x += item.size.width + horizontalSpacing
            }
            y += row.maxHeight + verticalSpacing
        }
    }

    // MARK: - Row computation

    private struct RowItem {
        let subview: LayoutSubview
        let size: CGSize
    }

    private struct Row {
        var items: [RowItem] = []
        var width: CGFloat = 0
        var maxHeight: CGFloat = 0
    }

    private func computeRows(maxWidth: CGFloat, subviews: Subviews) -> [Row] {
        var rows: [Row] = []
        var current = Row()

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            let projectedWidth = current.width + (current.items.isEmpty ? 0 : horizontalSpacing) + size.width

            if !current.items.isEmpty && projectedWidth > maxWidth {
                rows.append(current)
                current = Row()
            }

            current.items.append(RowItem(subview: subview, size: size))
            current.width += (current.items.count > 1 ? horizontalSpacing : 0) + size.width
            current.maxHeight = max(current.maxHeight, size.height)
        }

        if !current.items.isEmpty {
            rows.append(current)
        }

        return rows
    }
}

#Preview("Light") {
    FlowChipsLayout(horizontalSpacing: 8, verticalSpacing: 8) {
        SelectableChip(title: "Diabetes", state: .normal, action: {})
        SelectableChip(title: "Hypertension", state: .normal, action: {})
        SelectableChip(title: "Celiac Disease", state: .selected, action: {})
        SelectableChip(title: "Other", state: .add, action: {})
    }
    .padding()
    .background(Color.EditProfileSemantics.backgroundPrimary)
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    FlowChipsLayout(horizontalSpacing: 8, verticalSpacing: 8) {
        SelectableChip(title: "Peanuts", state: .normal, action: {})
        SelectableChip(title: "Gluten", state: .normal, action: {})
        SelectableChip(title: "Dairy", state: .normal, action: {})
        SelectableChip(title: "Other", state: .add, action: {})
    }
    .padding()
    .background(Color.EditProfileSemantics.backgroundPrimary)
    .preferredColorScheme(.dark)
}
