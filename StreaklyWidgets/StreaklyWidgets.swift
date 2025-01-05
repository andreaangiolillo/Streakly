import WidgetKit
import SwiftUI
import ActivityKit

struct StreaklyWidgets: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerAttributes.self) { context in
            // Lock screen/banner UI
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: context.attributes.iconName)
                        .foregroundColor(Color.accentColor)
                    Text(context.attributes.habitName)
                        .bold()
                    Spacer()
                    TimerDisplayView(context: context)
                }
                if context.state.targetSeconds > 0 {
                    ProgressView(
                        value: Double(context.state.elapsedSeconds),
                        total: Double(context.state.targetSeconds)
                    )
                }
            }
            .padding()
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI
                DynamicIslandExpandedRegion(.leading) {
                    EmptyView() // Required but not used
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    EmptyView() // Required but not used
                }
                
                DynamicIslandExpandedRegion(.center) {
                    VStack(spacing: 4) {
                        TimerDisplayView(context: context)
                            .font(.system(size: 44, weight: .medium))
                            .foregroundStyle(context.attributes.color)
                        
                        if context.state.targetSeconds > 0 {
                            Text("Goal: \(formatHourMinutes(seconds: context.state.targetSeconds))")
                                .font(.system(size: 14))
                                .foregroundStyle(context.attributes.color)
                        }
                    }
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    HStack(spacing: 40) {
                        Button(action: {
                            // Pause action will be implemented
                        }) {
                            Label("Pause", systemImage: "pause.fill")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(context.attributes.color)
                        }
                        .buttonStyle(.plain)

                        Button(action: {
                            // Stop action will be implemented
                        }) {
                            Label("Stop", systemImage: "xmark")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(context.attributes.color)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.top, 10)
                }

            } compactLeading: {
                HStack(spacing: 4) {
                    Image(systemName: context.attributes.iconName)
                        .foregroundStyle(context.attributes.color)
                    Text(context.attributes.habitName)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(context.attributes.color)
                }
            } compactTrailing: {
                EmptyView()
            } minimal: {
                Image(systemName: context.attributes.iconName)
                    .foregroundStyle(context.attributes.color)
            }
        }
    }
    
    private func formatHourMinutes(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

struct TimerDisplayView: View {
    let context: ActivityViewContext<TimerAttributes>
    @State private var currentDate = Date()
    
    var body: some View {
        Text(formatTime(seconds: context.state.elapsedSeconds))
            .monospacedDigit()
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                    currentDate = Date()
                }
            }
    }
    
    private func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}
