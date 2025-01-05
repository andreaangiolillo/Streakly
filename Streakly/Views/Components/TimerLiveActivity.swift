// TimerLiveActivity.swift
import SwiftUI
import ActivityKit
import WidgetKit

struct TimerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerAttributes.self) { context in
            TimelineView(.periodic(from: .now, by: 1.0)) { timeline in
                HStack {
                    Image(systemName: context.attributes.iconName)
                        .foregroundColor(Color.accentColor)
                    
                    Text(context.attributes.habitName)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text(formatTime(seconds: context.state.elapsedSeconds))
                        .monospacedDigit()
                        .fontWeight(.semibold)
                }
                .padding(.horizontal)
            }
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI
                DynamicIslandExpandedRegion(.leading) {
                    Label {
                        Text(context.attributes.habitName)
                            .font(.headline)
                    } icon: {
                        Image(systemName: context.attributes.iconName)
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Text(formatTime(seconds: context.state.elapsedSeconds))
                        .font(.headline)
                        .monospacedDigit()
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    // Progress bar
                    if context.state.targetSeconds > 0 {
                        ProgressView(
                            value: Double(context.state.elapsedSeconds),
                            total: Double(context.state.targetSeconds)
                        )
                    }
                }
            } compactLeading: {
                Label {
                    Text(context.attributes.habitName)
                } icon: {
                    Image(systemName: context.attributes.iconName)
                }
            } compactTrailing: {
                Text(formatTime(seconds: context.state.elapsedSeconds))
                    .monospacedDigit()
            } minimal: {
                Image(systemName: "timer")
            }
        }
    }
    
    private func formatTime(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
