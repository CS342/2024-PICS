//
//  AppointmentInformation.swift
//  PICS
//
//  Created by Akanshya Bhat on 2/29/24.
//

import Foundation
import SwiftUI

@Observable
class AppointmentInformation {
    @AppStorage("appt0") @ObservationIgnored private var _appt0Data: Data?
    @AppStorage("appt1") @ObservationIgnored private var _appt1Data: Data?
    @AppStorage("appt2") @ObservationIgnored private var _appt2Data: Data?
    
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
    }
}
