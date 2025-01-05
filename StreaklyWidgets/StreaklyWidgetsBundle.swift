//
//  StreaklyWidgetsBundle.swift
//  StreaklyWidgets
//
//  Created by Andrea on 05/01/2025.
//

import WidgetKit
import SwiftUI

@main
struct StreaklyWidgetsBundle: WidgetBundle {
    var body: some Widget {
        StreaklyWidgets()
        StreaklyWidgetsControl()
        StreaklyWidgetsLiveActivity()
    }
}
