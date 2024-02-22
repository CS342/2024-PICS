//
// This source file is part of the PICS to show patients' health data.
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
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
    var chartType: String
    var ymin: Double
    var ymax: Double
    var threshold: Double = -1.0
    var helperText = ""
    var plotAvg = false
    var scatterData: [HKData] = []
    
    var body: some View {
        Text(self.title)
            .font(.title3.bold())
            // Remove line below text.
            .listRowSeparator(.hidden)
        if !self.helperText.isEmpty {
            Text(self.helperText)
                .font(.caption)
                .listRowSeparator(.hidden)
        }
        Chart {
            ForEach(scatterData) { dataPoint in
                PointMark(
                    x: .value(self.xName, dataPoint.date, unit: .day),
                    y: .value(self.yName, dataPoint.sumValue)
                )
                .foregroundStyle(((self.threshold > 0 && dataPoint.sumValue > self.threshold) ? Color.blue : Color.accentColor).opacity(0.2))
            }
            ForEach(data) { dataPoint in
                BarMark(
                    x: .value(self.xName, dataPoint.date, unit: .day),
                    y: .value(self.yName, dataPoint.sumValue),
                    width: .fixed(10)
                )
                .foregroundStyle(dataPoint.sumValue > self.threshold ? Color.blue : Color.accentColor)
                if self.plotAvg {
                    LineMark(
                        x: .value(self.xName, dataPoint.date, unit: .day),
                        y: .value(self.yName, dataPoint.avgValue)
                    )
                    .foregroundStyle(.purple)
                    .lineStyle(StrokeStyle(lineWidth: 2))
                }
            }
            if self.threshold > 0 {
                RuleMark(
                    y: .value("Threshold", self.threshold)
                )
                .foregroundStyle(.black)
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
            }
        }
        .padding(.top, 10)
        .chartYScale(domain: self.ymin...self.ymax)
        .chartXAxis {
            AxisMarks(values: .stride(by: .day, count: 3))
        }
    }
    
    init(
        data: [HKData],
        xName: String,
        yName: String,
        title: String,
        chartType: String,
        threshold: Double = -1.0,
        helperText: String = "",
        scatterData: [HKData] = []
    ) {
        self.data = data
        self.xName = xName
        self.yName = yName
        self.title = title
        self.chartType = chartType
        self.threshold = threshold
        self.helperText = helperText
        // Find max and min for y range.
        self.ymax = data.map(\.maxValue).max() ?? 0
        // For step data, we only have sum values.
        self.ymax = max(self.ymax, data.map(\.sumValue).max() ?? 0)
        self.ymin = data.map(\.minValue).min() ?? 0
        // Plot average data if we have such data.
        self.plotAvg = data.map(\.avgValue).max() ?? 0 > 0
        self.scatterData = scatterData
    }
}

#Preview {
    HKVisualizationItem(
        data: [],
        xName: "Preview x axis",
        yName: "Preview y axis",
        title: "Preview Title",
        chartType: "PointMark"
    )
}
