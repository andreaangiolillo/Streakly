// Stores/HabitStore.swift
import SwiftUI
import Combine

class HabitStore: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var progress: [UUID: [HabitProgress]] = [:]
    
    func updateProgress(for habit: UUID, count: Int? = nil, duration: Int? = nil) {
        let today = Calendar.current.startOfDay(for: Date())
        
        // Create a mutable copy of the progress array for this habit
        var habitProgress = progress[habit] ?? []
        
        if let existingIndex = habitProgress.firstIndex(where: {
            Calendar.current.isDate($0.date, inSameDayAs: today)
        }) {
            // Update existing progress
            habitProgress[existingIndex] = HabitProgress(
                date: today,
                count: count,
                duration: duration
            )
        } else {
            // Add new progress for today
            habitProgress.append(HabitProgress(
                date: today,
                count: count,
                duration: duration
            ))
        }
        
        // Trigger a UI update by modifying the published property
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
