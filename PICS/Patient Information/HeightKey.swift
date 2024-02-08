//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
import SpeziAccount
import SpeziFoundation
import SpeziValidation
import SpeziViews
import SwiftUI

/// The height of a user.
public struct HeightKey: AccountKey {
    public typealias Value = Int
    public static let name = LocalizedStringResource("HEIGHT")
    public static let category: AccountKeyCategory = .personalDetails
}


extension AccountKeys {
    /// this is the HeightKey of the user
    public var height: HeightKey.Type {
        HeightKey.self
    }
}


extension AccountValues {
    /// this is the value of the height to store
    public var height: Int? {
        storage[HeightKey.self]
    }
}


// MARK: - UI
extension HeightKey {
    public struct DataDisplay: DataDisplayView {
        public typealias Key = HeightKey
        private let height: Int
        public init(_ value: Int) {
            self.height = value
        }
        public var body: some View {
            HStack {
                Text(HeightKey.name)
                Spacer()
                Text("\(height) cm")
                    .foregroundColor(.secondary)
            }
            .accessibilityElement(children: .combine)
        }
    }
}
extension HeightKey {
    public struct DataEntry: DataEntryView {
        public typealias Key = HeightKey
        @Binding private var height: Int
        public var body: some View {
            HStack {
                    Text(HeightKey.name)
                    Spacer()
                    TextField("Height", value: $height, formatter: NumberFormatter())
                         .frame(width: 120) // set frame width to enable more spaces.
            }
        }
        public init(_ value: Binding<Int>) {
            self._height = value
        }
    }
}
