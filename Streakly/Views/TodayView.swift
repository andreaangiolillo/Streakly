import SwiftUI
// Views/TodayView.swift
// Views/TodayView.swift
struct TodayView: View {
    @EnvironmentObject var habitStore: HabitStore
    @State private var showingAddHabit = false
    @State private var selectedHabit: Habit?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Progress card
                    DailyProgressCard(habitStore: habitStore)
                        .padding(.horizontal)
                    
                    // Habits section
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Habits")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Spacer()
                            .foregroundColor(.blue)
                        }
                        .padding(.horizontal)
                        
                        // Habits list
                        ForEach(habitStore.habits) { habit in
                            HabitRow(habit: habit, habitStore: habitStore)
                                .padding(.horizontal)
                                .onTapGesture {
                                    selectedHabit = habit
                                }
                        }
                    }
                }
            }
            .navigationTitle("Today")
            .toolbar {
                Button {
                    showingAddHabit = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                AddHabitView()
            }
            .sheet(item: $selectedHabit) { habit in
                HabitTrackingSheet(habitStore: habitStore, habit: habit)
            }
        }
    }
}
