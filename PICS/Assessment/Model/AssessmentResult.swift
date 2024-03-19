//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation


struct AssessmentResult: Codable, Identifiable {
    let id: UUID

    let testDateTime: Date
    let timeSpent: Double
    let errorCnt: Int?


    init(id: UUID = UUID(), testDateTime: Date, timeSpent: Double, errorCnt: Int? = nil) {
        // swiftlint:disable:previous function_default_parameter_at_end
        self.id = id
        self.testDateTime = testDateTime
        self.timeSpent = timeSpent
        self.errorCnt = errorCnt
    }
}
