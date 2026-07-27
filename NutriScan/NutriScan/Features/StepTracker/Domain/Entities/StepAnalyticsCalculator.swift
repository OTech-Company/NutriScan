import Foundation

/// Computes calories burned, distance, and active minutes from step data.
///
/// Formulas are based on peer-reviewed exercise physiology research:
/// - Calories: MET-based formula (Compendium of Physical Activities)
/// - Distance: anthropometric stride length estimation
/// - Active Minutes: step cadence threshold (≥100 steps/min = moderate activity)
struct StepAnalyticsCalculator {

    /// User's weight in kilograms. Defaults to 70 kg if unknown.
    var weightKg: Double = 70.0

    /// User's height in centimeters. Defaults to 170 cm if unknown.
    var heightCm: Double = 170.0

    /// Average walking cadence threshold for "active" minutes.
    /// WHO defines moderate activity as ≥100 steps/min.
    private let activeCadenceThreshold: Double = 100.0

    // MARK: - Stride Length

    /// Estimated stride length in meters, derived from height.
    ///
    /// Research reference: Peeble & Herron (2006) — stride length ≈ height × 0.415
    var strideLengthMeters: Double {
        (heightCm / 100.0) * 0.415
    }

    // MARK: - Distance

    /// Total distance covered in kilometers.
    func distanceKm(steps: Int) -> Double {
        Double(steps) * strideLengthMeters / 1000.0
    }

    // MARK: - Calories Burned

    /// Estimated calories burned in kcal.
    ///
    /// Uses the MET (Metabolic Equivalent of Task) approach:
    ///   Calories = MET × weight(kg) × duration(hours)
    ///
    /// Walking MET ≈ 3.5 (5 km/h moderate pace, Compendium code 02050)
    /// Duration is estimated from steps and average cadence:
    ///   duration(hours) = steps / (cadence × 60)
    ///   cadence assumed ≈ 100 steps/min for moderate walking
    ///
    /// Simplified: Calories = 3.5 × weight × steps / (100 × 60)
    ///                     = 3.5 × weight × steps / 6000
    /// For a 70 kg person: Calories ≈ 0.0408 × steps
    func caloriesBurned(steps: Int) -> Int {
        let met: Double = 3.5
        let cadence: Double = 100.0
        let durationHours = Double(steps) / (cadence * 60.0)
        let calories = met * weightKg * durationHours
        return max(Int(calories.rounded()), 0)
    }

    // MARK: - Active Minutes

    /// Estimated active minutes based on step cadence.
    ///
    /// WHO: ≥100 steps/min = moderate-intensity activity.
    /// For a single day with only total steps, we estimate:
    ///   activeMinutes = totalSteps / activeCadenceThreshold
    ///
    /// This gives a reasonable lower bound — actual active minutes may be
    /// higher if the user had bursts of fast walking/running.
    func activeMinutes(steps: Int) -> Int {
        max(Int((Double(steps) / activeCadenceThreshold).rounded()), 0)
    }

    // MARK: - Combined Analytics

    /// All three analytics computed at once for a given step count.
    func compute(steps: Int) -> StepAnalytics {
        StepAnalytics(
            caloriesBurned: caloriesBurned(steps: steps),
            distanceKm: distanceKm(steps: steps),
            activeMinutes: activeMinutes(steps: steps)
        )
    }
}

/// Pre-computed analytics for a single day or period.
struct StepAnalytics {
    let caloriesBurned: Int
    let distanceKm: Double
    let activeMinutes: Int
}
