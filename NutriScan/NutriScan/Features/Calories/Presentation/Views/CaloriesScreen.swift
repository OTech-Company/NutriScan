//
//  CaloriesScreen.swift
//  NutriScan
//
//  Created by albaraa alsayed on 09/02/1448 AH.
//

import SwiftUI

struct CaloriesScreen: View {
    private enum AlertDestination: String, Identifiable {
        case healthAccess
        case loadingError
        case mealRemoval
        case waterRemoval
        case targetCupRemoval
        var id: String { rawValue }
    }

    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator
    @State private var caloriesViewModel = CaloriesFactory.makeCaloriesViewModel()
    @State private var stepViewModel: StepCounterViewModel

    @State private var showDailyProducts = false
    @State private var showCalorieGoals = false
    @State private var showStepsAndExercise = false
    @State private var showWater = false

    @State private var alert: AlertDestination?

    @State private var mealRemovalRequest: MealRemovalRequest? = nil
    @State private var unfillCupIndex: Int? = nil
    @State private var stepPersistenceTask: Task<Void, Never>?

    init() {
        let stepViewModel = StepCounterViewModel(
            observeStepsUseCase: DIContainer.shared.resolve(type: ObserveDailyStepsUseCase.self),
            requestAuthUseCase: DIContainer.shared.resolve(type: RequestStepAuthorizationUseCase.self),
            fetchHistoryUseCase: DIContainer.shared.resolve(type: FetchStepsHistoryUseCase.self)
        )
        _stepViewModel = State(initialValue: stepViewModel)
    }

    init(stepViewModel: StepCounterViewModel) {
        _stepViewModel = State(initialValue: stepViewModel)
    }

