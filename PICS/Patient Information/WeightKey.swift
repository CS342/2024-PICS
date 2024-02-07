//
//  WeightKey.swift
//  PICS
//
//  Created by Catherine Zhang on 2/1/24.
//

import SpeziAccount
import SpeziViews
import SpeziFoundation
import SpeziValidation
import SwiftUI

/// The email address of a user.
public struct WeightKey: AccountKey {
    
    public typealias Value = Int

    public static let name: LocalizedStringResource = "Weight"

    public static let category: AccountKeyCategory = .personalDetails

}


extension AccountKeys {
    public var weight: WeightKey.Type {
        WeightKey.self
    }
}


extension AccountValues {
    public var weight: Int? {
        storage[WeightKey.self]
    }
}


// MARK: - UI
extension WeightKey {
    public struct DataDisplay: DataDisplayView {
        public typealias Key = WeightKey
        private let weight: Int
        public init(_ value: Int) {
            self.weight = value
        }
        public var body: some View {
            HStack {
                Text(WeightKey.name)
                Spacer()
                Text("\(weight) kg")
                    .foregroundColor(.secondary)
            }
            .accessibilityElement(children: .combine)
        }
    }
}
extension WeightKey {
    public struct DataEntry: DataEntryView {
        public typealias Key = WeightKey
        @Binding private var weight: Int
        public var body: some View {
            TextField("Weight", value:$weight, formatter: NumberFormatter())
        }
        public init(_ value: Binding<Int>) {
            self._weight = value
        }
    }
}

