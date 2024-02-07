//
//  HeightKey.swift
//  PICS
//
//  Created by Catherine Zhang on 1/30/24.
//
import SpeziAccount
import SpeziViews
import SpeziFoundation
import SpeziValidation
import SwiftUI

/// The email address of a user.
public struct HeightKey: AccountKey {
    
    public typealias Value = Int

    public static let name: LocalizedStringResource = "Height"

    public static let category: AccountKeyCategory = .personalDetails

}


extension AccountKeys {
    public var height: HeightKey.Type {
        HeightKey.self
    }
}


extension AccountValues {
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
            TextField("Height", value:$height, formatter: NumberFormatter())
        }
        public init(_ value: Binding<Int>) {
            self._height = value
        }
    }
}
