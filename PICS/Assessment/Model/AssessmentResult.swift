//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation


struct AssessmentResult: Codable, Identifiable {
    var id = UUID()

    var testDateTime: Date
    var timeSpent: Double
    var errorCnt: Int = -1
    // Score that might be collected for MiniCog.
    var score: Int = -1 // TODO: used?
}
