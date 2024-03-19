//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziScheduler
import SwiftUI


struct EventContextView: View {
    let eventContext: EventContext
    
    var body: some View {
        HStack {
            eventDetailsStack
        }
        .disabled(eventContext.event.complete)
        .contentShape(Rectangle())
    }
    
    private var eventDetailsStack: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) { // Align items to top
                statusIcon
                    .padding(.top, 5) // Adjust padding to align with the first line of text if needed
                titleAndDateStack
            }
            Divider()
            if !eventContext.event.complete {
                descriptionText
                    .multilineTextAlignment(.leading)
            } else {
                completedText
            }
            if !eventContext.event.complete {
                actionTypeText
            }
        }
    }
    
    private var statusIcon: some View {
        Group {
            if eventContext.event.complete {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 30))
                    .accessibilityHidden(true)
            } else {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(.yellow)
                    .font(.system(size: 30))
                    .accessibilityHidden(true)
            }
        }
    }
    
    private var titleAndDateStack: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(verbatim: eventContext.task.title)
                .font(.headline)
                .accessibilityLabel(
                    eventContext.event.complete
                        ? "COMPLETED_TASK_LABEL \(eventContext.task.title)"
                        : "TASK_LABEL \(eventContext.task.title)"
                )
            Text(verbatim: format(eventDate: eventContext.event.scheduledAt))
                .font(.subheadline)
        }
    }
    
    private var descriptionText: some View {
        Text(eventContext.task.description)
            .font(.callout)
    }
    
    private var completedText: some View {
        Text("This task has been completed!")
            .font(.callout)
    }
    
    private var actionTypeText: some View {
        Text(eventContext.task.context.actionType)
            .frame(maxWidth: .infinity, minHeight: 50)
            .foregroundColor(.white)
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.top, 8)
    }
    
    private func format(eventDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: eventDate)
    }
}

#if DEBUG
struct EventContextView_Previews: PreviewProvider {
    static var previews: some View {
        let task = PICSScheduler.PHQ4Task
        
        EventContextView(
            eventContext: EventContext(
                // We use a force unwrap in the preview as we can not recover from an error here
                // and the code will never end up in a production environment.
                // swiftlint:disable:next force_unwrapping
                event: task.events(from: .now.addingTimeInterval(-60 * 60 * 24)).first!,
                task: task
            )
        )
        .padding()
    }
}
#endif
