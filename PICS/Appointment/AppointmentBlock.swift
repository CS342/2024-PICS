//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//
import Foundation
import SwiftUI

struct Item: Identifiable, Hashable {
    let id = UUID()
    let name: LocalizedStringResource

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name.key)
    }
}

struct AppointmentBlock: View {
    private let date: Date

    private let items = [
        Item(name: "REQUIRED_ITEMS_1"),
        Item(name: "REQUIRED_ITEMS_2"),
        Item(name: "REQUIRED_ITEMS_3"),
        Item(name: "REQUIRED_ITEMS_4"),
        Item(name: "REQUIRED_ITEMS_5"),
        Item(name: "REQUIRED_ITEMS_6"),
        Item(name: "REQUIRED_ITEMS_7")
    ]
    
    @State private var multiSelection = Set<UUID>()
    @State private var showingSheet = false

    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .leading) {
                HStack {
                    Text(formattedDate(date))
                        .foregroundColor(.primary)
                        .bold()
                    Spacer()
                    Text(formattedTime(date))
                        .foregroundColor(.primary)
                }
                HStack {
                    Spacer()
                    Button("REQUIRED_ITEMS_HEADING") {
                        showingSheet.toggle()
                    }
                        .foregroundColor(.accentColor)
                        .buttonStyle(.plain)
                }
                    .padding(.top, 6)
            }
        }
            .padding(.vertical, 8)
            .sheet(isPresented: $showingSheet) {
                NavigationStack {
                    List(items, selection: $multiSelection) {
                        Text($0.name)
                    }
                        .navigationTitle("REQUIRED_ITEMS_HEADING")
                        .environment(\.editMode, .constant(.active))
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("CLOSE") {
                                    showingSheet.toggle()
                                }
                            }
                        }
                }
            }
    }

    init(date: Date) {
        self.date = date
    }


    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter.string(from: date)
    }

    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}


#if DEBUG
#Preview {
    List {
        AppointmentBlock(date: .now.addingTimeInterval(60 * 60))
    }
}
#endif
