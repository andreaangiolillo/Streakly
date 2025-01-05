//
//  ContentView.swift
//  Streakly
//
//  Created by Andrea on 04/01/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var habitStore = HabitStore()
    
    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "calendar")
                }
            
            AllHabitsView()
                .tabItem {
                    Label("Habits", systemImage: "list.bullet")
                }
            
            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .environmentObject(habitStore)
    }
}

#Preview {
    ContentView()
}
