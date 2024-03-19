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
    private static var baseDateComponent: DateComponents {
        let weekday = Calendar.current.component(.weekday, from: .now)

        let dateComponents: DateComponents
        if FeatureFlags.testSchedule {
            dateComponents = DateComponents(
                hour: Calendar.current.component(.hour, from: .now),
                minute: Calendar.current.component(.minute, from: .now)
            )
        } else {
            // Schedule the task for every 2 weeks at 8:00 AM for normal app usage
            dateComponents = DateComponents(hour: 8, minute: 0, weekday: weekday)
        }

        return dateComponents
    }

    private static let repetitions = 6 * 4

    static var PHQ4Task: SpeziScheduler.Task<PICSTaskContext> {
        let dateComponents = baseDateComponent

        return Task(
            title: String(localized: "PHQ-4_TITLE"),
            description: String(localized: "PHQ-4_DESCRIPTION"),
            schedule: Schedule(
                start: Calendar.current.startOfDay(for: Date()),
                repetition: .matching(dateComponents),
                end: .numberOfEvents(repetitions)
            ),
            notifications: true,
            context: PICSTaskContext.questionnaire(Bundle.main.questionnaire(withName: "PHQ-4"))
        )
    }
    
    static var EQ5D5LTask: SpeziScheduler.Task<PICSTaskContext> {
        var dateComponents = baseDateComponent
        dateComponents.second = 1

        return Task(
            title: String(localized: "EQ5D5L_TITLE"),
            description: String(localized: "EQ5D5L_DESCRIPTION"),
            schedule: Schedule(
                start: Calendar.current.startOfDay(for: .now),
                repetition: .matching(dateComponents),
                end: .numberOfEvents(repetitions)
            ),
            notifications: true,
            context: PICSTaskContext.questionnaire(Bundle.main.questionnaire(withName: "EQ5D5L"))
        )
    }
    
    static var MiniNutritionalTask: SpeziScheduler.Task<PICSTaskContext> {
        var dateComponents = baseDateComponent
        dateComponents.second = 2

        return Task(
            title: String(localized: "MiniNutritional_TITLE"),
            description: String(localized: "MiniNutritional_DESCRIPTION"),
            schedule: Schedule(
                start: Calendar.current.startOfDay(for: .now),
                repetition: .matching(dateComponents),
                end: .numberOfEvents(repetitions)
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
