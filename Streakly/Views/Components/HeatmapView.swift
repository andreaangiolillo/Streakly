import SwiftUI

struct HeatmapView: View {
    let habit: Habit
    let dates: [Date]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(habit.name)
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    ForEach(dates, id: \.self) { date in
                        DayCell(
                            date: date,
                            intensity: calculateIntensity(for: date),
                            baseColor: habit.color
                        )
                    }
                }
            }
        }
    }
    
    private func calculateIntensity(for date: Date) -> Double {
        // Placeholder implementation
        return Double.random(in: 0...1)
    }
}

struct DayCell: View {
    let date: Date
    let intensity: Double
    let baseColor: Color
    
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(baseColor.opacity(0.2 + (intensity * 0.8)))
            .frame(width: 20, height: 20)
    }
}
