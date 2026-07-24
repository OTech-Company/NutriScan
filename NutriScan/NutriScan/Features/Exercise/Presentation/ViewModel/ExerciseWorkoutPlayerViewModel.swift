//
//  ExerciseWorkoutPlayerViewModel.swift
//  NutriScan
//

import Foundation
import Observation

@Observable
final class ExerciseWorkoutPlayerViewModel {
    let exercise: Exercise

    var elapsedSeconds: Int = 0
    var hasStarted: Bool = false
    var isPaused: Bool = true
    var setsCount: Int = 1
    var repsCount: Int = 1

    // MARK: - Alert & Dialog States
    var showCancelAlert: Bool = false
    var showRestartAlert: Bool = false
    var showSuccessDialog: Bool = false

    private var timerTask: Task<Void, Never>?

    init(exercise: Exercise) {
        self.exercise = exercise
        self.hasStarted = false
        self.isPaused = true
    }

    deinit {
        stopTimer()
    }

    // MARK: - Timer Logic

    func startWorkout() {
        hasStarted = true
        isPaused = false
        startTimer()
    }

    func startTimer() {
        isPaused = false
        stopTimer()
        timerTask = Task { @MainActor [weak self] in
            while !(Task.isCancelled) {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                guard let self = self, !self.isPaused else { continue }
                self.elapsedSeconds += 1
            }
        }
    }

    func pauseTimer() {
        isPaused = true
    }

    func resumeTimer() {
        isPaused = false
    }

    func togglePause() {
        if isPaused {
            resumeTimer()
        } else {
            pauseTimer()
        }
    }

    func restartTimer() {
        elapsedSeconds = 0
        hasStarted = true
        isPaused = false
        startTimer()
    }

    func stopTimer() {
        timerTask?.cancel()
        timerTask = nil
    }

    // MARK: - Formatted Time

    var formattedTime: String {
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    // MARK: - Calories Calculation

    /// Total burned calories: (sets * reps) * repKcal, or elapsed minutes * minKcal
    var totalCaloriesBurned: Double {
        let totalReps = Double(setsCount * repsCount)
        if let repKcal = exercise.repKcal {
            return totalReps * repKcal
        } else if let minKcal = exercise.minKcal {
            let minutes = Double(elapsedSeconds) / 60.0
            return minutes * minKcal
        }
        return 0.0
    }

    var formattedCalories: String {
        String(format: "%.1f", totalCaloriesBurned)
    }

    // MARK: - Stepper Counters

    func incrementSets() {
        setsCount += 1
    }

    func decrementSets() {
        if setsCount > 1 {
            setsCount -= 1
        }
    }

    func incrementReps() {
        repsCount += 1
    }

    func decrementReps() {
        if repsCount > 1 {
            repsCount -= 1
        }
    }
}
