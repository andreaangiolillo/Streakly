//
//  StreaklyWidgetsLiveActivity.swift
//  StreaklyWidgets
//
//  Created by Andrea on 05/01/2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct StreaklyWidgetsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct StreaklyWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: StreaklyWidgetsAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension StreaklyWidgetsAttributes {
    fileprivate static var preview: StreaklyWidgetsAttributes {
        StreaklyWidgetsAttributes(name: "World")
    }
}

extension StreaklyWidgetsAttributes.ContentState {
    fileprivate static var smiley: StreaklyWidgetsAttributes.ContentState {
        StreaklyWidgetsAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: StreaklyWidgetsAttributes.ContentState {
         StreaklyWidgetsAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: StreaklyWidgetsAttributes.preview) {
   StreaklyWidgetsLiveActivity()
} contentStates: {
    StreaklyWidgetsAttributes.ContentState.smiley
    StreaklyWidgetsAttributes.ContentState.starEyes
}
