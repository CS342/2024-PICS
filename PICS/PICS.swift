//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SpeziFirebaseAccount
import SwiftUI


@main
struct PICS: App {
    @UIApplicationDelegateAdaptor(PICSDelegate.self)
    private var appDelegate
    @AppStorage(StorageKeys.onboardingFlowComplete)
    private var completedOnboardingFlow = false

    @State var patientInformation = PatientInformation()

    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if completedOnboardingFlow {
                    HomeView()
                } else {
                    EmptyView()
                }
            }
                .sheet(isPresented: !$completedOnboardingFlow) {
                    OnboardingFlow()
                }
                .testingSetup()
                .spezi(appDelegate)
                .environment(patientInformation)
        }
    }
}
