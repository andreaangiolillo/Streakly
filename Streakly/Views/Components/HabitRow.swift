// Views/Components/HabitRow.swift
import SwiftUI
// Views/Components/HabitIconView.swift
struct HabitIconView: View {
    let iconName: String
    let color: Color
    let progress: Double
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(color.opacity(0.15), lineWidth: 1.5)
                .frame(width: 40, height: 40)
            
            // Progress arc
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, lineWidth: 1.5)
                .frame(width: 40, height: 40)
                .rotationEffect(.degrees(-90))
            
            // Icon
            Image(systemName: iconName)
                .font(.system(size: 16))
                .foregroundColor(color)
        }
    }
}

// Views/Components/HabitRow.swift
struct HabitRow: View {
    let habit: Habit
    @ObservedObject var habitStore: HabitStore
    
    private var progress: Double {
        guard let todayProgress = habitStore.getProgress(for: habit.id) else {
            return 0.0
        }
        
        switch habit.trackingUnit {
        case .count:
            guard let currentCount = todayProgress.count,
                  let targetCount = habit.targetCount,
                  targetCount > 0 else {
                return 0.0
            }
            return min(Double(currentCount) / Double(targetCount), 1.0)
            
        case .time:
            guard let duration = todayProgress.duration,
                  let targetTime = habit.targetTime else {
                return 0.0
            }
            let targetSeconds = Double(targetTime.hours * 3600 + targetTime.minutes * 60)
            guard targetSeconds > 0 else { return 0.0 }
            return min(Double(duration) / targetSeconds, 1.0)
        }
    }
    
    var body: some View {
        HStack {
            HabitIconView(
                iconName: habit.iconName,
                color: habit.color,
                progress: progress
            )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.name)
                    .font(.system(size: 17, weight: .regular))
                
                Text(progressText)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            .padding(.leading, 12)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(Color(.systemGray4))
                .font(.system(size: 14))
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
    
    private var progressText: String {
        let current: String
        let target: String
        
        switch habit.trackingUnit {
        case .count:
            let currentCount = habitStore.getProgress(for: habit.id)?.count ?? 0
            let targetCount = habit.targetCount ?? 0
            current = "\(currentCount)"
            target = "\(targetCount)"
        case .time:
            if let duration = habitStore.getProgress(for: habit.id)?.duration {
                current = formatTime(seconds: duration)
            } else {
                current = "0"
            }
            if let targetTime = habit.targetTime {
                target = "\(targetTime.hours)h \(targetTime.minutes)m"
            } else {
                target = "0"
            }
        }
        
        return "\(current)/\(target)"
    }
    
    private func formatTime(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
}
