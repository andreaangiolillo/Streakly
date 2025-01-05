// Views/HabitTrackingSheet.swift
import SwiftUI
import ActivityKit

struct HabitTrackingSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var habitStore: HabitStore
    let habit: Habit
    
    @State private var currentCount = 0
    
    private var elapsedSeconds: Int {
        habitStore.getProgress(for: habit.id)?.duration ?? 0
    }
    
    private var timerRunning: Bool {
        habitStore.isTimerRunning(for: habit.id)
    }
    
    var formattedTime: String {
        let hours = elapsedSeconds / 3600
        let minutes = (elapsedSeconds % 3600) / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Habit Header with more compact design
                HStack {
                    Image(systemName: habit.iconName)
                        .font(.title2)
                        .foregroundColor(habit.color)
                    
                    Text(habit.name)
                        .font(.title3)
                        .bold()
                }
                .padding(.top, 8)
                
                if habit.trackingUnit == .count {
                    countBasedTracking
                } else {
                    timeBasedTracking
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                loadExistingProgress()
            }
            .background(Color(.systemBackground).opacity(0.95))
            .onReceive(Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()) { _ in
                // The view will automatically update because we're using a computed property
                // for elapsedSeconds that reads from habitStore
            }
        }
        .presentationDetents([.fraction(0.4)])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(30)
        .interactiveDismissDisabled(false)
    }
    
    // Count-based tracking interface
    var countBasedTracking: some View {
        VStack(spacing: 20) {
            // Current count display
            Text("\(currentCount)")
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .foregroundColor(habit.color)
            
            // Increment/Decrement controls
            HStack(spacing: 20) {
                Button(action: { if currentCount > 0 { currentCount -= 1 } }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(.gray)
                }
                
                Button(action: { currentCount += 1 }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(habit.color)
                }
            }
            
            if let targetCount = habit.targetCount {
                Text("Target: \(targetCount)")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
        .onChange(of: currentCount) { _ in
            habitStore.updateProgress(for: habit.id, count: currentCount)
        }
    }
    
    // Time-based tracking interface
    var timeBasedTracking: some View {
        VStack(spacing: 20) {
            // Timer display
            Text(formattedTime)
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .foregroundColor(habit.color)
            
            // Timer controls
            HStack(spacing: 20) {
                Button(action: timerRunning ? stopTimer : startTimer) {
                    Image(systemName: timerRunning ? "stop.circle.fill" : "play.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(timerRunning ? .red : habit.color)
                }
                
                Button(action: resetTimer) {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(.gray)
                }
            }
            
            // Quick add buttons
            HStack(spacing: 12) {
                QuickTimeButton(text: "+1m", action: { addTime(minutes: 1) }, habit: habit)
                QuickTimeButton(text: "+5m", action: { addTime(minutes: 5) }, habit: habit)
                QuickTimeButton(text: "+10m", action: { addTime(minutes: 10) }, habit: habit)
            }
            
            if let targetTime = habit.targetTime {
                Text("Target: \(targetTime.hours)h \(targetTime.minutes)m")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }
    
    private func loadExistingProgress() {
        if let progress = habitStore.getProgress(for: habit.id) {
            if let count = progress.count {
                currentCount = count
            }
        }
    }
    
    private func startTimer() {
        habitStore.startTimer(for: habit.id)
    }
    
    private func stopTimer() {
        habitStore.stopTimer(for: habit.id)
    }
    
    private func resetTimer() {
        stopTimer()
        habitStore.updateProgress(for: habit.id, duration: 0)
    }
    
    private func addTime(minutes: Int) {
        let newSeconds = (habitStore.getProgress(for: habit.id)?.duration ?? 0) + (minutes * 60)
        habitStore.updateProgress(for: habit.id, duration: newSeconds)
    }
}

// Helper view for quick time add buttons
struct QuickTimeButton: View {
    let text: String
    let action: () -> Void
    let habit: Habit
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.footnote)
                .bold()
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(habit.color.opacity(0.8))
                .cornerRadius(8)
        }
    }
}
