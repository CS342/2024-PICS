//
//  HKVisualizationItem.swift
//  PICS
//
//  Created by Yuren Sun on 2024/2/2.
//

import Charts
import Foundation
import SwiftUI


struct HKVisualizationItem: View {
    let id = UUID()
    var data: [HKData]
    var xName: String
    var yName: String
    var title: String
    
    var body: some View {
        Text(self.title)
            .font(.title3.bold())
        Chart {
            ForEach(data) { dataPoint in
                PointMark(
                    x: .value(self.xName, dataPoint.date.formatted(date: .numeric, time: .shortened)),
                    y: .value(self.yName, dataPoint.value)
                )
            }
        }
        .padding(.top, 15)
    }
    
    init(data: [HKData], xName: String, yName: String, title: String) {
        self.data = data
        self.xName = xName
        self.yName = yName
        self.title = title
    }
}

#Preview {
    HKVisualizationItem(
        data: [],
        xName: "Preview x axis",
        yName: "Preview y axis",
        title: "Preview Title"
    )
}
