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
    
    // Variables for lollipops.
    let lollipopColor: Color = .indigo

    @State private var selectedElement: HKData?
    
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
        // Helper text to show data when clicked.
        if let elm = selectedElement, elm.sumValue == 0 {
            let details = (
                String(localized: "HKVIZ_SUMMARY") +
                String(elm.date.formatted(.dateTime.year().month().day())) +
                ":\n" +
                String(localized: "HKVIZ_AVERAGE_STRING") +
                String(round(elm.avgValue * 10) / 10) +
                ", " +
                String(localized: "HKVIZ_MAX_STRING") +
                String(Int(round(elm.maxValue))) +
                ", " +
                String(localized: "HKVIZ_MIN_STRING") +
                String(Int(round(elm.minValue)))
            )
            Text(details)
                .font(.footnote)
                .listRowSeparator(.hidden)
        }
        chart
    }
    
    private var chart: some View {
        Chart {
            ForEach(scatterData) { dataPoint in
                PointMark(
                    x: .value(self.xName, dataPoint.date, unit: .day),
                    y: .value(self.yName, dataPoint.sumValue)
                )
                .foregroundStyle(getBarColor(value: dataPoint.sumValue, date: dataPoint.date).opacity(0.2))
            }
            ForEach(data) { dataPoint in
                BarMark(
                    x: .value(self.xName, dataPoint.date, unit: .day),
                    y: .value(self.yName, dataPoint.sumValue),
                    width: .fixed(10)
                )
                .foregroundStyle(getBarColor(value: dataPoint.sumValue, date: dataPoint.date))
                if self.plotAvg {
                    LineMark(
                        x: .value(self.xName, dataPoint.date, unit: .day),
                        y: .value(self.yName, dataPoint.avgValue)
                    )
                    .foregroundStyle(selectedElement != nil ? Color.gray : Color.purple)
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
            AxisMarks(values: .stride(by: .day, count: 4))
        }
        // For the lollipops, click on data to show details.
        .chartOverlay { proxy in
            GeometryReader { geo in
                if let selectedElement,
                   selectedElement.sumValue > 0,
                   let proxyF = proxy.plotFrame,
                   let dateInterval = Calendar.current.dateInterval(of: .day, for: selectedElement.date) {
                    // Build the lollipop contents.
                    let startPositionX1 = proxy.position(forX: dateInterval.start) ?? 0
                    let endPositionX1 = proxy.position(forX: dateInterval.end) ?? 0
                    let lineX = (startPositionX1 + endPositionX1) / 2 + geo[proxyF].origin.x
                    let lineHeight = geo[proxyF].maxY
                    let geoSizeWidth = geo.size.width
                    getLollipop(lineX: lineX, lineHeight: lineHeight, geoSizeWidth: geoSizeWidth, elm: selectedElement)
                }
                // The rectangle to detect user's clicked position and bar.
                Rectangle()
                    .fill(.clear)
                    .contentShape(Rectangle())
                    .gesture(
                        SpatialTapGesture()
                            .onEnded { value in
                                let element = findElement(location: value.location, proxy: proxy, geometry: geo)
                                if selectedElement?.date == element?.date {
                                    // If tapping the same element, clear the selection.
                                    selectedElement = nil
                                } else {
                                    selectedElement = element
                                }
                            }
                            .exclusively(
                                before: DragGesture()
                                    .onChanged { value in
                                        selectedElement = findElement(location: value.location, proxy: proxy, geometry: geo)
                                    }
                            )
                    )
            }
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
    
    func getBarColor(value: Double, date: Date) -> Color {
        let calendar = Calendar.current
        return if let elm = selectedElement {
            if calendar.component(.day, from: date) == calendar.component(.day, from: elm.date) {
                // Highlight the clicked element with purple.
                .indigo
            } else {
                .gray
            }
        } else if self.threshold > 0 && value > self.threshold {
            .blue
        } else {
            .accentColor
        }
    }
    
    @ViewBuilder
    func getLollipop(lineX: CGFloat, lineHeight: CGFloat, geoSizeWidth: CGFloat, elm: HKData) -> some View {
        let lollipopBoxWidth: CGFloat = if elm.sumValue > 0 {
            100
        } else {
            200
        }
        let boxOffset = max(0, min(geoSizeWidth - lollipopBoxWidth, lineX - lollipopBoxWidth / 2))
        
        Rectangle()
            .fill(lollipopColor)
            .frame(width: 2, height: lineHeight)
            .position(x: lineX, y: lineHeight / 2)
        
        VStack(alignment: .center) {
            Text("\(elm.date, format: .dateTime.year().month().day())")
                .font(.callout)
                .foregroundStyle(.secondary)
            Text("\(elm.sumValue, format: .number)")
                    .font(.title2.bold())
                    .foregroundColor(.primary)
        }
        .accessibilityElement(children: .combine)
        .frame(width: lollipopBoxWidth, alignment: .center)
        .background(Color.gray.brightness(0.4))
        .cornerRadius(5)
        .offset(x: boxOffset)
    }
    
    private func findElement(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> HKData? {
        guard let proxyF = proxy.plotFrame else {
            print("Failed to get proxy plotframe")
            return nil
        }
        let relativeXPosition = location.x - geometry[proxyF].origin.x
        if let date = proxy.value(atX: relativeXPosition) as Date? {
            // Find the closest date element.
            var minDistance: TimeInterval = .infinity
            var index: Int?
            for HKDataIndex in data.indices {
                let nthHKDataDistance = data[HKDataIndex].date.distance(to: date)
                if abs(nthHKDataDistance) < minDistance {
                    minDistance = abs(nthHKDataDistance)
                     index = HKDataIndex
                }
            }
            if let index {
                return data[index]
            }
        }
        return nil
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
