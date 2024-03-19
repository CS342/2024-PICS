//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import OrderedCollections
import SpeziAccount
import SpeziQuestionnaire
import SpeziScheduler
import SwiftUI


struct ScheduleView: View {
    @Environment(PICSStandard.self)
    private var standard
    @Environment(PICSScheduler.self)
    private var scheduler
    @Environment(PatientInformation.self)
    private var patientInformation

    @Environment(\.scenePhase)
    private var scenePhase

    @State private var presentedContext: EventContext?
    @Binding private var presentingAccount: Bool


    private var eventContextsByDate: OrderedDictionary<Date, [EventContext]> {
        let eventContexts = scheduler.tasks.flatMap { task in
            task
                .events(
                    from: Calendar.current.startOfDay(for: .now),
                    to: .numberOfEventsOrEndDate(100, .now)
                )
                .map { event in
                    EventContext(event: event, task: task)
                }
        }
            .sorted()

        return OrderedDictionary(grouping: eventContexts) { eventContext in
            Calendar.current.startOfDay(for: eventContext.event.scheduledAt)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                if !patientInformation.isSurveyCompleted {
                    Section("Personal Information") {
                        OnboardingSurveyView()
                    }
                }

                let eventContextsByDate = eventContextsByDate

                ForEach(eventContextsByDate.keys, id: \.timeIntervalSinceNow) { startOfDay in
                    Section(format(startOfDay: startOfDay)) {
                        ForEach(eventContextsByDate[startOfDay] ?? [], id: \.event) { eventContext in
                            EventContextView(eventContext: eventContext)
                                .onTapGesture {
                                    if !eventContext.event.complete {
                                        presentedContext = eventContext
                                    }
                                }
                        }
                    }
                }
            }
            .sheet(item: $presentedContext) { presentedContext in
                destination(withContext: presentedContext)
            }
            .toolbar {
                if AccountButton.shouldDisplay {
                    AccountButton(isPresented: $presentingAccount)
                }
            }
            .navigationTitle("SCHEDULE_LIST_TITLE")
        }
    }
    
    
    init(presentingAccount: Binding<Bool>) {
        self._presentingAccount = presentingAccount
    }
    
    private func destination(withContext eventContext: EventContext) -> some View {
        @ViewBuilder var destination: some View {
            switch eventContext.task.context {
            case let .questionnaire(questionnaire):
                QuestionnaireView(questionnaire: questionnaire) { result in
                    presentedContext = nil

                    guard case let .completed(response) = result else {
                        return // user cancelled the task
                    }

                    eventContext.event.complete(true)
                    await standard.add(response: response)
                }
            case let .test(string):
                ModalView(text: string, buttonText: String(localized: "CLOSE")) {
                    await eventContext.event.complete(true)
                }
            }
        }
        return destination
    }
    
    
    private func format(startOfDay: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: startOfDay)
    }
}


#if DEBUG
#Preview("ScheduleView") {
    ScheduleView(presentingAccount: .constant(false))
        .environment(PatientInformation())
        .previewWith(standard: PICSStandard()) {
            PICSScheduler()
            AccountConfiguration {
                MockUserIdPasswordAccountService()
            }
        }
}
#endif
