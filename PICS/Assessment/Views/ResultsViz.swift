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
    private let task: AssessmentTask
    private let data: [AssessmentResult]

    @Environment(\.locale)
    private var locale

    private let hasErrorCountMetrics: Bool

    let metricColor = Color.purple
    let timeColor = Color.teal
    
    // Vars to show detailed results.
    @State private var selectedElement: AssessmentResult?
    
    var body: some View {
        Text(task.resultsTitle)
            .font(.title3)
            .bold()
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
                if let errorCnt = dataPoint.errorCnt {
                    LineMark(
                        x: .value("Time", dataPoint.testDateTime, unit: .second),
                        y: .value("Error Count", errorCnt),
                        series: .value("Measurement", String(localized: "Error Count", locale: locale))
                    )
                        .foregroundStyle(self.selectedElement == nil ? .purple : .gray)
                        .symbol {
                            lineMarkSymbol(data: dataPoint, strokeColor: .purple)
                        }
                }

                LineMark(
                    x: .value("Time", dataPoint.testDateTime, unit: .second),
                    y: .value("ASSESSMENT_VIZ_TIME", dataPoint.timeSpent),
                    series: .value("Measurement", String(localized: "ASSESSMENT_VIZ_TIME", locale: locale))
                )
                    .foregroundStyle(self.selectedElement == nil ? .teal : .gray)
                    .symbol {
                        lineMarkSymbol(data: dataPoint, strokeColor: .teal)
                    }
            }
                .lineStyle(StrokeStyle(lineWidth: 2.0))
        }
            .chartForegroundStyleScale(
                self.hasErrorCountMetrics
                ? [
                    String(localized: "ASSESSMENT_VIZ_TIME", locale: locale): self.timeColor,
                    String(localized: "Error Count", locale: locale): self.metricColor
                ]
                : [String(localized: "ASSESSMENT_VIZ_TIME", locale: locale): self.timeColor]
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
    
    init(task: AssessmentTask, data: [AssessmentResult]) {
        self.task = task
        self.data = data
        self.hasErrorCountMetrics = data.contains { $0.errorCnt != nil }
    }


    @ViewBuilder
    private func lineMarkSymbol(data: AssessmentResult, strokeColor: Color) -> some View {
        let isSelectedPoint = selectedElement?.testDateTime == data.testDateTime
        if isSelectedPoint {
            Circle()
                .strokeBorder(strokeColor, lineWidth: 2)
                .background(Circle().foregroundColor(strokeColor))
                .frame(width: 10)
        } else {
            Circle()
                .strokeBorder(selectedElement == nil ? strokeColor : .gray, lineWidth: 2)
                .frame(width: 5)
        }
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
            prefix = String(localized: "ASSESSMENT_SUMMARY", locale: locale)
        } else if let elmLast = data.last {
            elm = elmLast
            prefix = String(localized: "ASSESSMENT_SUMMARY_LAST", locale: locale)
        } else {
            // No available element to show.
            return ""
        }

        // Round the time to 2 decimal points.
        let timeSpent = round(elm.timeSpent * 10) / 10

        let metricText = if let errorCnt = elm.errorCnt {
            ", " +
            String(localized: "Error Count", locale: locale) +
            ": " +
            String(errorCnt)
        } else {
            ""
        }
        return (
            prefix +
            String(elm.testDateTime.formatted(.dateTime.year().month().day())) +
            ":\n" +
            String(localized: "ASSESSMENT_VIZ_TIME", locale: locale) +
            ": " +
            String(timeSpent) +
            metricText
        )
    }
}


#if DEBUG
#Preview {
    ResultsViz(task: .trailMaking, data: [
        AssessmentResult(
            testDateTime: .now.addingTimeInterval(-22),
            timeSpent: 5
        ),
        AssessmentResult(
            testDateTime: .now.addingTimeInterval(-12),
            timeSpent: 10,
            errorCnt: 2
        ),
        AssessmentResult(
            testDateTime: .now,
            timeSpent: 20,
            errorCnt: 1
        ),
        AssessmentResult(
            testDateTime: .now.addingTimeInterval(5),
            timeSpent: 17,
            errorCnt: 0
        )
    ])
}

#Preview {
    ResultsViz(task: .trailMaking, data: [
        AssessmentResult(
            testDateTime: .now.addingTimeInterval(5),
            timeSpent: 17
        )
    ])
}
#endif
