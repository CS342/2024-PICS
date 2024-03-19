//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Charts
import SwiftUI

struct ResultsViz: View {
    let data: [AssessmentResult]
    let xName: LocalizedStringResource
    let yName: LocalizedStringResource
    let title: LocalizedStringResource

    // Vars for plotting.
    let metricType: LocalizedStringResource
    let metricEmpty: Bool // Whether we have result recorded for metric.
    let timeSpentLable: LocalizedStringResource = "ASSESSMENT_VIZ_TIME"

    let metricColor = Color.purple
    let timeColor = Color.teal
    let unSelectedColor = Color.gray
    
    // Vars to show detailed results.
    @State private var selectedElement: AssessmentResult?
    
    var body: some View {
        Text(title)
            .font(.title3.bold())
            .padding(5)
        
        // Helper text to show data when clicked or for the last result.
        let details = getResultDetails()
        if !details.isEmpty {
            Text(details)
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)
                .listRowSeparator(.hidden)
        }

        chart
    }
    
    private var chart: some View {
        Chart {
            ForEach(data) { dataPoint in
                // We assume that metric might be only one of error count or score.
                let selected = if let elm = self.selectedElement {
                    elm.testDateTime == dataPoint.testDateTime
                } else {
                    false
                }
                let yValue = if self.metricType == "ASSESSMENT_VIZ_SCORE" {
                    dataPoint.score
                } else {
                    dataPoint.errorCnt
                }
                if yValue >= 0 {
                    getLineMarker(time: dataPoint.testDateTime, selected: selected, yMark: self.metricType, yMetric: yValue)
                }
                
                getLineMarker(time: dataPoint.testDateTime, selected: selected, yMark: self.timeSpentLable, yTime: dataPoint.timeSpent)
            }
            .lineStyle(StrokeStyle(lineWidth: 2.0))
        }
        .chartForegroundStyleScale(
            self.metricEmpty
            // TODO: locale both lines
                ? [String(localized: self.timeSpentLable): self.timeColor]
                : [String(localized: self.timeSpentLable): self.timeColor, String(localized: self.metricType): self.metricColor]
        )
        .padding(10)
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 3))
        }
        // Use overlay to detect user's selection on marks.
        .chartOverlay { proxy in
            GeometryReader { geo in
                // The rectangle to detect user's clicked position and bar.
                Rectangle()
                    .fill(.clear)
                    .contentShape(Rectangle())
                    .gesture(
                        SpatialTapGesture()
                            .onEnded { value in
                                let element = findElement(location: value.location, proxy: proxy, geometry: geo)
                                if selectedElement?.testDateTime == element?.testDateTime {
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
    
    init(data: [AssessmentResult], xName: LocalizedStringResource, yName: LocalizedStringResource, title: LocalizedStringResource) {
        self.data = data
        self.xName = xName
        self.yName = yName
        self.title = title
        // We assume that we only need to plot one of error count or score.
        let errorCntMax = data.map(\.errorCnt).max() ?? -1
        let scoreMax = data.map(\.score).max() ?? -1
        self.metricType = errorCntMax == -1 ? "ASSESSMENT_VIZ_SCORE" : "ASSESSMENT_VIZ_ERRORCNT"
        self.metricEmpty = (max(scoreMax, errorCntMax) == -1)
    }

    private func findElement(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> AssessmentResult? {
        guard let proxyF = proxy.plotFrame else {
            print("Failed to get proxy plotframe")
            return nil
        }
        let relativeXPosition = location.x - geometry[proxyF].origin.x
        if let date = proxy.value(atX: relativeXPosition) as Date? {
            // Find the closest date element.
            var minDistance: TimeInterval = .infinity
            var index: Int?
            for dataIndex in data.indices {
                let nthDataDistance = data[dataIndex].testDateTime.distance(to: date)
                if abs(nthDataDistance) < minDistance {
                    minDistance = abs(nthDataDistance)
                     index = dataIndex
                }
            }
            if let index {
                return data[index]
            }
        }
        return nil
    }
    
    // Get the helper text for result to show. It should be
    // the selected or the last result if available.
    private func getResultDetails() -> String {
        var prefix = ""
        var elm: AssessmentResult
        if let elmSel = self.selectedElement {
            elm = elmSel
            prefix = String(localized: "ASSESSMENT_SUMMARY")
        } else if let elmLast = data.last {
            elm = elmLast
            prefix = String(localized: "ASSESSMENT_SUMMARY_LAST")
        } else {
            // No availabe element to show.
            return ""
        }

        // Round the time to 2 decimal points.
        let timeSpent = round(elm.timeSpent * 10) / 10
        let metricNum = if self.metricType == "ASSESSMENT_VIZ_SCORE" {
            elm.score
        } else {
            elm.errorCnt
        }
        let metricText = if metricNum < 0 {
            ""
        } else {
            ", " +
            String(localized: self.metricType) + // TODO: locale!
            ": " +
            String(metricNum)
        }
        return (
            prefix +
            String(elm.testDateTime.formatted(.dateTime.year().month().day())) +
            ":\n" +
            String(localized: self.timeSpentLable) + // TODO: locale
            ": " +
            String(timeSpent) +
            metricText
        )
    }
    
    // Build the line marker for time spent and metric.
    private func getLineMarker(
        time: Date,
        selected: Bool,
        yMark: LocalizedStringResource,
        yMetric: Int = -1,
        yTime: Double = 0
    ) -> some ChartContent {
        let markColor = if yMark == self.metricType {
            (self.selectedElement == nil) ? self.metricColor : self.unSelectedColor
        } else {
            (self.selectedElement == nil) ? self.timeColor : self.unSelectedColor
        }

        // TODO: are these actually drawn???
        let mark = if yMark == self.metricType {
            LineMark(
                // TODO: init of localiuzed string key??
                x: .value(.init(self.xName), time, unit: .second),
                y: .value(.init(self.metricType), yMetric),
                series: .value("Value", String(localized: self.metricType)) // TODO: locale
            )
            .foregroundStyle(markColor)
        } else {
            LineMark(
                x: .value(.init(self.xName), time, unit: .second),
                y: .value(.init(self.timeSpentLable), yTime),
                series: .value("Value", String(localized: self.timeSpentLable)) // TODO: locale
            )
            .foregroundStyle(markColor)
        }
        let highlightColor = if yMark == self.metricType {
            self.metricColor
        } else {
            self.timeColor
        }
       
        // Highlight the selection.
        return mark.symbol {
            if selected {
                Circle()
                    .strokeBorder(highlightColor, lineWidth: 2)
                    .background(Circle().foregroundColor(highlightColor))
                    .frame(width: 10)
            } else {
                Circle()
                    .strokeBorder(markColor, lineWidth: 2)
                    .frame(width: 5)
            }
        }
    }
}


#if DEBUG
#Preview {
    ResultsViz(data: [], xName: "preview xName", yName: "preview yName", title: "preview Title")
}
#endif
