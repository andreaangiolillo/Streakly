// Models/Habit.swift
import SwiftUI

enum HabitFrequency: String, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
}

enum TrackingUnit: String, CaseIterable {
    case time = "Time"
    case count = "Count"
}

struct TimeValue: Equatable {
    var hours: Int
    var minutes: Int
    
    var totalMinutes: Int {
        return hours * 60 + minutes
    }
}

struct Habit: Identifiable {
    let id: UUID
    var name: String
    var color: Color
    var iconName: String
    var frequency: HabitFrequency
    var trackingUnit: TrackingUnit
    var targetCount: Int?
    var targetTime: TimeValue?
    var notes: String
    var createdAt: Date
    var completions: [Date]
    
    init(
        name: String,
        color: Color,
        iconName: String,
        frequency: HabitFrequency,
        trackingUnit: TrackingUnit,
        targetCount: Int? = nil,
        targetTime: TimeValue? = nil,
        notes: String = ""
    ) {
        self.id = UUID()
        self.name = name
        self.color = color
        self.iconName = iconName
        self.frequency = frequency
        self.trackingUnit = trackingUnit
        self.targetCount = targetCount
        self.targetTime = targetTime
        self.notes = notes
        self.createdAt = Date()
        self.completions = []
    }
}
