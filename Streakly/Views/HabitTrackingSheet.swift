// Views/HabitTrackingSheet.swift
import SwiftUI

struct HabitTrackingSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var habitStore: HabitStore
    let habit: Habit
    
    @State private var currentCount = 0
    @State private var timerRunning = false
    @State private var elapsedSeconds = 0
    @State private var timer: Timer?
    
    var formattedTime: String {
        let hours = elapsedSeconds / 3600
        let minutes = (elapsedSeconds % 3600) / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Habit Header
                HStack {
                    Image(systemName: habit.iconName)
                        .font(.title)
                        .foregroundColor(habit.color)
                    
                    Text(habit.name)
                        .font(.title2)
                        .bold()
                }
                .padding(.top)
                
                if habit.trackingUnit == .count {
                    countBasedTracking
                } else {
                    timeBasedTracking
                }
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        saveAndDismiss()
                    }
                }
            }
            .onAppear {
                loadExistingProgress()
            }
            .onDisappear {
                saveAndDismiss()
            }
        }
        .presentationDetents([.height(500)])
    }
    
    private func loadExistingProgress() {
        if let progress = habitStore.getProgress(for: habit.id) {
            if let count = progress.count {
                currentCount = count
            }
            if let duration = progress.duration {
                elapsedSeconds = duration
            }
        }
    }
    
    private func saveAndDismiss() {
        if timerRunning {
            stopTimer()
        }
        
        switch habit.trackingUnit {
        case .count:
            habitStore.updateProgress(for: habit.id, count: currentCount)
        case .time:
            habitStore.updateProgress(for: habit.id, duration: elapsedSeconds)
        }
        
        dismiss()
    }
    
    // Count-based tracking interface
    var countBasedTracking: some View {
        VStack(spacing: 30) {
            // Current count display
            Text("\(currentCount)")
                .font(.system(size: 72, weight: .bold, design: .rounded))
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
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
    
    // Time-based tracking interface
    var timeBasedTracking: some View {
        VStack(spacing: 30) {
            // Timer display
            Text(formattedTime)
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundColor(habit.color)
            
            // Timer controls
            HStack(spacing: 20) {
                Button(action: timerRunning ? stopTimer : startTimer) {
                    Image(systemName: timerRunning ? "stop.circle.fill" : "play.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(timerRunning ? .red : habit.color)
                }
                
                Button(action: { elapsedSeconds = 0 }) {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(.gray)
                }
            }
            
            // Quick add buttons
            HStack(spacing: 15) {
                QuickTimeButton(text: "+1m", action: { elapsedSeconds += 60 })
                QuickTimeButton(text: "+5m", action: { elapsedSeconds += 300 })
                QuickTimeButton(text: "+10m", action: { elapsedSeconds += 600 })
            }
            
            if let targetTime = habit.targetTime {
                Text("Target: \(targetTime.hours)h \(targetTime.minutes)m")
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
    
    private func startTimer() {
        timerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            elapsedSeconds += 1
        }
    }
    
    private func stopTimer() {
        timerRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    private func saveProgress() {
        // Save progress based on tracking type
        if habit.trackingUnit == .count {
            // Save count progress
        } else {
            // Save time progress
            if timerRunning {
                stopTimer()
            }
        }
        dismiss()
    }
}

// Helper view for quick time add buttons
struct QuickTimeButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.subheadline)
                .bold()
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGray5))
                .cornerRadius(8)
        }
    }
}
