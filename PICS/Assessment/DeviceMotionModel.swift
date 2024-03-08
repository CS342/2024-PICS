//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation

struct DeviceMotionItem: Decodable {
    let timestamp: TimeInterval
}

struct DeviceMotion: Decodable {
    let items: [DeviceMotionItem]
}
