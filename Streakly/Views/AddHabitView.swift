// Views/AddHabitView.swift
import SwiftUI
struct AddHabitView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var habitStore: HabitStore
    
    @State private var habitName = ""
    @State private var selectedColor: Color = .blue
    @State private var selectedIcon = "star.fill"
    @State private var selectedFrequency: HabitFrequency = .daily
    @State private var trackingUnit: TrackingUnit = .count
    @State private var countValue = 1
    @State private var selectedHours = 0
    @State private var selectedMinutes = 0
    @State private var notes = ""
    @State private var showingIconSelection = false // State for icon selection sheet
    
    var body: some View {
        NavigationView {
            Form {
                // Basic Info
                Section(header: Text("Basic Information")) {
                    TextField("Habit name", text: $habitName)
                }
                
                // Icon & Color Selection
                Section(header: Text("Icon & Color")) {
                    Button(action: {
                        showingIconSelection = true // Set to true when button is tapped
                    }) {
                        HStack {
                            Image(systemName: selectedIcon)
                                .font(.title2)
                                .foregroundColor(selectedColor)
                                .frame(width: 44, height: 44)
                                .background(
                                    Circle()
                                        .fill(Color(.systemGray6))
                                )
                            
                            Text("Choose Icon & Color")
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                // Tracking Details
                Section(header: Text("Tracking Details")) {
                    Picker("Unit", selection: $trackingUnit) {
                        ForEach(TrackingUnit.allCases, id: \.self) { unit in
                            Text(unit.rawValue)
                        }
                    }
                    
                    Picker("Frequency", selection: $selectedFrequency) {
                        ForEach(HabitFrequency.allCases, id: \.self) { frequency in
                            Text(frequency.rawValue)
                        }
                    }
                    
                    if trackingUnit == .count {
                        HStack {
                            Text("Target count")
                            Spacer()
                            HStack(spacing: 20) {
                                // Decrement button
                                Button {
                                    print("Decrement pressed, current value: \(countValue)")
                                    if countValue > 1 {
                                        countValue -= 1
                                        print("New value after decrement: \(countValue)")
                                    }
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 24))
                                }
                                
                                // Count display
                                Text("\(countValue)")
                                    .frame(minWidth: 40)
                                    .multilineTextAlignment(.center)
                                
                                // Increment button
                                Button {
                                    print("Increment pressed, current value: \(countValue)")
                                    countValue = countValue + 1
                                    print("New value after increment: \(countValue)")
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 24))
                                }
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    
                
                    } else {
                        HStack {
                            Text("Target time")
                            Spacer()
                            DatePicker(
                                "",
                                selection: .init(
                                    get: {
                                        Calendar.current.date(from: DateComponents(hour: selectedHours, minute: selectedMinutes)) ?? Date()
                                    },
                                    set: { date in
                                        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
                                        selectedHours = components.hour ?? 0
                                        selectedMinutes = components.minute ?? 0
                                    }
                                ),
                                displayedComponents: [.hourAndMinute]
                            )
                            .labelsHidden()
                        }
                    }
                }
                
                // Notes section
                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        saveHabit()
                    }
                    .disabled(habitName.isEmpty)
                }
            }
        }
        .sheet(isPresented: $showingIconSelection) {
            IconSelectionView(
                selectedIcon: $selectedIcon,
                selectedColor: $selectedColor
            )
        }
    }
    
    private func saveHabit() {
        let habit = Habit(
            name: habitName,
            color: selectedColor,
            iconName: selectedIcon,
            frequency: selectedFrequency,
            trackingUnit: trackingUnit,
            targetCount: trackingUnit == .count ? countValue : nil,
            targetTime: trackingUnit == .time ? TimeValue(hours: selectedHours, minutes: selectedMinutes) : nil,
            notes: notes
        )
        habitStore.habits.append(habit)
        dismiss()
    }
}
