//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziAccount
import SwiftUI


struct HomeView: View {
    enum Tabs: String {
        case appointments
        case schedule
        case contact
        case mockUpload
        case health
        case assessments
    }
    
    static var accountEnabled: Bool {
        !FeatureFlags.disableFirebase && !FeatureFlags.skipOnboarding
    }

    @Environment(PatientInformation.self)
    private var patientInformation

    @AppStorage(StorageKeys.homeTabSelection)
    private var selectedTab = Tabs.appointments

    @State private var presentingAccount = false

    
    var body: some View {
        TabView(selection: $selectedTab) {
            Appointments(presentingAccount: $presentingAccount)
                .tag(Tabs.appointments)
                .tabItem {
                    Label("APPOINTMENTS_TAB_TITLE", systemImage: "calendar")
                }
            ScheduleView(presentingAccount: $presentingAccount)
                .tag(Tabs.schedule)
                .tabItem {
                    Label("SCHEDULE_TAB_TITLE", systemImage: "list.clipboard")
                }
            Assessments(presentingAccount: $presentingAccount)
                .tag(Tabs.assessments)
                .tabItem {
                    Label("ASSESSMENTS_TAB_TITLE", systemImage: "pencil.circle.fill")
                }
            HKVisualization(presentingAccount: $presentingAccount)
                .tag(Tabs.health)
                .tabItem {
                    Label("HKVIZ_TAB_TITLE", systemImage: "heart")
                }
            Contacts(presentingAccount: $presentingAccount)
                .tag(Tabs.contact)
                .tabItem {
                    Label("CONTACTS_TAB_TITLE", systemImage: "person.fill")
                }
        }
            .sheet(isPresented: $presentingAccount) {
                AccountSheet()
            }
            .accountRequired(Self.accountEnabled) {
                AccountSheet()
            }
            .verifyRequiredAccountDetails(Self.accountEnabled)
    }
}


#if DEBUG
#Preview {
    let details = AccountDetails.Builder()
        .set(\.userId, value: "lelandstanford@stanford.edu")
        .set(\.name, value: PersonNameComponents(givenName: "Leland", familyName: "Stanford"))
    
    return HomeView()
        .previewWith(standard: PICSStandard()) {
            PICSScheduler()
            AccountConfiguration(building: details, active: MockUserIdPasswordAccountService())
        }
}
#endif
