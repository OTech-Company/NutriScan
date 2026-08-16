//
//  CustomAlertModifiers.swift
//  NutriScan
//
//  Created by albaraa alsayed on 23/07/2026.
//

import SwiftUI

struct CustomAlertPresentationState<Item: Identifiable> where Item.ID: Equatable {
    private(set) var presentedItem: Item?
    private(set) var pendingItem: Item?
    private(set) var isVisible = false

    mutating func synchronize(with sourceItem: Item?) {
        guard let sourceItem else {
            pendingItem = nil
            if presentedItem != nil {
                isVisible = false
            }
            return
        }

        guard let presentedItem else {
            present(sourceItem)
            return
        }

        guard presentedItem.id != sourceItem.id else { return }
        pendingItem = sourceItem
        isVisible = false
    }

    mutating func present(_ item: Item) {
        presentedItem = item
        isVisible = true
    }

    mutating func beginDismissal(of selectedItem: Item) {
        guard presentedItem?.id == selectedItem.id else { return }
        isVisible = false
    }

    mutating func finishDismissal(sourceItem: Item?) -> Item? {
        presentedItem = nil
        isVisible = false
        defer { pendingItem = nil }
        return pendingItem ?? sourceItem
    }
}

private struct CustomAlertModifier<Item: Identifiable>: ViewModifier where Item.ID: Equatable {
    @Binding var item: Item?

    let config: (Item) -> CustomAlertConfig
    let primaryAction: (Item) -> Void
    let secondaryAction: ((Item) -> Void)?

    @State private var presentation = CustomAlertPresentationState<Item>()

    func body(content: Content) -> some View {
        ZStack {
            content
                .allowsHitTesting(presentation.presentedItem == nil)
                .accessibilityHidden(presentation.presentedItem != nil)

            if let presentedItem = presentation.presentedItem {
                let resolvedConfig = config(presentedItem)

                CustomAlert(
                    config: resolvedConfig,
                    isPresented: presentation.isVisible,
                    primaryAction: {
                        beginDismissal(of: presentedItem)
                        primaryAction(presentedItem)
                    },
                    secondaryAction: resolvedConfig.secondaryButton == nil
                        ? nil
                        : secondaryAction.map { action in
                            {
                                beginDismissal(of: presentedItem)
                                action(presentedItem)
                            }
                        },
                    onDismissed: finishDismissal
                )
                .zIndex(100)
            }
        }
        .onAppear {
            if let item {
                presentation.present(item)
            }
        }
        .onChange(of: item?.id) { _, _ in
            synchronizePresentation()
        }
    }

    private func synchronizePresentation() {
        presentation.synchronize(with: item)
    }

    private func beginDismissal(of selectedItem: Item) {
        if item?.id == selectedItem.id {
            item = nil
        }
        presentation.beginDismissal(of: selectedItem)
    }

    private func finishDismissal() {
        if let nextItem = presentation.finishDismissal(sourceItem: item) {
            DispatchQueue.main.async {
                presentation.present(nextItem)
            }
        }
    }
}

extension View {
    /// Presents one custom alert destination at a time and queues replacements until dismissal completes.
    func customAlert<Item: Identifiable>(
        item: Binding<Item?>,
        config: @escaping (Item) -> CustomAlertConfig,
        primaryAction: @escaping (Item) -> Void,
        secondaryAction: ((Item) -> Void)? = nil
    ) -> some View where Item.ID: Equatable {
        modifier(
            CustomAlertModifier(
                item: item,
                config: config,
                primaryAction: primaryAction,
                secondaryAction: secondaryAction
            )
        )
    }
}
