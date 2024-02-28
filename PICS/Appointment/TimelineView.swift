//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
import Foundation
import SwiftUI

struct CurrentLocation: Shape {
    let date1: Date
    let date2: Date
    let now: Date
    
    init(date1: Date, date2: Date, now: Date) {
        self.date1 = date1
        self.date2 = date2
        self.now = now
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let arrowWidth = rect.width
        let arrowHeight = rect.height / 2
       
        let circleRadius: CGFloat = 7
        let positions: [CGFloat] = [1, 2, 3, 4, 5].map { CGFloat($0) / 6 }
        
        for position in positions {
            let circleRect = CGRect(
                x: arrowWidth * position - circleRadius,
                y: arrowHeight / 2 - circleRadius,
                width: circleRadius * 2,
                height: circleRadius * 2
            )
            if (now < date1 && position == 1 / 6) ||
                (now == date1 && position == 2 / 6) ||
                (now > date1 && now < date2 && position == 3 / 6) ||
                (now == date2 && position == 4 / 6) ||
                (now > date2 && position == 5 / 6 ) {
                path.addEllipse(in: circleRect)
            }
        }
        
        return path
    }
}

struct BidirectionalArrow: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let arrowWidth = rect.width
        let arrowHeight = rect.height / 2
        
        // Draw the main arrow line
        path.move(to: CGPoint(x: 0, y: arrowHeight / 2))
        path.addLine(to: CGPoint(x: arrowWidth, y: arrowHeight / 2))
        
       
        let circleRadius: CGFloat = 5
        
        let circleRect1 = CGRect(
            x: arrowWidth * 1 / 3 - circleRadius,
            y: arrowHeight / 2 - circleRadius,
            width: circleRadius * 2,
            height: circleRadius * 2
        )
        path.addEllipse(in: circleRect1)
        
        let circleRect2 = CGRect(
            x: arrowWidth * 2 / 3 - circleRadius,
            y: arrowHeight / 2 - circleRadius,
            width: circleRadius * 2,
            height: circleRadius * 2
        )
        path.addEllipse(in: circleRect2)
        
        // Draw the right arrowhead lines
        path.move(to: CGPoint(x: arrowWidth - arrowHeight / 2, y: arrowHeight / 4))
        path.addLine(to: CGPoint(x: arrowWidth, y: arrowHeight / 2))
        path.addLine(to: CGPoint(x: arrowWidth - arrowHeight / 2, y: arrowHeight * 3 / 4))
        path.closeSubpath()
        
        // Draw the left arrowhead lines
        path.move(to: CGPoint(x: arrowHeight / 2, y: arrowHeight / 4))
        path.addLine(to: CGPoint(x: 0, y: arrowHeight / 2))
        path.addLine(to: CGPoint(x: arrowHeight / 2, y: arrowHeight * 3 / 4))
        path.closeSubpath()
        
        return path
    }
}


struct TimelineView: View {
    let appt1: Date
    let appt2: Date
    
    var body: some View {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let components1 = calendar.dateComponents([.year, .month, .day], from: appt1)
        let components2 = calendar.dateComponents([.year, .month, .day], from: appt2)
        let components3 = calendar.dateComponents([.year, .month, .day], from: currentDate)

        if let date1 = calendar.date(from: components1), let date2 = calendar.date(from: components2), let now = calendar.date(from: components3) {
            VStack {
                BidirectionalArrow()
                    .fill(Color.black)
                    .stroke(Color.black, lineWidth: 2)
                    .frame(width: 361, height: 25)
                    .overlay(
                        CurrentLocation(date1: date1, date2: date2, now: now)
                            .fill(Color.accentColor)
                    )
                HStack(spacing: 0) {
                    Spacer()
                    Text("Appointment 1")
                        .padding(.leading, 45)
                    Spacer()
                    Text("Appointment 2")
                        .padding(.trailing, 40)
                    Spacer()
                }
                .font(.system(size: 12))
                .foregroundColor(.black)
            }
        } else {
            Text("Failed to get dates")
               .foregroundColor(.red)
        }
    }
}