    var body: some View {
        ZStack {
            TopSafeAreaScrollView(
                background: Color.CaloriesSemantic.background,
                refreshAction: {
                    await handleActivation()
                },
                topBar: { _ in
                    DailyProductsHeader(
                        dailyKcal: caloriesViewModel.dailyKcal,
                        isLoading: caloriesViewModel.isInitialLoading
                    )
                        .padding(.horizontal, 22)
                        .frame(height: 60)
                        .accessibilityIdentifier("calories.topBar")
                }
                ) {
                    VStack(spacing: 0) {
                        VStack(spacing: 24) {

                        DailyProductsSection(
                            dailyKcal: caloriesViewModel.dailyKcal,
                            meals: caloriesViewModel.meals,
                            mutatingMealIDs: caloriesViewModel.mutatingMealIDs,
                            isLoading: caloriesViewModel.isInitialLoading,
                            showsHeader: false,
                            onAddFoodTap: {
                                flowCoordinator.selectedTab = .bookmark
                            },
                            onRemoveMealRequest: { request in
                                mealRemovalRequest = request
                                alert = .mealRemoval
                            }
                        )
                        .opacity(showDailyProducts ? 1 : 0)
                        .offset(y: showDailyProducts ? 0 : 30)

                        CalorieGoalsSection(
                            mealCalories: caloriesViewModel.dailyKcal,
                            targetCalories: caloriesViewModel.calorieGoal,
                            caloriesBurned: caloriesViewModel.totalBurnedKcal,
                            isLoading: caloriesViewModel.isInitialLoading,
                            onCompleteProfileTap: {
                                router.push(ProfileRoute.personalInformation)
                            }
                        )
                        .opacity(showCalorieGoals ? 1 : 0)
                        .offset(y: showCalorieGoals ? 0 : 30)

                        HStack(spacing: 12) {
                            StepGaugeCardView(
                                currentSteps: stepViewModel.todaySteps,
                                goalSteps: 10_000,
                                onTap: {
                                    router.push(CaloriesRoute.stepHistory(viewModel: stepViewModel))
                                }
                            )

                            ExerciseCardView(
                                exerciseKcal: Int(caloriesViewModel.exerciseKcal.rounded()),
                                exerciseMinutes: caloriesViewModel.exerciseMinutes,
                                isLoading: caloriesViewModel.isInitialLoading,
                                onAddTap: {
                                    router.push(CaloriesRoute.exercises)
                                }
                            )
                        }
                        .opacity(showStepsAndExercise ? 1 : 0)
                        .offset(y: showStepsAndExercise ? 0 : 30)

                        WaterTrackingSection(
                            currentGlasses: caloriesViewModel.waterCurrent,
                            goalGlasses: caloriesViewModel.waterGoal,
                            isUpdating: caloriesViewModel.isUpdatingWater,
                            isLoading: caloriesViewModel.isInitialLoading,
                            onAddTargetCupTap: {
                                caloriesViewModel.addTargetCup()
                            },
                            onFillCup: { index in
                                caloriesViewModel.fillCup(index: index)
                            },
                            onUnfillCupRequest: { index in
                                unfillCupIndex = index
                                alert = .waterRemoval
                            },
                            onDeleteTargetCupRequest: {
                                alert = .targetCupRemoval
                            }
                        )
                        .opacity(showWater ? 1 : 0)
                        .offset(y: showWater ? 0 : 30)
                        }
                        .padding(22)

                        Spacer(minLength: CustomAnimatedTabBar.contentClearance)
                    }
            }
        }
        .animation(.easeOut(duration: 0.2), value: caloriesViewModel.isInitialLoading)
        .onAppear {
            stepViewModel.onAppear()
            triggerEntranceAnimations()
            if stepViewModel.errorMessage != nil {
                alert = .healthAccess
            }
        }
        .onDisappear {
            stepPersistenceTask?.cancel()
            persistCurrentSteps()
            stepViewModel.onDisappear()
        }
        .onChange(of: stepViewModel.todaySteps) { _, _ in
            stepPersistenceTask?.cancel()
            stepPersistenceTask = Task {
                try? await Task.sleep(for: .seconds(5))
                guard !Task.isCancelled else { return }
                persistCurrentSteps()
            }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                Task { await handleActivation() }
            } else {
                stepPersistenceTask?.cancel()
                persistCurrentSteps()
            }
        }
        .onChange(of: flowCoordinator.selectedTab) { _, selectedTab in
            guard selectedTab == .calories else { return }
            Task { await handleActivation() }
        }
        .onChange(of: stepViewModel.errorMessage) { _, error in
            if error != nil {
                alert = .healthAccess
            }
        }
        .onChange(of: caloriesViewModel.errorMessage) { _, error in
            if error != nil {
                alert = .loadingError
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .NSCalendarDayChanged)) { _ in
            Task { await handleActivation() }
        }
        .task {
            await handleActivation()
        }
        .customAlert(item: $alert, config: { alert in
            switch alert {
            case .healthAccess:
                return CustomAlertConfig(
                    type: .warning,
                    title: "Health Access",
                    message: stepViewModel.errorMessage ?? "Permission required"
                )
            case .loadingError:
                return CustomAlertConfig(
                    type: .error,
                    title: "Something went wrong",
                    message: caloriesViewModel.errorMessage ?? "Please try again."
                )
            case .mealRemoval:
                return CustomAlertConfig(
                    type: .delete,
                    title: mealRemovalRequest?.kind == .one ? "Remove One Serving?" : "Remove Meal?",
                    message: mealRemovalRequest?.kind == .one
                        ? "One serving will be removed from today's log."
                        : "All servings of this meal will be removed from today's log.",
                    primaryButton: CustomAlertButton("Remove", role: .destructive),
                    secondaryButton: CustomAlertButton("Cancel", role: .cancel)
                )
            case .waterRemoval:
                return CustomAlertConfig(
                    type: .delete,
                    title: "Remove Water?",
                    message: "Do you want to mark this cup as undrunk?",
                    primaryButton: CustomAlertButton("Remove", role: .destructive),
                    secondaryButton: CustomAlertButton("Cancel", role: .cancel)
                )
            case .targetCupRemoval:
                return CustomAlertConfig(
                    type: .delete,
                    title: "Remove Target Cup?",
                    message: "This will reduce your daily water goal by 1 cup.",
                    primaryButton: CustomAlertButton("Remove", role: .destructive),
                    secondaryButton: CustomAlertButton("Cancel", role: .cancel)
                )
            }
        }, primaryAction: { alert in
            switch alert {
            case .healthAccess:
                break
            case .loadingError:
                caloriesViewModel.dismissError()
            case .mealRemoval:
                if let request = mealRemovalRequest {
                    Task {
                        switch request.kind {
                        case .one:
                            await caloriesViewModel.removeOneMeal(scanId: request.meal.scanId)
                        case .all:
                            await caloriesViewModel.deleteMeal(scanId: request.meal.scanId)
                        }
                    }
                }
                mealRemovalRequest = nil
            case .waterRemoval:
                if unfillCupIndex != nil {
                    caloriesViewModel.removeConsumedCup()
                }
                unfillCupIndex = nil
            case .targetCupRemoval:
                caloriesViewModel.removeTargetCup()
            }
        }, secondaryAction: { alert in
            if alert == .mealRemoval {
                mealRemovalRequest = nil
            } else if alert == .waterRemoval {
                unfillCupIndex = nil
            }
        })
    }

    private func triggerEntranceAnimations() {
        let spring = Animation.spring(response: 0.6, dampingFraction: 0.75)

        withAnimation(spring.delay(0.1)) { showDailyProducts = true }
        withAnimation(spring.delay(0.2)) { showCalorieGoals = true }
        withAnimation(spring.delay(0.35)) { showStepsAndExercise = true }
        withAnimation(spring.delay(0.5)) { showWater = true }
    }

    private func persistCurrentSteps() {
        persistCurrentSteps(for: caloriesViewModel.loadedDate)
    }

    private func persistCurrentSteps(for date: String?) {
        guard stepViewModel.isAuthorized, stepViewModel.hasHealthKitReading else { return }
        let analytics = stepViewModel.todayAnalytics()
        if let date {
            caloriesViewModel.updateSteps(
                stepViewModel.todaySteps,
                calories: analytics.caloriesBurned,
                for: date
            )
        } else {
            caloriesViewModel.updateSteps(
                stepViewModel.todaySteps,
                calories: analytics.caloriesBurned
            )
        }
    }

    private func handleActivation() async {
        if caloriesViewModel.needsDayRollover {
            persistCurrentSteps(for: caloriesViewModel.loadedDate)
            stepPersistenceTask?.cancel()
            stepViewModel.rolloverToCurrentDay()
        }
        await caloriesViewModel.activate()
    }
}

#Preview("Light") {
    CaloriesScreen()
        .environmentObject(AppRouter())
        .environmentObject(AppFlowCoordinator())
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    CaloriesScreen()
        .environmentObject(AppRouter())
        .environmentObject(AppFlowCoordinator())
        .preferredColorScheme(.dark)
}
