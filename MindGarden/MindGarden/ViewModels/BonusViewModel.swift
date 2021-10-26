//
//  BonusViewModel.swift
//  MindGarden
//
//  Created by Dante Kim on 9/2/21.
//

import Swift
import Combine
import UIKit
import Firebase
import FirebaseAuth

class BonusViewModel: ObservableObject {
    @Published var lastLogin: String = ""
    @Published var dailyBonus: String = ""
    @Published var streak: String? //Optional("1+08-25-2021 22:16:18") loco
    @Published var sevenDay: Int = 0
    @Published var thirtyDay: Int = 0
    @Published var sevenDayProgress: Double = 0.0
    @Published var thirtyDayProgress: Double = 0.0
    @Published var longestStreak: Int = 0
    @Published var totalBonuses: Int = 0
    @Published var dailyInterval: String = ""
    var userModel: UserViewModel
    var streakNumber = 1
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        return formatter
    }()
    let db = Firestore.firestore()

    init(userModel: UserViewModel) {
        self.userModel = userModel
    }

    private func createDailyCountdown() {
        var interval = TimeInterval()

        if dailyBonus == "" { // first daily bonus ever
            interval = 86400
        } else {
            interval = formatter.date(from: dailyBonus)! - Date()
        }

        dailyInterval = interval.stringFromTimeInterval()
        DispatchQueue.main.async {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
                interval -= 1
                dailyInterval = interval.stringFromTimeInterval()
                if interval <= 0 {
                    timer.invalidate()
                }
            }
        }
    }

    func saveDaily(plusCoins: Int) {
        if let email = Auth.auth().currentUser?.email {
            userCoins += plusCoins
            dailyBonus = formatter.string(from: Calendar.current.date(byAdding: .hour, value: 24, to: Date())!)
            createDailyCountdown()
                self.db.collection(K.userPreferences).document(email).updateData([
                    //TODO turn this into userdefault
                    K.defaults.dailyBonus: self.dailyBonus,
                    K.defaults.coins: userCoins
                ]) { (error) in
                    if let e = error {
                        print("There was a issue saving data to firestore \(e) ")
                    } else {
                        print("Succesfully saved daily", self.dailyBonus)
                    }
                }
            }
    }

    func saveSeven() {
        if let email = Auth.auth().currentUser?.email {
            userCoins += 30
            sevenDay += 1
            let leftOver = streakNumber - (sevenDay * 7)
            sevenDayProgress = Double(leftOver)/7.0
            self.db.collection(K.userPreferences).document(email).updateData([
                K.defaults.seven: sevenDay,
                K.defaults.coins: userCoins
            ]) { (error) in
                if let e = error {
                    print("There was a issue saving data to firestore \(e) ")
                } else {
                    print("Succesfully saved seven")
                }
            }
        }
    }

    func saveThirty() {
        if let email = Auth.auth().currentUser?.email {
            userCoins += 100
            thirtyDay += 1
            let leftOver = streakNumber - (thirtyDay * 30)
            thirtyDayProgress = Double(leftOver)/30.0
            self.db.collection(K.userPreferences).document(email).updateData([
                K.defaults.thirty: thirtyDay,
                K.defaults.coins: userCoins
            ]) { (error) in
                if let e = error {
                    print("There was a issue saving data to firestore \(e) ")
                } else {
                    print("Succesfully saved thirty")
                }
            }
        }
    }

    func updateBonus() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        var lastStreakDate = ""
        if let email = Auth.auth().currentUser?.email {
            let docRef = db.collection(K.userPreferences).document(email)
            docRef.getDocument { (snapshot, error) in
                if let document = snapshot, document.exists {
                    if let lSD = document[K.defaults.lastStreakDate] as? String {
                        lastStreakDate = lSD
                    }
                    if let streak = document["streak"] as? String {
                        self.streak = streak
                    }
                    if let seven = document[K.defaults.seven] as? Int {
                        self.sevenDay = seven
                    }
                    if let thirty = document[K.defaults.thirty] as? Int {
                        self.thirtyDay = thirty
                    }
                    if let dailyBonus = document[K.defaults.dailyBonus] as? String {
                        self.dailyBonus = dailyBonus
                    }

                    if let plus = self.streak?.firstIndex(of: "+") {
                        self.streakNumber = Int(self.streak![..<plus])!
                        let plusOffset = self.streak!.index(plus, offsetBy: 1)
                        lastStreakDate = String(self.streak![plusOffset...])
                        if (Date() - formatter.date(from: lastStreakDate)! >= 86400 && Date() - formatter.date(from: lastStreakDate)! <= 172800) {  // update streak number and date
                            if let oneId = UserDefaults.standard.value(forKey: "oneDayNotif") as? String {
                                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [oneId])
                                NotificationHelper.addOneDay()
                            }
                            if let threeId = UserDefaults.standard.value(forKey: "threeDayNotif") as? String {
                                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [threeId])
                                NotificationHelper.addThreeDay()
                            }
                            self.streakNumber += 1
                            lastStreakDate = formatter.string(from: Date())
                        } else if Date() - formatter.date(from: lastStreakDate)! > 172800 { //broke streak
                            self.streakNumber = 1
                            lastStreakDate = formatter.string(from: Date())
                            self.db.collection(K.userPreferences).document(email).updateData([
                                "sevenDay": 0,
                                "thirtyDay": 0
                            ]) { (error) in
                                if let e = error {
                                    print("There was a issue saving data to firestore \(e) ")
                                } else {
                                    print("Succesfully saved seven & thirty progress")
                                }
                            }
                        } // else no need to update
                        if self.dailyBonus != "" {
                            if (Date() - formatter.date(from: self.dailyBonus)! >= 0) {
                                self.totalBonuses += 1
                            } else {
                                self.createDailyCountdown()
                            }
                        } else {
                            self.totalBonuses += 1
                        }


                        if self.sevenDay > 0 {
                            let leftOver = self.streakNumber - (self.sevenDay * 7)
                            self.sevenDayProgress = Double(leftOver)/7.0
                        } else {
                            self.sevenDayProgress = Double(self.streakNumber)/7.0
                            if self.sevenDayProgress <= 0.1 {
                                self.sevenDayProgress = 0.1
                            }
                        }

                        if self.thirtyDay > 0 {
                            let leftOver = self.streakNumber - (self.thirtyDay * 30)
                            self.thirtyDayProgress = Double(leftOver)/30.0
                        } else {
                            self.thirtyDayProgress = Double(self.streakNumber)/30.0
                            if self.thirtyDayProgress <= 0.08 {
                                self.thirtyDayProgress = 0.08
                            }
                        }
                        if self.sevenDayProgress >= 1.0 {self.totalBonuses += 1}
                        if self.thirtyDayProgress >= 1.0 {self.totalBonuses += 1}
                    } else {
                        lastStreakDate  = formatter.string(from: Date())
                        self.streakNumber = 1
                    }

                    if self.dailyBonus != "" && self.formatter.date(from: self.dailyBonus)! - Date() > 0 {
                        self.createDailyCountdown()
                    }


                    self.db.collection(K.userPreferences).document(email).updateData([
                        "streak": String(self.streakNumber) + "+" + lastStreakDate
                    ]) { (error) in
                        if let e = error {
                            print("There was a issue saving data to firestore \(e) ")
                        } else {
                            print("Succesfully saved streak")
                        }
                    }

                }
            }
        }
    }
}
