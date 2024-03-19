//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SwiftUI
import UserNotifications


@Observable
class PatientInformation {
    @AppStorage("appt0")
    @ObservationIgnored private var _appt0Data: Date = .now
    @AppStorage("appt1")
    @ObservationIgnored private var _appt1Data: Date = .now
    @AppStorage("appt2")
    @ObservationIgnored private var _appt2Data: Date = .now

    @AppStorage("isSurveyCompleted")
    @ObservationIgnored private var _isSurveyCompleted = false

    @AppStorage("minimumStepCount")
    @ObservationIgnored private var _minimumStepCount: Int = 5000

    var appt0: Date {
        get {
            self.access(keyPath: \.appt0)
            return _appt0Data
        }
        set {
            self.withMutation(keyPath: \.appt0) {
                self._appt0Data = newValue
            }
        }
    }
    
    var appt1: Date {
        get {
            self.access(keyPath: \.appt1)
            return _appt1Data
        }
        set {
            self.withMutation(keyPath: \.appt1) {
                self._appt1Data = newValue
            }
        }
    }
    
    var appt2: Date {
        get {
            self.access(keyPath: \.appt2)
            return _appt2Data
        }
        set {
            self.withMutation(keyPath: \.appt2) {
                self._appt2Data = newValue
            }
        }
    }

    var isSurveyCompleted: Bool {
        get {
            self.access(keyPath: \.isSurveyCompleted)
            return _isSurveyCompleted
        }
        set {
            self.withMutation(keyPath: \.isSurveyCompleted) {
                self._isSurveyCompleted = newValue
            }
        }
    }

    var minimumStepCount: Int {
        get {
            self.access(keyPath: \.minimumStepCount)
            return _minimumStepCount
        }
        set {
            self.withMutation(keyPath: \.minimumStepCount) {
                self._minimumStepCount = newValue
            }
        }
    }

    func storeDates(_ date0: Date, _ date1: Date, _ date2: Date) {
        self.appt0 = date0
        self.appt1 = date1
        self.appt2 = date2
       
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
    
        scheduleNotifications(for: appt1, with: notificationCenter)
        scheduleNotifications(for: appt2, with: notificationCenter)
    }

    func scheduleNotifications(for date: Date, with notificationCenter: UNUserNotificationCenter) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let appointmentDateString = dateFormatter.string(from: date)
        
        let content = UNMutableNotificationContent()
        content.title = String(localized: "APPT_REMINDER")
        content.body = String(localized: "NOTIF_CONTENT") + appointmentDateString + String(localized: "PERIOD")
       
        _ = scheduleNotification(for: date, with: DateComponents(month: -1), content: content, notificationCenter: notificationCenter)
        
        _ = scheduleNotification(for: date, with: DateComponents(day: -7), content: content, notificationCenter: notificationCenter)
        
        _ = scheduleNotification(for: date, with: DateComponents(day: -3), content: content, notificationCenter: notificationCenter)
        
        _ = scheduleNotification(for: date, with: DateComponents(day: -1), content: content, notificationCenter: notificationCenter)
        
        _ = scheduleNotification(for: date, with: DateComponents(minute: -30), content: content, notificationCenter: notificationCenter)
        
        _ = scheduleNotification(for: date, with: nil, content: content, notificationCenter: notificationCenter)
    }
    
    
    func scheduleNotification(
        for date: Date,
        with components: DateComponents?,
        content: UNMutableNotificationContent,
        notificationCenter: UNUserNotificationCenter
    ) -> String {
        var notificationDate = date
        if let components = components, let scheduledDate = Calendar.current.date(byAdding: components, to: date) {
            notificationDate = scheduledDate
        }

        let trigger: UNNotificationTrigger
        if components != nil {
            trigger = UNCalendarNotificationTrigger(
                dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate),
                repeats: false
            )
        } else {
            let appointmentDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            trigger = UNCalendarNotificationTrigger(dateMatching: appointmentDateComponents, repeats: false)
        }
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        let identifier = request.identifier
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully for \(notificationDate)")
            }
        }
        
        return identifier
    }
}


extension Date: CodableRawRepresentable {
    var defaultJson: String {
        ""
    }
}
