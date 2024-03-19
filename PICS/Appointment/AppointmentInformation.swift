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
class AppointmentInformation {
    @AppStorage("appt0") @ObservationIgnored
    private var _appt0Data: Data?
    @AppStorage("appt1") @ObservationIgnored
    private var _appt1Data: Data?
    @AppStorage("appt2") @ObservationIgnored
    private var _appt2Data: Data?

    var appt0Data: Data? {
        get {
            self.access(keyPath: \.appt0Data)
            return _appt0Data
        }
        set {
            self.withMutation(keyPath: \.appt0Data) {
                self._appt0Data = newValue
            }
        }
    }
    
    var appt1Data: Data? {
        get {
            self.access(keyPath: \.appt1Data)
            return _appt1Data
        }
        set {
            self.withMutation(keyPath: \.appt1Data) {
                self._appt1Data = newValue
            }
        }
    }
    
    var appt2Data: Data? {
        get {
            self.access(keyPath: \.appt2Data)
            return _appt2Data
        }
        set {
            self.withMutation(keyPath: \.appt2Data) {
                self._appt2Data = newValue
            }
        }
    }
    
    var appt0: Date {
        let decoder = JSONDecoder()
        if let appt0Data, let decodedAppt0 = try? decoder.decode(Date.self, from: appt0Data) {
            return decodedAppt0
        }
        return Date()
    }
    
    var appt1: Date {
        let decoder = JSONDecoder()
        if let appt1Data, let decodedAppt1 = try? decoder.decode(Date.self, from: appt1Data) {
            return decodedAppt1
        }
        return Date()
    }
    
    var appt2: Date {
        let decoder = JSONDecoder()
        if let appt2Data, let decodedAppt2 = try? decoder.decode(Date.self, from: appt2Data) {
            return decodedAppt2
        }
        return Date()
    }
    
    func storeDates(_ date0: Date, _ date1: Date, _ date2: Date) {
        appt1Data = try? JSONEncoder().encode(date0)
        appt1Data = try? JSONEncoder().encode(date1)
        appt2Data = try? JSONEncoder().encode(date2)
       
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
