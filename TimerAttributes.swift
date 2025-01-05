// TimerAttributes.swift
import ActivityKit
import SwiftUI

public struct TimerAttributes: ActivityAttributes {
    public typealias ContentState = TimerStatus
    
    public struct TimerStatus: Codable, Hashable {
        public var elapsedSeconds: Int
        public var targetSeconds: Int
        public var isRunning: Bool
        
        public init(elapsedSeconds: Int, targetSeconds: Int, isRunning: Bool) {
            self.elapsedSeconds = elapsedSeconds
            self.targetSeconds = targetSeconds
            self.isRunning = isRunning
        }
    }
    
    public let habitId: String
    public let habitName: String
    public let iconName: String
    public let colorHex: String // Store color as hex string
    
    public var color: Color {
        Color(hex: colorHex) ?? .blue // Provide a default color
    }
    
    public init(habitId: String, habitName: String, iconName: String, color: Color) {
        self.habitId = habitId
        self.habitName = habitName
        self.iconName = iconName
        self.colorHex = color.toHex() ?? "#0000FF" // Convert Color to hex string
    }
}

// Color extensions to handle hex conversion
extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
    
    func toHex() -> String? {
        guard let components = UIColor(self).cgColor.components else { return nil }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        
        return String(format: "#%02lX%02lX%02lX",
                     lroundf(r * 255),
                     lroundf(g * 255),
                     lroundf(b * 255))
    }
}
