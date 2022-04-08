//
//  BonusViewModel.swift
//  MindGarden
//  Created by Dante Kim on 9/2/21.
//

import Swift
import Combine
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import WidgetKit

var updatedStreak = false
class BonusViewModel: ObservableObject {
    @Published var lastLogin: String = ""
    @Published var dailyBonus: String = ""
    @Published var streak: String? //Optional("1+08-25-2021 22:16:18") loco
    @Published var sevenDay: Int = 0
    @Published var thirtyDay: Int = 0
    @Published var sevenDayProgress: Double = 0.1
    @Published var thirtyDayProgress: Double = 0.08
    @Published var longestStreak: Int = 0
    @Published var totalBonuses: Int = 0
    @Published var dailyInterval: String = ""
    @Published var bonusTimer: Timer? = Timer()
    @Published var progressiveTimer: Timer? = Timer()
    @Published var progressiveInterval: String = ""
    @Published var fiftyOffTimer: Timer? = Timer()
    @Published var fiftyOffInterval: String = ""
    @Published var lastStreakDate = ""
    var userModel: UserViewModel
    var streakNumber = 0
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
        self.bonusTimer?.invalidate()
        self.bonusTimer = nil
        dailyInterval = ""
        var interval = TimeInterval()

        if dailyBonus == "" { // first daily bonus ever
            interval = 86400
        } else {
            interval = formatter.date(from: dailyBonus)! - Date()
        }

