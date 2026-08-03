//
//  CaloriesHistoryViewModel.swift
//  NutriScan
//
//  Created by albaraa alsayed on 20/02/1448 AH.
//

import Foundation
import Observation

@MainActor
@Observable
final class CaloriesHistoryViewModel {
    private(set) var days: [DayUIState] = []
    private(set) var selectedDate: Date?
    private(set) var isLoadingInitial = true
    private(set) var isLoadingNextPage = false
    private(set) var isRefreshing = false
    private(set) var initialLoadError: String?
    private(set) var paginationError: String?

    var isFiltered: Bool { selectedDate != nil }

    var selectedDateLabel: String {
        guard let selectedDate else { return "" }
        return selectedDate.formatted(date: .abbreviated, time: .omitted)
    }

    private let getPageUseCase: GetCaloriesHistoryPageUseCaseProtocol
    private let getByDateUseCase: GetCaloriesHistoryByDateUseCaseProtocol
    private let pageSize: Int

    private var hasLoaded = false
    private var nextPage = 0
    private var hasMorePages = true
    private var requestGeneration = 0

    init(
        getPageUseCase: GetCaloriesHistoryPageUseCaseProtocol,
        getByDateUseCase: GetCaloriesHistoryByDateUseCaseProtocol,
        pageSize: Int = 20
    ) {
        self.getPageUseCase = getPageUseCase
        self.getByDateUseCase = getByDateUseCase
        self.pageSize = pageSize
    }

    func loadIfNeeded() async {
        guard !hasLoaded else { return }
        await loadFirstPage()
    }

    func loadIfConnected(_ isConnected: Bool) async {
        guard isConnected else { return }
        await loadIfNeeded()
    }

    func retryAfterConnectionRestored() async {
        guard days.isEmpty else { return }

        if initialLoadError != nil {
            await retryInitialLoad()
        } else {
            await loadIfNeeded()
        }
    }

    func retryInitialLoad() async {
        if let selectedDate {
            await applyDateFilter(selectedDate)
        } else {
            await loadFirstPage()
        }
    }

    func applyDateFilter(_ date: Date) async {
        requestGeneration += 1
        let generation = requestGeneration
        defer {
            if generation == requestGeneration {
                hasLoaded = true
                isLoadingInitial = false
            }
        }

        selectedDate = Calendar.current.startOfDay(for: date)
        days = []
        resetErrors()
        isLoadingInitial = true
        isLoadingNextPage = false
        hasMorePages = false

        do {
            let day = try await getByDateUseCase.execute(date: date)
            guard isCurrent(generation) else { return }
            days = [DayUIState(day: day)]
        } catch is CancellationError {
            return
        } catch CaloriesHistoryError.notFound {
            guard isCurrent(generation) else { return }
            days = []
        } catch {
            guard isCurrent(generation) else { return }
            initialLoadError = error.localizedDescription
        }
    }

    func removeDateFilter() async {
        selectedDate = nil
        await loadFirstPage()
    }

    func refresh() async {
        requestGeneration += 1
        let generation = requestGeneration
        defer {
            if generation == requestGeneration {
                isRefreshing = false
            }
        }
        isRefreshing = true
        resetErrors()

        do {
            if let selectedDate {
                let day = try await getByDateUseCase.execute(date: selectedDate)
                guard isCurrent(generation) else { return }
                days = [DayUIState(day: day)]
            } else {
                let page = try await getPageUseCase.execute(page: 0, size: pageSize)
                guard isCurrent(generation) else { return }
                apply(page: page, replacing: true)
            }
        } catch is CancellationError {
            return
        } catch CaloriesHistoryError.notFound {
            guard isCurrent(generation) else { return }
            days = []
        } catch {
            guard isCurrent(generation) else { return }
            if days.isEmpty {
                initialLoadError = error.localizedDescription
            } else {
                paginationError = error.localizedDescription
            }
        }
    }

    func loadNextPageIfNeeded(currentDayID: DayUIState.ID) async {
        guard selectedDate == nil,
              days.last?.id == currentDayID,
              hasMorePages,
              !isLoadingInitial,
              !isLoadingNextPage,
              paginationError == nil else {
            return
        }
        await loadNextPage()
    }

    func retryPagination() async {
        paginationError = nil
        await loadNextPage()
    }

    private func loadFirstPage() async {
        requestGeneration += 1
        let generation = requestGeneration
        defer {
            if generation == requestGeneration {
                hasLoaded = true
                isLoadingInitial = false
            }
        }

        days = []
        nextPage = 0
        hasMorePages = true
        resetErrors()
        isLoadingInitial = true
        isLoadingNextPage = false

        do {
            let page = try await getPageUseCase.execute(page: 0, size: pageSize)
            guard isCurrent(generation) else { return }
            apply(page: page, replacing: true)
        } catch is CancellationError {
            return
        } catch {
            guard isCurrent(generation) else { return }
            initialLoadError = error.localizedDescription
        }
    }

    private func loadNextPage() async {
        guard hasMorePages, !isLoadingNextPage else { return }
        let generation = requestGeneration
        defer {
            if generation == requestGeneration {
                isLoadingNextPage = false
            }
        }
        isLoadingNextPage = true

        do {
            let page = try await getPageUseCase.execute(page: nextPage, size: pageSize)
            guard isCurrent(generation) else { return }
            apply(page: page, replacing: false)
        } catch is CancellationError {
            return
        } catch {
            guard isCurrent(generation) else { return }
            paginationError = error.localizedDescription
        }
    }

    private func apply(page: CaloriesHistoryPage, replacing: Bool) {
        let incoming = page.days.map(DayUIState.init(day:))
        if replacing {
            days = incoming
        } else {
            let existingIDs = Set(days.map(\.id))
            days.append(contentsOf: incoming.filter { !existingIDs.contains($0.id) })
        }

        nextPage = page.currentPage + 1
        hasMorePages = !page.isLast
            && (page.totalPages == 0 || nextPage < page.totalPages)
        initialLoadError = nil
        paginationError = nil
    }

    private func resetErrors() {
        initialLoadError = nil
        paginationError = nil
    }

    private func isCurrent(_ generation: Int) -> Bool {
        generation == requestGeneration && !Task.isCancelled
    }
}
