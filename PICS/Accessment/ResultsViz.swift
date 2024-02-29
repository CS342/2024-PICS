//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Charts
import SwiftUI

struct ResultsViz: View {
    var data: [AccessmentResult] = []
    var xName: String
    var yName: String
    var title: String
    
    var body: some View {
        Text(self.title)
            .font(.title3.bold())
        
        Chart {
            ForEach(data) { dataPoint in
                PointMark(
                    x: .value(self.xName, dataPoint.testDateTime, unit: .day),
                    y: .value(self.yName, dataPoint.timeSpent)
                )
                .foregroundStyle(.blue)
            }
            ForEach(data) { dataPoint in
                if dataPoint.errorCnt >= 0 {
                    PointMark(
                        x: .value(self.xName, dataPoint.testDateTime, unit: .day),
                        y: .value(self.yName, dataPoint.errorCnt)
                    )
                    .foregroundStyle(.purple)
                }
            }
        }
    }
    
    init(data: [AccessmentResult], xName: String, yName: String, title: String) {
        self.data = data
        self.xName = xName
        self.yName = yName
        self.title = title
    }
}

#Preview {
    ResultsViz(data: [], xName: "preview xName", yName: "preview yName", title: "preview Title")
}
