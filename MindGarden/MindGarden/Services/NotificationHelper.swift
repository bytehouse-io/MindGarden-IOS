//
//  NotificationHelper.swift
//  MindGarden
//
//  Created by Dante Kim on 10/25/21.
//

import Foundation
import SwiftUI

struct NotificationHelper {
    static var gratitudes = ["Be thankful for what you have; you'll end up having more.", "As we express our gratitude, we must never forget that the highest appreciation is not to utter words, but to live by them. - JFK", "“This is a wonderful day I have never seen this one before.” - Maya Angelou"]
    static var breathing = ["Exhale & let go.", "Just breathing can be such a luxury at times.", "You’re alive and breathing. That’s a fine reason to celebrate. – Johnny Lung"]
    static var smiling = ["Life is short. Smile while you have teeth", "“Let us always meet each other with smile, for the smile is the beginning of love.” — Mother Teresa", "¨The source of a true smile is an awakened mind.¨- Thich Nhat Hanh"]
    static var loving = ["Everyone is fighting their own battles. Do your part & show some love", "To love is to recognize yourself in another. - Eckhart Tolle", "There is only one happiness in this life, to love and be loved. - George Sand"]
    static var present = ["Do not ruin today by mourning tomorrow. Live right now.",  "If you want to conquer the anxiety of life, live in the moment, live in the breath. - Amit Ray", "I have realized that the past and future are real illusions, that they exist in the present, which is what there is and all there is. - Alan Watts."]
    
