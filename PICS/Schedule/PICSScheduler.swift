//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SpeziScheduler


/// A `Scheduler` using the ``PICSTaskContext`` to schedule and manage tasks and events in the
/// PICS.
typealias PICSScheduler = Scheduler<PICSTaskContext>


extension PICSScheduler {
    static var PHQ4Task: SpeziScheduler.Task<PICSTaskContext> {
            let dateComponents: DateComponents
            if FeatureFlags.testSchedule {
                // Adds a task at the current time + 1 minute for UI testing
                dateComponents = DateComponents(
                    hour: Calendar.current.component(.hour, from: .now),
                    minute: Calendar.current.component(.minute, from: .now).addingReportingOverflow(1).partialValue
                )
            } else {
                // Schedule the task for every 2 weeks at 8:00 AM for normal app usage
                dateComponents = DateComponents(hour: 8, minute: 0)
            }

            return Task(
                title: String(localized: "PHQ-4_TITLE"),
                description: String(localized: "PHQ-4_DESCRIPTION"),
                schedule: Schedule(
                    start: Calendar.current.startOfDay(for: Date()),
                    repetition: .matching(dateComponents),
                    end: .numberOfEvents(26)
                ),
                notifications: true,
                context: PICSTaskContext.questionnaire(Bundle.main.questionnaire(withName: "PHQ-4"))
            )
        }
    
    static var EQ5D5LTask: SpeziScheduler.Task<PICSTaskContext> {
        let dateComponents: DateComponents
        if FeatureFlags.testSchedule {
            // Adds a task at the current time for UI testing if the `--testSchedule` feature flag is set
            dateComponents = DateComponents(
                hour: Calendar.current.component(.hour, from: .now),
                minute: Calendar.current.component(.minute, from: .now)
            )
        } else {
            // For the normal app usage, we schedule the task for every 2 weeks at 8:05 AM
            dateComponents = DateComponents(hour: 8, minute: 5)
        }

        return Task(
            title: String(localized: "EQ5D5L_TITLE"),
            description: String(localized: "EQ5D5L_DESCRIPTION"),
            schedule: Schedule(
                start: Calendar.current.startOfDay(for: Date()),
                repetition: .matching(dateComponents),
                end: .numberOfEvents(26)
            ),
            notifications: true,
            context: PICSTaskContext.questionnaire(Bundle.main.questionnaire(withName: "EQ5D5L"))
        )
    }
    
    static var MiniNutritionalTask: SpeziScheduler.Task<PICSTaskContext> {
        let dateComponents: DateComponents
        if FeatureFlags.testSchedule {
            // Adds a task at the current time for UI testing if the `--testSchedule` feature flag is set
            dateComponents = DateComponents(
                hour: Calendar.current.component(.hour, from: .now),
                minute: Calendar.current.component(.minute, from: .now)
            )
        } else {
            // For the normal app usage we schedule the task for every 2 weeks at 8:10 AM
            dateComponents = DateComponents(hour: 8, minute: 10)
        }

        return Task(
            title: String(localized: "MiniNutritional_TITLE"),
            description: String(localized: "MiniNutritional_DESCRIPTION"),
            schedule: Schedule(
                start: Calendar.current.startOfDay(for: Date()),
                repetition: .matching(dateComponents),
                end: .numberOfEvents(26)
            ),
            notifications: true,
            context: PICSTaskContext.questionnaire(Bundle.main.questionnaire(withName: "Self-MNA"))
        )
    }

    /// Creates a default instance of the ``PICSScheduler`` by scheduling the tasks listed below.
    convenience init() {
        self.init(tasks: [Self.PHQ4Task, Self.EQ5D5LTask, Self.MiniNutritionalTask])
    }
}
