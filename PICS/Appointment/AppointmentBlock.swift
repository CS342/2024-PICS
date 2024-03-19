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
    var date: String
    var time: String
    var items = [
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
    
    @Environment(PatientInformation.self)
    private var patientInformation

    var body: some View {
        Color(UIColor.secondarySystemBackground)
            .frame(height: 130)
            .cornerRadius(15)
            .overlay(
                VStack(alignment: .leading) {
                    Spacer()
                    VStack(alignment: .leading) {
                        HStack {
                            Text(date)
                                .foregroundColor(.primary)
                                .bold()
                            Spacer()
                            Text(time)
                                .foregroundColor(.primary)
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            Button("REQUIRED_ITEMS_HEADING") {
                                showingSheet.toggle()
                            }
                            .buttonStyle(.bordered)
                        }
                        Spacer()
                    }
                    .padding()
                }
                .sheet(isPresented: $showingSheet) {
                    NavigationView {
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
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                }
            )
    }
}
