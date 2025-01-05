// Views/Components/CircularProgressView.swift
import SwiftUI



struct CircularProgressView: View {
    let segments: [(color: Color, progress: Double)]
    
    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width/2, y: size.height/2)
            let radius = min(size.width, size.height)/2 - 1.5
            let segmentCount = Double(segments.count)
            var startAngle: Double = -.pi/2
            
            for segment in segments {
                let segmentSize = (2 * .pi) / segmentCount
                let endAngle = startAngle + (segmentSize * segment.progress)
                
                if segment.progress > 0 {
                    let path = Path { p in
                        p.addArc(
                            center: center,
                            radius: radius,
                            startAngle: Angle(radians: startAngle),
                            endAngle: Angle(radians: endAngle),
                            clockwise: false
                        )
                    }
                    
                    context.stroke(
                        path,
                        with: .color(segment.color),
                        lineWidth: 3
                    )
                }
                
                startAngle += segmentSize
            }
        }
    }
}
