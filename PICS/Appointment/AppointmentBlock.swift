//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
import Foundation
import SwiftUI

struct Item: Identifiable, Hashable {
    let name: String
    let id = UUID()
}

struct AppointmentBlock: View {
    var date: String
    var time: String
    var items = [
        Item(name: String(localized: "REQUIRED_ITEMS_1")),
        Item(name: String(localized: "REQUIRED_ITEMS_2")),
        Item(name: String(localized: "REQUIRED_ITEMS_3")),
        Item(name: String(localized: "REQUIRED_ITEMS_4")),
        Item(name: String(localized: "REQUIRED_ITEMS_5")),
        Item(name: String(localized: "REQUIRED_ITEMS_6")),
        Item(name: String(localized: "REQUIRED_ITEMS_7"))
    ]
    
    @State private var multiSelection = Set<UUID>()
    @State private var showingSheet = false

    var body: some View {
        Color.white
            .frame(height: 130)
            .cornerRadius(15)
            .overlay(
                VStack(alignment: .leading) {
                    Spacer()
                    VStack(alignment: .leading) {
                        HStack {
                            Text(date)
                                .foregroundColor(.black)
                                .bold()
                            Spacer()
                            Text(time)
                                .foregroundColor(.black)
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: reschedule) {
                                Text(String(localized: "RESCHEDULE_BUTTON_LABEL"))
                            }
                        }
                        HStack {
                            Spacer()
                            Button(String(localized: "REQUIRED_ITEMS_HEADING")) {
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
                        .navigationTitle(String(localized: "REQUIRED_ITEMS_HEADING"))
                        .environment(\.editMode, .constant(.active))
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(String(localized: "CLOSE")) {
                                    showingSheet.toggle()
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                }
            )
    }
    
    func reschedule() {
    }
}
