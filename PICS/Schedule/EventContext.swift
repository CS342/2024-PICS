//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziScheduler


//struct EventContext: Comparable, Identifiable {
//    let event: Event
//    let task: Task<PICSTaskContext>
//    
//    
//    var id: Event.ID {
//        event.id
//    }
//    
//    
//    static func < (lhs: EventContext, rhs: EventContext) -> Bool {
//        lhs.event.scheduledAt < rhs.event.scheduledAt
//    }
//}

struct EventContext: Comparable, Identifiable, Hashable {
    let event: Event
    let task: Task<PICSTaskContext>
    
    var id: Event.ID {
        event.id
    }
    
    static func < (lhs: EventContext, rhs: EventContext) -> Bool {
        lhs.event.scheduledAt < rhs.event.scheduledAt
    }

    static func == (lhs: EventContext, rhs: EventContext) -> Bool {
        lhs.event == rhs.event && lhs.task == rhs.task
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(event)
        hasher.combine(task)
    }
}
