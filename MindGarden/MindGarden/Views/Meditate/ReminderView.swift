//
//  ReminderView.swift
//  demo
//
//  Created by Vishal Davara on 29/04/22.
//

import SwiftUI
import OneSignal

struct ReminderView: View {
    let reminderTitle = "Remind me Tomorrow"
    @State private var time = 0.0
    @State private var isToggled : Bool = false
    var body: some View {
        VStack {
            Text(reminderTitle)
                .font(Font.mada(.bold, size: 20))
                .foregroundColor(Clr.black2)
            ZStack {
                Rectangle()
                    .fill(Clr.darkWhite)
                    .cornerRadius(25)
                    .neoShadow()
                VStack {
                    Slider(value: $time, in: 0...86399)
                        .accentColor(.gray)
                        .padding(.top,20)
                        .padding(.horizontal)
                    HStack {
                        Image(systemName: "cloud.sun")
                            .resizable()
                            .foregroundColor(Clr.brightGreen)
                            .aspectRatio(contentMode: .fit)
                        Spacer()
                        Image(systemName: "sun.max.fill")
                            .resizable()
                            .foregroundColor(Clr.dirtBrown)
                            .aspectRatio(contentMode: .fit)
                        Spacer()
                        Image(systemName: "moon.stars.fill")
                            .resizable()
                            .foregroundColor(Clr.freezeBlue)
                            .aspectRatio(contentMode: .fit)
                    }
                    .frame(height: 20, alignment: .center)
                    .padding(.horizontal)
                    .padding(.bottom,40)
                    ZStack {
                        Rectangle()
                            .fill(Clr.lightGray)
                            .opacity(0.4)
                            .cornerRadius(25)
                        HStack {
                            if let timeInterval = TimeInterval(time) {
                                Text(timeInterval.secondsToHourMinFormat() ?? "")
                                    .font(Font.mada(.bold, size: 20))
                                    .foregroundColor(Clr.black2)
                                Toggle("", isOn: $isToggled)
                                    .onChange(of: isToggled) { val in
                                    if val {
                                        Analytics.shared.log(event: .finished_set_reminder)
                                        if !UserDefaults.standard.bool(forKey: "showedNotif") {
                                            OneSignal.promptForPushNotifications(userResponse: { accepted in
                                                if accepted {
                                                    Analytics.shared.log(event: .finished_set_reminder)
                                                    NotificationHelper.addOneDay()
                                                    NotificationHelper.addThreeDay()
                                                    // UserDefaults.standard.setValue(true, forKey: "mindful")
                                                    // NotificationHelper.createMindfulNotifs()
                                                    if UserDefaults.standard.bool(forKey: "freeTrial")  {
                                                        NotificationHelper.freeTrial()
                                                    }
                                                    
                                                    promptNotification()
                                                } else {
                                                    isToggled = false
                                                }
                                                UserDefaults.standard.setValue(true, forKey: "showedNotif")
                                            })
                                        } else {
                                            promptNotification()
                                        }
                                    }
                                }
                            }
                        }.padding()
                    }
                }
            }
        }
    }
    
    private func promptNotification() {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { permission in
            switch permission.authorizationStatus  {
            case .authorized:
                UserDefaults.standard.setValue(true, forKey: "isNotifOn")
                UserDefaults.standard.setValue(TimeInterval(time).secondsToHourMinFormat(), forKey: K.defaults.meditationReminder)
                if UserDefaults.standard.value(forKey: "oneDayNotif") == nil {
                    NotificationHelper.addOneDay()
                }
                if UserDefaults.standard.value(forKey: "threeDayNotif") == nil {
                    NotificationHelper.addThreeDay()
                }
                if UserDefaults.standard.value(forKey: "onboardingNotif") == nil {
                    NotificationHelper.addOnboarding()
                }

                if UserDefaults.standard.bool(forKey: "freeTrial")  {
                    NotificationHelper.freeTrial()
                }
                UserDefaults.standard.setValue(true, forKey: "notifOn")
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.hour, .minute]
                formatter.zeroFormattingBehavior = .pad
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"

                let date = dateFormatter.date(from: formatter.string(from: time) ?? "")
                dateFormatter.dateFormat = "hh:mm a"
                let realDate = dateFormatter.string(from: date ?? Date())
                
                UserDefaults.standard.setValue(dateFormatter.date(from: realDate), forKey: "notif")
                
                for i in 1...7 {
                    let dateTime = dateFormatter.date(from: TimeInterval(time).secondsToHourMinFormat() ?? "12:54") ?? Date()
                    let datee = NotificationHelper.createDate(weekday: i, hour: Int(dateTime.get(.hour))!, minute: Int(dateTime.get(.minute))!)
                    NotificationHelper.scheduleNotification(at: datee,  weekDay: i)
                }
            case .notDetermined:
                UserDefaults.standard.setValue(false, forKey: "isNotifOn")
                Analytics.shared.log(event: .notification_go_to_settings)
                DispatchQueue.main.async {
                    if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                        UIApplication.shared.open(appSettings)
                    }
                }
                isToggled = false
            case .denied:
                UserDefaults.standard.setValue(false, forKey: "isNotifOn")
                Analytics.shared.log(event: .notification_go_to_settings)
                DispatchQueue.main.async {
                    if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                        UIApplication.shared.open(appSettings)
                    }
                }
                isToggled = false
            default:
                break
            }
        })
    }
}