        dailyInterval = interval.stringFromTimeInterval()
        self.bonusTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
            interval -= 1
            dailyInterval = interval.stringFromTimeInterval()
            if interval <= 0 {
                timer.invalidate()
            }
        }
    }
    
    private func createFiftyCountdown() {
        self.fiftyOffTimer?.invalidate()
        self.fiftyOffTimer = nil
        fiftyOffInterval = ""
        var interval = TimeInterval()

        if let fifty = UserDefaults.standard.string(forKey: "fiftyTimer") {
            interval = formatter.date(from: fifty)! - Date()
        } else {
            interval = 7200
        }
        

        fiftyOffInterval = interval.stringFromTimeInterval()
        self.fiftyOffTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
            interval -= 1
            fiftyOffInterval = interval.stringFromTimeInterval()
            if interval <= 0 {
                timer.invalidate()
            }
        }
    }
    
    private func createProgressiveCountdown() {
        self.progressiveTimer?.invalidate()
        self.progressiveTimer = nil
        progressiveInterval = ""
        var interval = TimeInterval()

        if let lastTutorialDate = UserDefaults.standard.string(forKey: "ltd") {
            interval = formatter.date(from: lastTutorialDate)! - Date()
        } else {
            interval = 43200
        }
        

        progressiveInterval = interval.stringFromTimeInterval()
        self.progressiveTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
            interval -= 1
            progressiveInterval = interval.stringFromTimeInterval()
            if interval <= 0 {
                timer.invalidate()
                progressiveDisclosure(lastStreakDate: formatter.string(from: Date()))
            }
        }
    }

    func saveDaily(plusCoins: Int) {
        userCoins += plusCoins
        dailyBonus = formatter.string(from: Calendar.current.date(byAdding: .hour, value: 24, to: Date())!)
        createDailyCountdown()
        UserDefaults.standard.setValue(self.dailyBonus, forKey: K.defaults.dailyBonus)
        UserDefaults.standard.setValue(userCoins, forKey: K.defaults.coins)
        if let email = Auth.auth().currentUser?.email {
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
        } else {
            UserDefaults.standard.setValue(userCoins, forKey: K.defaults.coins)
            UserDefaults.standard.setValue(dailyBonus, forKey: K.defaults.dailyBonus)
        }
    }

    func saveSeven() {
        userCoins += 30
        sevenDay += 1
        UserDefaults.standard.setValue(sevenDay, forKey: K.defaults.seven)
        UserDefaults.standard.setValue(userCoins, forKey: K.defaults.coins)
        if let email = Auth.auth().currentUser?.email {
            self.db.collection(K.userPreferences).document(email).updateData([
                K.defaults.seven: sevenDay,
                K.defaults.coins: userCoins
            ]) { (error) in
                if let e = error {
                    print("There was a issue saving data to firestore \(e) ")
                } else {
                    print("Succesfully saved seven")
                    self.calculateProgress()
                }
            }
        } else {
            UserDefaults.standard.setValue(userCoins, forKey: K.defaults.coins)
            UserDefaults.standard.setValue(dailyBonus, forKey: K.defaults.dailyBonus)
            self.calculateProgress()
        }
    }

    func saveThirty() {
        userCoins += 100
        thirtyDay += 1
        UserDefaults.standard.setValue(thirtyDay, forKey: K.defaults.thirty)
        UserDefaults.standard.setValue(userCoins, forKey: K.defaults.coins)
        if let email = Auth.auth().currentUser?.email {
            self.db.collection(K.userPreferences).document(email).updateData([
                K.defaults.thirty: thirtyDay,
                K.defaults.coins: userCoins
            ]) { (error) in
                if let e = error {
                    print("There was a issue saving data to firestore \(e) ")
                } else {
                    print("Succesfully saved thirty")
                    self.calculateProgress()
                }
            }
        } else {
            UserDefaults.standard.setValue(userCoins, forKey: K.defaults.coins)
            UserDefaults.standard.setValue(dailyBonus, forKey: K.defaults.dailyBonus)
            self.calculateProgress()
        }
    }

    func updateBonus() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        if let oneId = UserDefaults.standard.value(forKey: "oneDayNotif") as? String {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [oneId])
            NotificationHelper.addOneDay()
        }
        if let threeId = UserDefaults.standard.value(forKey: "threeDayNotif") as? String {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [threeId])
            NotificationHelper.addThreeDay()
        }
        
        if let lastTutorialDate = UserDefaults.standard.string(forKey: "ltd")  {
            if UserDefaults.standard.bool(forKey: "newUser") {
                progressiveDisclosure(lastStreakDate: lastTutorialDate)
            }
        } else if UserDefaults.standard.bool(forKey: "newUser") {
            let dte =  formatter.string(from: Calendar.current.date(byAdding: .hour, value: 14, to: Date())!)
            UserDefaults.standard.setValue(dte, forKey: "ltd")
            progressiveDisclosure(lastStreakDate: dte)
        } else {
            UserDefaults.standard.setValue(true, forKey: "day1")
            UserDefaults.standard.setValue(true, forKey: "day2")
            UserDefaults.standard.setValue(true, forKey: "day3")
            UserDefaults.standard.setValue(1, forKey: "day")
        }


        if let email = Auth.auth().currentUser?.email {
            let docRef = db.collection(K.userPreferences).document(email)
            docRef.getDocument { (snapshot, error) in
                if let document = snapshot, document.exists {
                    self.totalBonuses = 0
                    if let streak = document["streak"] as? String {
                        self.streak = streak
                        if let plus = self.streak?.firstIndex(of: "+") {
                            self.streakNumber = Int(self.streak![..<plus])!
                            let plusOffset = self.streak!.index(plus, offsetBy: 1)
                            self.lastStreakDate = String(self.streak![plusOffset...])
                            self.updateLaunchNumber()
                        }
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
                    if let referredStack = document["referredStack"] as? String {
                        self.userModel.referredStack = referredStack
                        self.userModel.checkIfPro()
                    }
                    
                    self.calculateProgress()
                    if self.dailyBonus != "" && self.formatter.date(from: self.dailyBonus)! - Date() > 0 {
                        self.createDailyCountdown()
                    }
                }
            }
        } else {
            self.totalBonuses = 0
            if let lSD = UserDefaults.standard.value(forKey: K.defaults.lastStreakDate) as? String {
                self.lastStreakDate = lSD
            }
            if let streak = UserDefaults.standard.value(forKey: "streak") as? String {
                self.streak = streak
                if let plus = self.streak?.firstIndex(of: "+") {
                    self.streakNumber = Int(self.streak![..<plus])!
                    let plusOffset = self.streak!.index(plus, offsetBy: 1)
                    self.lastStreakDate = String(self.streak![plusOffset...])
                }
            } else {
                lastStreakDate = formatter.string(from: Date())
                streakNumber = 0
            }
            if let seven = UserDefaults.standard.value(forKey: K.defaults.seven) as? Int {
                self.sevenDay = seven
            }
            if let thirty = UserDefaults.standard.value(forKey: K.defaults.thirty) as? Int {
                self.thirtyDay = thirty
            }
            if let dailyBonus = UserDefaults.standard.value(forKey: K.defaults.dailyBonus) as? String {
                self.dailyBonus = dailyBonus
            }
            self.calculateProgress()
            if self.dailyBonus != "" && self.formatter.date(from: self.dailyBonus)! - Date() > 0 {
                self.createDailyCountdown()
            }
            self.updateLaunchNumber()
        }

    }
    
    private func updateLaunchNumber() {
        var launchNum = UserDefaults.standard.integer(forKey: "launchNumber")
        if launchNum == 7 {
            Analytics.shared.log(event: .seventh_time_coming_back)
        }
        
        if (Date() - formatter.date(from: lastStreakDate)! >= 86400 && Date() - formatter.date(from: lastStreakDate)! <= 172800) {
            launchNum += 1
        } else if  Date() - formatter.date(from: self.lastStreakDate)! > 172800 {
            self.streakNumber = 0
            lastStreakDate = formatter.string(from: Date())
            UserDefaults(suiteName: "group.io.bytehouse.mindgarden.widget")?.setValue(streakNumber, forKey: "streakNumber")
            if let email = Auth.auth().currentUser?.email {
                self.db.collection(K.userPreferences).document(email).updateData([
                    "streak": String(self.streakNumber) + "+" + lastStreakDate
                ]) { (error) in
                    if let e = error {
                        print("There was a issue saving data to firestore \(e) ")
                    } else {
                        print("Succesfully saved streak")
                    }
                }
            } else {
                UserDefaults.standard.setValue((String(self.streakNumber) + "+" + lastStreakDate), forKey: "streak")
            }
            launchNum += 1
        }
        UserDefaults.standard.setValue(launchNum, forKey: "launchNumber")
    }
    
    func updateStreak() {
        if let email = Auth.auth().currentUser?.email {
            lastStreakDate = self.calculateStreak(lastStreakDate: lastStreakDate)
            if self.streakNumber == 7 {
                if !self.userModel.ownedPlants.contains(where: { p in p.title == "Red Mushroom" }) {
                    self.userModel.willBuyPlant = Plant.badgePlants.first(where: { plant in plant.title == "Red Mushroom" })
                    self.userModel.buyPlant(unlockedStrawberry: true)
                }
            } else if self.streakNumber == 30 {
                if !self.userModel.ownedPlants.contains(where: { p in p.title == "Cherry Blossoms" }) {
                    self.userModel.willBuyPlant = Plant.badgePlants.first(where: { plant in plant.title == "Cherry Blossoms" })
                    self.userModel.buyPlant(unlockedStrawberry: true)
                }
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
        } else {
            lastStreakDate = self.calculateStreak(lastStreakDate: lastStreakDate)
            UserDefaults.standard.setValue((String(self.streakNumber) + "+" + lastStreakDate), forKey: "streak")
        }
    }

    private func calculateStreak(lastStreakDate: String = "") -> String {
        var lastStreakDate = lastStreakDate
        
        if (Auth.auth().currentUser?.email == nil)  {
            streak = UserDefaults.standard.value(forKey: "streak") as? String
        }
        
        if let plus = self.streak?.firstIndex(of: "+") {
            self.streakNumber = Int(self.streak![..<plus])!
            let plusOffset = self.streak!.index(plus, offsetBy: 1)
            lastStreakDate = String(self.streak![plusOffset...])
            
            // for new users only

            let sreakDate = formatter.date(from: lastStreakDate)!.setTime(hour: 00, min: 00, sec: 00)
            let currentDate = Date().setTime(hour: 00, min: 00, sec: 00) ?? Date()
            let interval = currentDate.interval(ofComponent: .day, fromDate: sreakDate ?? Date())
            
            if (interval >= 1 && interval <= 2) {  // update streak number and date
                updatedStreak = true
                self.streakNumber += 1
                if let longestStreak =  UserDefaults.standard.value(forKey: "longestStreak") as? Int {
                    if longestStreak < streakNumber {
                        UserDefaults.standard.setValue(streakNumber, forKey: "longestStreak")
                    }
                    UserDefaults.standard.setValue(true, forKey: "updatedStreak")
                } else {
                    UserDefaults.standard.setValue(1, forKey: "longestStreak")
                }

                lastStreakDate = formatter.string(from: Date())
            } else if interval > 2 { //broke streak
                updatedStreak = true
                self.streakNumber = 1
                lastStreakDate = formatter.string(from: Date())
                if let email = Auth.auth().currentUser?.email {
                    self.db.collection(K.userPreferences).document(email).updateData([
                        "sevenDay": 0,
                        "thirtyDay": 0,
                        "seven": 0,
                        "thirty": 0,
                    ]) { (error) in
                        if let e = error {
                            print("There was a issue saving data to firestore \(e) ")
                        } else {
                            print("Succesfully saved seven & thirty progress")
                        }
                    }
                } else {
                    UserDefaults.standard.setValue(0, forKey: "sevenDay")
                    UserDefaults.standard.setValue(0, forKey: "thirtyDay")
                }
            } else {
                lastStreakDate  = formatter.string(from: Date())
                if streakNumber == 0 {
                    if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "done" {
                        updatedStreak = true
                        self.streakNumber = 1
                    } else {
                        self.streakNumber = 0
                    }
                }
            }
        } else {
            updatedStreak = true
            lastStreakDate  = formatter.string(from: Date())
            if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "done" {
                self.streakNumber = 1
            } else {
                self.streakNumber = 0
            }
        }
        UserDefaults(suiteName: "group.io.bytehouse.mindgarden.widget")?.setValue(streakNumber, forKey: "streakNumber")
        UserDefaults(suiteName: "group.io.bytehouse.mindgarden.widget")?.setValue(UserDefaults.standard.bool(forKey:"isPro"), forKey: "isPro")
        WidgetCenter.shared.reloadAllTimelines()

        return lastStreakDate
    }
    
    private func progressiveDisclosure(lastStreakDate: String) {
        print(lastStreakDate, formatter.string(from: Date()), "arig")
        if formatter.date(from: lastStreakDate)! - Date() <= 0 {
            let dte =  formatter.string(from: Calendar.current.date(byAdding: .hour, value: 14, to: Date())!)
            UserDefaults.standard.setValue(dte,forKey: "ltd")
            if UserDefaults.standard.bool(forKey: "day1") {
                if UserDefaults.standard.bool(forKey: "day2") {
                    if UserDefaults.standard.bool(forKey: "day3") {
                        if UserDefaults.standard.bool(forKey: "day4") {
                                
                        } else { //fourth day back
                            UserDefaults.standard.setValue(true, forKey: "day4")
                            UserDefaults.standard.setValue(4, forKey: "day")
                        }
                    } else { // third day back
                        UserDefaults.standard.setValue(true, forKey: "day3")
                        UserDefaults.standard.setValue(3, forKey: "day")
                    }
                } else { // second day back
                    NotificationHelper.addUnlockedFeature(title: "⚙️ Widget has been unlocked", body: "Add it to your home screen!")
                    UserDefaults.standard.setValue(true, forKey: "day2")
                    UserDefaults.standard.setValue(2, forKey: "day")
                }
            } else { // first day back
                NotificationHelper.addUnlockedFeature(title: "🛍 Your Store Page has been unlocked!", body: "Start collecting, and make your MindGarden beautiful!")
                UserDefaults.standard.setValue(true, forKey: "day1")
                UserDefaults.standard.setValue(1, forKey: "day")
            }
        }
        createProgressiveCountdown()
    }

    private func calculateProgress() {
        totalBonuses = 0
        if self.dailyBonus != "" {
            if (Date() - formatter.date(from: self.dailyBonus)! >= 0) {
                self.totalBonuses += 1
                NotificationCenter.default.post(name: Notification.Name("runCounter"), object: nil)
            }
        } else {
            self.totalBonuses += 1
            NotificationCenter.default.post(name: Notification.Name("runCounter"), object: nil)
        }


        if self.sevenDay > 0 {
            let leftOver = self.streakNumber - (self.sevenDay * 7)
            self.sevenDayProgress = Double(leftOver)/7.0
        } else {
            self.sevenDayProgress = Double(self.streakNumber)/7.0
        }
        if self.sevenDayProgress <= 0.1 {
            self.sevenDayProgress = 0.1
        }

        if self.thirtyDay > 0 {
            let leftOver = self.streakNumber - (self.thirtyDay * 30)
            self.thirtyDayProgress = Double(leftOver)/30.0
        } else {
            self.thirtyDayProgress = Double(self.streakNumber)/30.0
        }
        if self.thirtyDayProgress <= 0.08 {
            self.thirtyDayProgress = 0.08
        }

        if self.sevenDayProgress >= 1.0 {
            self.totalBonuses += 1
            NotificationCenter.default.post(name: Notification.Name("runCounter"), object: nil)
        }
        if self.thirtyDayProgress >= 1.0 {
            self.totalBonuses += 1
            NotificationCenter.default.post(name: Notification.Name("runCounter"), object: nil)
        }
    }
}
