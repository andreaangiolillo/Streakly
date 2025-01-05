import SwiftUI

struct DailyProgressCard: View {
    @ObservedObject var habitStore: HabitStore
    
    private var totalProgress: Double {
        let habits = habitStore.habits
        guard !habits.isEmpty else { return 0 }
        
        let totalProgress = habits.reduce(0.0) { sum, habit in
            sum + calculateHabitProgress(habit)
        }
        
        return totalProgress / Double(habits.count)
    }
    
    private var isComplete: Bool {
        totalProgress >= 1.0
    }
    
    private var progressColor: Color {
        isComplete ? .green : .blue
    }
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color(.systemGray5), lineWidth: 2)
                .frame(width: 160, height: 160)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: totalProgress)
                .stroke(
                    progressColor,
                    style: StrokeStyle(lineWidth: 2, lineCap: .round)
                )
                .frame(width: 160, height: 160)
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: totalProgress)
            
            // Percentage or completion indicator
            if isComplete {
                VStack(spacing: 4) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.green)
                    
                    Text("100%")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.green)
                }
                .transition(.opacity.combined(with: .scale))
            } else {
                Text("\(Int(totalProgress * 100))%")
                    .font(.system(size: 34, weight: .medium))
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: totalProgress)
            }
        }
        .frame(height: 200)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isComplete)
    }
    
    private func calculateHabitProgress(_ habit: Habit) -> Double {
        guard let progress = habitStore.getProgress(for: habit.id) else {
            return 0.0
        }
        
        switch habit.trackingUnit {
        case .count:
            guard let currentCount = progress.count,
                  let targetCount = habit.targetCount,
                  targetCount > 0 else {
                return 0.0
            }
            return min(Double(currentCount) / Double(targetCount), 1.0)
            
        case .time:
            guard let duration = progress.duration,
                  let targetTime = habit.targetTime else {
                return 0.0
            }
            let targetSeconds = Double(targetTime.hours * 3600 + targetTime.minutes * 60)
            guard targetSeconds > 0 else { return 0.0 }
            return min(Double(duration) / targetSeconds, 1.0)
        }
    }
}
