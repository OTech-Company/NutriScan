//
//  Haptics.swift
//  NutriScan
//
//  Created by Osama Hosam on 18/07/2026.
//


import UIKit

/// Centralized haptic feedback so pickers, rulers, sliders, etc. all feel
/// consistent and don't each spin up their own generators.
///
/// `selectionChanged()` uses `UISelectionFeedbackGenerator` — the same
/// generator UIKit's own `UIPickerView` and `UIDatePicker` use when the
/// selected row changes. It's a very light "tick", which is the right
/// weight for scrolling past a value, as opposed to `impactOccurred()`
/// (heavier, meant for things like a button press or a drop landing).
enum Haptics {
    private static let selectionGenerator = UISelectionFeedbackGenerator()
    private static let lightImpactGenerator = UIImpactFeedbackGenerator(style: .light)

    /// Call when a value picker's selected value changes (ruler ticks,
    /// scroll-snap pickers, segmented steppers, etc).
    static func selectionChanged() {
        selectionGenerator.selectionChanged()
    }

    /// Slightly stronger tap — useful for discrete actions like a button
    /// press or reaching a range boundary (min/max clamp).
    static func lightImpact() {
        lightImpactGenerator.impactOccurred()
    }

    /// Call this right as a gesture begins (e.g. `DragGesture`'s first
    /// change, or `.onAppear` if you know interaction is imminent).
    /// "Warms up" the Taptic Engine so the first `selectionChanged()`
    /// call isn't delayed/muted — iOS docs recommend this for generators
    /// that fire repeatedly during a continuous gesture.
    static func prepareSelection() {
        selectionGenerator.prepare()
    }
}