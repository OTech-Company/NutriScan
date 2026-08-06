//
//  ExerciseWorkoutPlayerViewModel.swift
//  NutriScan
//

import Foundation
import Observation

@Observable
@MainActor
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
    var showRecordingError: Bool = false
    private(set) var hasRecordedWorkout: Bool = false

    private var timerTask: Task<Void, Never>?
    private let caloriesActivityStore: CaloriesActivityStore
    private let profileStore: UserProfileStore
    private let notificationScheduler: SmartNotificationSchedulerProtocol

    init(
        exercise: Exercise,
        caloriesActivityStore: CaloriesActivityStore = DIContainer.shared.resolve(type: CaloriesActivityStore.self),
        profileStore: UserProfileStore = DIContainer.shared.resolve(type: UserProfileStore.self),
        notificationScheduler: SmartNotificationSchedulerProtocol = DIContainer.shared.resolve(type: SmartNotificationSchedulerProtocol.self)
    ) {
        self.exercise = exercise
        self.caloriesActivityStore = caloriesActivityStore
        self.profileStore = profileStore
        self.notificationScheduler = notificationScheduler
        self.hasStarted = false
        self.isPaused = true
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
        timerTask = Task { [weak self] in
            while !(Task.isCancelled) {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                guard let self else { return }
                guard !self.isPaused else { continue }
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

    var isCardio: Bool {
        exercise.category.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == "cardio"
    }

    var isCalorieEstimateAvailable: Bool {
        isCardio ? exercise.minKcal != nil : (exercise.repKcal != nil || exercise.minKcal != nil)
    }

    /// Cardio is time based. Other exercises prefer reps and fall back to time.
    var totalCaloriesBurned: Double {
        let minutes = Double(elapsedSeconds) / 60.0
        if isCardio {
            return minutes * (exercise.minKcal ?? 0)
        }

        let totalReps = Double(setsCount * repsCount)
        if let repKcal = exercise.repKcal {
            return totalReps * repKcal
        } else if let minKcal = exercise.minKcal {
            return minutes * minKcal
        }
        return 0.0
    }

    var formattedCalories: String {
        String(format: "%.1f", totalCaloriesBurned)
    }

    var roundedCalories: Int {
        max(Int(totalCaloriesBurned.rounded()), 0)
    }

    var completionDescription: String {
        let workoutDetails = isCardio
            ? "in \(formattedTime)"
            : "(\(setsCount) sets x \(repsCount) reps) in \(formattedTime)"
        let calorieDetails = isCalorieEstimateAvailable
            ? "and burned \(roundedCalories) kcal."
            : "Calorie estimation is unavailable for this exercise."
        return "Great job! You completed \(exercise.name) \(workoutDetails) \(calorieDetails)"
    }

    func finishWorkout() {
        guard !hasRecordedWorkout else {
            showSuccessDialog = true
            return
        }
        guard let profileID = profileStore.currentProfile?.id else {
            showRecordingError = true
            return
        }
        stopTimer()
        caloriesActivityStore.recordWorkout(
            profileID: profileID,
            date: CaloriesTracking.todayString,
            calories: Double(roundedCalories),
            elapsedSeconds: elapsedSeconds
        )
        hasRecordedWorkout = true
        showSuccessDialog = true

        Task {
            let nowComponents = Calendar.current.dateComponents([.hour, .minute], from: Date())
            let hour = nowComponents.hour ?? 0
            let minute = nowComponents.minute ?? 0
            let isBeforeWorkout = (hour < 20) || (hour == 20 && minute < 30)
            if isBeforeWorkout {
                await notificationScheduler.cancelWorkoutNudge()
            }
        }
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
