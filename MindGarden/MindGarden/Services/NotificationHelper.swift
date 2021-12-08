//
//  NotificationHelper.swift
//  MindGarden
//
//  Created by Dante Kim on 10/25/21.
//

import Foundation
import SwiftUI

struct NotificationHelper {
    static func addOneDay() {
        let content = UNMutableNotificationContent()
        content.title = "Don't Break Your Streak!"
        content.body = "Tend to your garden by meditating."
        content.sound = UNNotificationSound.default
        let hour = Calendar.current.component( .hour, from:Date() )
        var modifiedDate = Calendar.current.date(byAdding: .hour, value: 36, to: Date())
        if hour < 11 {
            modifiedDate = Calendar.current.date(byAdding: .hour, value: 26, to: Date())
        }
        else if hour < 16 {
            modifiedDate = Calendar.current.date(byAdding: .hour, value: 24, to: Date())
        }
        else {
            modifiedDate = Calendar.current.date(byAdding: .hour, value: 36, to: Date())
        }
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: modifiedDate ?? Date())

        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: true)
        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content, trigger: trigger)
        UserDefaults.standard.setValue(uuidString, forKey: "oneDayNotif")
        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
              // Handle any errors.
           }
        }
    }

    static func addThreeDay() {
        let content = UNMutableNotificationContent()
        content.title = "The best time to plant a tree was 20 years ago."
        content.body = "The second best time is right now."
        content.sound = UNNotificationSound.default

        let modifiedDate = Calendar.current.date(byAdding: .day, value: 3, to: Date())
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: modifiedDate ?? Date())

        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: true)
        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content, trigger: trigger)
        UserDefaults.standard.setValue(uuidString, forKey: "threeDayNotif")
        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
              // Handle any errors.
           }
        }
    }
}