    static func addOneDay() {
        let content = UNMutableNotificationContent()
        if UserDefaults.standard.integer(forKey: "numMeds") >= 1 {
            if UserDefaults.standard.integer(forKey: "longestStreak") > 1 {
                content.title = "\(UserDefaults.standard.string(forKey: "name") ?? "") Don't Break Your Streak!"
                switch UserDefaults.standard.string(forKey: "reason") {
                case "Sleep better":
                    content.body = "Sleeping better starts tonight"
                case "Get more focused":
                    content.body = "Let's train and increase focus"
                case "Managing Stress & Anxiety":
                    content.body = "Let's train and prevent anxiety"
                case "Just trying it out":
                    content.body = "Tend to your garden by meditating."
                default:
                    content.body = "Tend to your garden by meditating."
                }
            } else {
                content.title = "\(UserDefaults.standard.string(forKey: "name") ?? ""), start your meditation journey today"
                content.body = "😔 We get it, meditation is hard but remember, it's the mental gym for your brain 💪"
            }
 
        } else {
            content.title = "🌱\(UserDefaults.standard.string(forKey: "name") ?? "") start your first session"
            content.body = "\"The best time to plant a tree was 20 years ago. The second best time is now.\""
        }

        // 1 = 1 AM
        // 10 = 10AM
        // 14 = 2PM
        // 18: 6PM
        // 19:55 = 7:55PM
        // 20 = 8PM
        content.sound = UNNotificationSound.default
        let hour = Calendar.current.component( .hour, from:Date() )
        var modifiedDate = Calendar.current.date(byAdding: .hour, value: 36, to: Date())
        if UserDefaults.standard.integer(forKey: "numMeds") < 1 {
            if hour < 18 {
                modifiedDate = Calendar.current.date(byAdding: .hour, value: 4, to: Date())
            } else if hour > 20 {
                modifiedDate = Calendar.current.date(byAdding: .hour, value: 12, to: Date())
            } else {
                modifiedDate = Calendar.current.date(byAdding: .hour, value: 2, to: Date())
            }
        } else {
            if hour < 11 {
                modifiedDate = Calendar.current.date(byAdding: .hour, value: 30, to: Date())
            } else if hour < 16 {
                modifiedDate = Calendar.current.date(byAdding: .hour, value: 26, to: Date())
            } else if hour < 20 {
                modifiedDate = Calendar.current.date(byAdding: .hour, value: 20, to: Date())
            } else {
                modifiedDate = Calendar.current.date(byAdding: .hour, value: 18, to: Date())
            }
        }
       
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: modifiedDate ?? Date())

        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: true)
        // Create the request
        let id = "oneDay"
        let request = UNNotificationRequest(identifier: id,
                    content: content, trigger: trigger)
        UserDefaults.standard.setValue(id, forKey: "oneDayNotif")
        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
              // Handle any errors.
           }
        }
    }
    
    static func addOnboarding() {
        let content = UNMutableNotificationContent()
        content.title = ""
        content.body = ""
        content.sound = UNNotificationSound.default
        
        let hour = Calendar.current.component( .hour, from:Date() )
        var modifiedDate = Calendar.current.date(byAdding: .hour, value: 6, to: Date())
        
        // 1 = 1 AM
        // 10 = 10AM
        // 14 = 2PM
        // 18: 6PM
        // 19:55 = 7:55PM
        // 20 = 8PM
        if hour > 20 {
            modifiedDate = Calendar.current.date(byAdding: .hour, value: 12, to: Date())
        } else if hour > 18 {
            modifiedDate = Calendar.current.date(byAdding: .hour, value: 3, to: Date())
            content.title = "Finish Onboarding"
            content.body = "🌱 Start your first session & unlock a free Cherry Blossom (limited time)"
        } else {
            modifiedDate = Calendar.current.date(byAdding: .hour, value: 2, to: Date())
            content.title = "Finish Onboarding"
            content.body = "🌱 Start your first session & unlock a free Cherry Blossom (limited time)"
        }
     
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: modifiedDate ?? Date())

        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: true)
        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content, trigger: trigger)
        UserDefaults.standard.setValue(uuidString, forKey: "onboardingNotif")
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
        content.title = "👋 Hey, it's been a while and we understand."
        content.body = "If meditation was that easy, everyone would be doing it. But \(UserDefaults.standard.string(forKey: "name") ?? "") you're different!"
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
    
    static func freeTrial() {
        let content = UNMutableNotificationContent()
        content.title = "Your Free trial ends tomorrow"
        content.body = "👨‍🌾 Users who go pro are 4x more likely to make meditation a habit"
        content.sound = UNNotificationSound.default
        
        let imageName = "referral2"
        if let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png"), let attachment = try? UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none) {
            content.attachments = [attachment]
        }

        let modifiedDate = Calendar.current.date(byAdding: .day, value: 5, to: Date())
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: modifiedDate ?? Date())

        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: true)
        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content, trigger: trigger)
        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
              // Handle any errors.
           }
        }
    }
    
    static func addUnlockedFeature(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        let modifiedDate = Calendar.current.date(byAdding: .hour, value: 12, to: Date())
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: modifiedDate ?? Date())

        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: true)
        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content, trigger: trigger)
        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
              // Handle any errors.
           }
        }
    }

    //Create Date from picker selected value.
    static func createDate(weekday: Int, hour: Int, minute: Int)->Date{
           var components = DateComponents()
           components.hour = hour
           components.minute = minute
           components.year = Int(Date().get(.year))
//           components.month = Int(Date().get(.month))
//           components.day = Int(Date().get(.day))
           components.weekday = weekday // sunday = 1 ... saturday = 7
           components.weekdayOrdinal = 10
           components.timeZone = .current
           let formatter = DateFormatter()
           formatter.dateFormat = "MM/dd/yyyy hh:mm a"
           let calendar = Calendar(identifier: .gregorian)
           return calendar.date(from: components)!
       }

       //Schedule Notification with weekly bases.
    static func scheduleNotification(at date: Date, weekDay: Int, title: String = "🧘‍♀️ Let's Go! Mental training time", subtitle: String = "Practice makes perfect, tend to your garden today.", isMindful: Bool = false) {
           let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute], from: date)

           let content = UNMutableNotificationContent()

           content.title = title
           content.body = subtitle

           content.sound = UNNotificationSound.default
           let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)

           // choose a random identifier
            let request = UNNotificationRequest(identifier: isMindful ? "\(weekDay)+\(date.get(.hour))" : String(weekDay), content: content, trigger: trigger)

           // add our notification request
           UNUserNotificationCenter.current().add(request)

       }
    static func deleteMindfulNotifs() {
        var identifiers = [String]()
        for weekday in 1...7 {
            for i in 8...21 {
                identifiers.append("\(weekday)+\(i)")
            }
        }
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    static func createMindfulNotifs() {
        // hours between 9 -> 22
        // 7 days a week
        // 5 notiftypes
        deleteMindfulNotifs()
        var notifTypes = UserDefaults.standard.array(forKey: "notifTypes") as! [String]
        let frequency = UserDefaults.standard.integer(forKey: "frequency")

        var firstThird = Int.random(in: 8...12)
        var secondThird = Int.random(in: 14...17)
        var finalThird = Int.random(in: 19...21)
        for weekday in 1...7 {
            notifTypes = notifTypes.shuffled()
            for i in 0...frequency {
                var randNum = 0
                if frequency == 1 {
                    firstThird = Int.random(in: 8...21)
                    randNum = 0
                } else if frequency == 2 {
                    firstThird = Int.random(in: 8...14)
                    secondThird = Int.random(in: 15...21)
                    randNum = i % 2
                } else {
                   firstThird = Int.random(in: 8...12)
                   secondThird = Int.random(in: 14...17)
                   finalThird = Int.random(in: 19...21)
                   randNum = i % 3
                }

                let arr = [firstThird, secondThird, finalThird]
                let notifType = i % notifTypes.count
                let randNotifType = Int.random(in: 0..<gratitudes.count)
                if notifTypes[notifType] == "gratitude" {
                    scheduleNotification(at: createDate(weekday: weekday, hour: arr[randNum], minute: 30), weekDay: weekday, title: "Gratitude Reminder", subtitle: gratitudes[randNotifType], isMindful: true)
                } else if notifTypes[notifType] == "breathing" {
                    scheduleNotification(at: createDate(weekday: weekday, hour: arr[randNum], minute: 30), weekDay: weekday, title: "Reminder to Breathe", subtitle: breathing[randNotifType], isMindful: true)
                } else if notifTypes[notifType] == "smiling" {
                    scheduleNotification(at: createDate(weekday: weekday, hour: arr[randNum], minute: 30), weekDay: weekday, title: "Reminder to Smile", subtitle: smiling[randNotifType], isMindful: true)
                } else if notifTypes[notifType] == "loving" {
                    scheduleNotification(at: createDate(weekday: weekday, hour: arr[randNum], minute: 30), weekDay: weekday, title: "Reminder to Love", subtitle: loving[randNotifType], isMindful: true)
                } else { // present
                    scheduleNotification(at: createDate(weekday: weekday, hour: arr[randNum], minute: 30), weekDay: weekday, title: "Reminder to be Present", subtitle: present[randNotifType] , isMindful: true)
                }
            }
        }
    }
}




