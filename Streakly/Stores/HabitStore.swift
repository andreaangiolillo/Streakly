// Stores/HabitStore.swift
import SwiftUI
import Combine
import ActivityKit

class HabitStore: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var progress: [UUID: [HabitProgress]] = [:]
    @Published var runningTimers: Set<UUID> = []
    
    private var timerStartTimes: [UUID: Date] = [:]
    private var observers: Set<AnyCancellable> = []
    private var updateTimer: Timer?
    
    init() {
        // Start a timer to update all running timers
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateRunningTimers()
        }
    }
    
    deinit {
        updateTimer?.invalidate()
    }
    
    func startTimer(for habitId: UUID) {
        runningTimers.insert(habitId)
        timerStartTimes[habitId] = Date()
        updateLiveActivity(for: habitId)
    }
    
    func stopTimer(for habitId: UUID) {
        runningTimers.remove(habitId)
        timerStartTimes.removeValue(forKey: habitId)
        endLiveActivity(for: habitId)
    }
    
    func isTimerRunning(for habitId: UUID) -> Bool {
        runningTimers.contains(habitId)
    }
    
    private func updateRunningTimers() {
        for habitId in runningTimers {
            guard let startTime = timerStartTimes[habitId] else { continue }
            let elapsed = Int(Date().timeIntervalSince(startTime))
            let previousProgress = getProgress(for: habitId)?.duration ?? 0
            let totalElapsed = previousProgress + elapsed
            
            updateProgress(for: habitId, duration: totalElapsed)
            updateLiveActivity(for: habitId)
        }
    }
    
    private func updateLiveActivity(for habitId: UUID) {
            guard let habit = habits.first(where: { $0.id == habitId }),
                  let progress = getProgress(for: habitId) else { return }
            
            let attributes = TimerAttributes(
                habitId: habitId.uuidString,
                habitName: habit.name,
                iconName: habit.iconName,
                color: habit.color
            )
            
            let contentState = TimerAttributes.ContentState(
                elapsedSeconds: progress.duration ?? 0,
                targetSeconds: habit.targetTime?.totalSeconds ?? 0,
                isRunning: true
            )
            
            Task {
                if let activity = Activity<TimerAttributes>.activities.first(where: { $0.attributes.habitId == habitId.uuidString }) {
                    await activity.update(ActivityContent(
                        state: contentState,
                        staleDate: .now.addingTimeInterval(1)
                    ))
                } else {
                    do {
                        _ = try Activity.request(
                            attributes: attributes,
                            content: ActivityContent(
                                state: contentState,
                                staleDate: .now.addingTimeInterval(1)
                            ),
                            pushType: nil
                        )
                    } catch {
                        print("Error starting live activity: \(error)")
                    }
                }
            }
        }
    
    private func endLiveActivity(for habitId: UUID) {
        Task {
            for activity in Activity<TimerAttributes>.activities where activity.attributes.habitId == habitId.uuidString {
                let finalContent = ActivityContent(
                    state: activity.content.state,
                    staleDate: nil
                )
                await activity.end(finalContent, dismissalPolicy: .immediate)
            }
        }
    }
    
    func updateProgress(for habit: UUID, count: Int? = nil, duration: Int? = nil) {
        let today = Calendar.current.startOfDay(for: Date())
        var habitProgress = progress[habit] ?? []
        
        if let existingIndex = habitProgress.firstIndex(where: {
            Calendar.current.isDate($0.date, inSameDayAs: today)
        }) {
            habitProgress[existingIndex] = HabitProgress(
                date: today,
                count: count,
                duration: duration
            )
        } else {
            habitProgress.append(HabitProgress(
                date: today,
                count: count,
                duration: duration
            ))
        }
        
        progress[habit] = habitProgress
        objectWillChange.send()
    }
    
    func getProgress(for habit: UUID, on date: Date = Date()) -> HabitProgress? {
        return progress[habit]?.first(where: {
            Calendar.current.isDate($0.date, inSameDayAs: date)
        })
    }
}


struct HabitProgress {
    var date: Date
    var count: Int?
    var duration: Int?
}
