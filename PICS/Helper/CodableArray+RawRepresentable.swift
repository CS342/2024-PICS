//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import OSLog


protocol CodableRawRepresentable: RawRepresentable, Codable where RawValue == String {
    var defaultJson: String { get }
}

extension CodableRawRepresentable {
    private static var logger: Logger {
        Logger(subsystem: "de.charite.pics", category: "AppStorage")
    }

    /// Encode via JSON Encoder
    public var rawValue: String {
        let data: Data
        do {
            data = try JSONEncoder().encode(self)
        } catch {
            Self.logger.error("Failed to encode \(Self.self): \(error)")
            return defaultJson
        }

        guard let rawValue = String(data: data, encoding: .utf8) else {
            return defaultJson
        }
        return rawValue
    }

    /// Decode via JSON Decoder
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8) else {
            return nil
        }

        do {
            self = try JSONDecoder().decode(Self.self, from: data)
        } catch {
            Self.logger.error("Failed to decode \(Self.self): \(error)")
            return nil
        }
    }
}


extension Array: CodableRawRepresentable, RawRepresentable where Element: Codable {
    var defaultJson: String {
        "[]"
    }
}
