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
    var isPaused: Bool = false
    var setsCount: Int = 1
    var repsCount: Int = 1

    // MARK: - Alert & Dialog States
    var showCancelAlert: Bool = false
    var showRestartAlert: Bool = false
    var showSuccessDialog: Bool = false

    private var timerTask: Task<Void, Never>?

    init(exercise: Exercise) {
        self.exercise = exercise
        startTimer()
    }

    deinit {
        stopTimer()
    }

    // MARK: - Timer Logic

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
        isPaused = false
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
