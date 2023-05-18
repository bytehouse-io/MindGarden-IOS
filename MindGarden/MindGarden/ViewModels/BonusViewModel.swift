//
//  BonusViewModel.swift
//  MindGarden
//  Created by Dante Kim on 9/2/21.
//

import Amplitude
import Combine
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Storyly
import Swift
import UIKit
import WidgetKit

var updatedStreak = false
var showWidgetTip = false
class BonusViewModel: ObservableObject {
    @Published var lastLogin: String = ""
    @Published var dailyBonus: String = ""
    @Published var streak: String? // Optional("1+08-25-2021 22:16:18") loco
    @Published var sevenDay: Int = 0
    @Published var thirtyDay: Int = 0
    @Published var sevenDayProgress: Double = 0.1
    @Published var thirtyDayProgress: Double = 0.08
    @Published var longestStreak: Int = 0
    @Published var totalBonuses: Int = 0
    @Published var dailyInterval: TimeInterval = 0
    @Published var progressiveTimer: Timer? = Timer()
    @Published var progressiveInterval: String = ""
    @Published var fiftyOffTimer: Timer? = Timer()
    @Published var fiftyOffInterval: String = ""
    @Published var lastStreakDate = ""
    var userModel: UserViewModel
    var gardenModel: GardenViewModel
    @Published var streakNumber = 0
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        return formatter
    }()

    let db = Firestore.firestore()

    init(userModel: UserViewModel, gardenModel: GardenViewModel) {
        self.userModel = userModel
        self.gardenModel = gardenModel
    }

    func createDailyCountdown() {
        if dailyBonus == "" { // first daily bonus ever
            dailyInterval = 86400
        } else {
            if let date = formatter.date(from: dailyBonus) {
                dailyInterval = date - Date()
            }
        }
    }

    private func createFiftyCountdown() {
        fiftyOffTimer?.invalidate()
        fiftyOffTimer = nil
        fiftyOffInterval = ""
        var interval = TimeInterval()

        if let fifty = DefaultsManager.standard.value(forKey: .fiftyTimer).string {
            interval = (formatter.date(from: fifty) ?? Date()) - Date()
        } else {
            interval = 7200
        }

        fiftyOffInterval = interval.stringFromTimeInterval()
        fiftyOffTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            interval -= 1
            self?.fiftyOffInterval = interval.stringFromTimeInterval()
            if interval <= 0 {
                timer.invalidate()
            }
        }
    }

    private func createProgressiveCountdown() {
        progressiveTimer?.invalidate()
        progressiveTimer = nil
        progressiveInterval = ""
        var interval = TimeInterval()

        if let lastTutorialDate = DefaultsManager.standard.value(forKey: .ltd).string {
            interval = (formatter.date(from: lastTutorialDate) ?? Date()) - Date()
        } else {
            interval = 43200
        }

        progressiveInterval = interval.stringFromTimeInterval()
        progressiveTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            interval -= 1
            self?.progressiveInterval = interval.stringFromTimeInterval()
            if interval <= 0 {
                timer.invalidate()
                self?.progressiveDisclosure(lastStreakDate: self?.formatter.string(from: Date()) ?? "")
            }
        }
    }

    func saveDaily(plusCoins: Int) {
        userModel.coins += plusCoins
        dailyBonus = formatter.string(from: Calendar.current.date(byAdding: .hour, value: 24, to: Date()) ?? Date())
        createDailyCountdown()
        DefaultsManager.standard.set(value: dailyBonus, forKey: .dailyBonus)
        DefaultsManager.standard.set(value: userModel.coins, forKey: .coins)
        if let email = Auth.auth().currentUser?.email {
            db.collection(K.userPreferences).document(email).updateData([
                // TODO: turn this into userdefault
                K.defaults.dailyBonus: dailyBonus,
                K.defaults.coins: userModel.coins,
            ]) { error in
                if let e = error {
                    print("There was a issue saving data to firestore \(e) ")
                } else {
                    print("Succesfully saved daily", self.dailyBonus)
                }
            }
        } else {
            DefaultsManager.standard.set(value: userModel.coins, forKey: .coins)
            DefaultsManager.standard.set(value: dailyBonus, forKey: .dailyBonus)
        }
    }

    func saveSeven() {
        userModel.coins += 300
        sevenDay += 1
        DefaultsManager.standard.set(value: sevenDay, forKey: .seven)
        DefaultsManager.standard.set(value: userModel.coins, forKey: .coins)
        if let email = Auth.auth().currentUser?.email {
            db.collection(K.userPreferences).document(email).updateData([
                K.defaults.seven: sevenDay,
                K.defaults.coins: userModel.coins,
            ]) { error in
                if let e = error {
                    print("There was a issue saving data to firestore \(e) ")
                } else {
                    print("Succesfully saved seven")
                    self.calculateProgress()
                }
            }
        } else {
            DefaultsManager.standard.set(value: userModel.coins, forKey: .coins)
            DefaultsManager.standard.set(value: dailyBonus, forKey: .dailyBonus)
            calculateProgress()
        }
    }

    func tripleBonus() {
        userModel.coins += 500
        DefaultsManager.standard.set(value: userModel.coins, forKey: .coins)
        if let email = Auth.auth().currentUser?.email {
            db.collection(K.userPreferences).document(email).updateData([
                K.defaults.coins: userModel.coins,
            ]) { error in
                if let e = error {
                    print("There was a issue saving data to firestore \(e) ")
                } else {
                    print("Succesfully saved seven")
                    self.calculateProgress()
                }
            }
        } else {
            DefaultsManager.standard.set(value: userModel.coins, forKey: .coins)
            DefaultsManager.standard.set(value: dailyBonus, forKey: .dailyBonus)
            calculateProgress()
        }
    }

    func saveThirty() {
        userModel.coins += 1000
        thirtyDay += 1
        DefaultsManager.standard.set(value: thirtyDay, forKey: .thirty)
        DefaultsManager.standard.set(value: userModel.coins, forKey: .coins)
        if let email = Auth.auth().currentUser?.email {
            db.collection(K.userPreferences).document(email).updateData([
                K.defaults.thirty: thirtyDay,
                K.defaults.coins: userModel.coins,
            ]) { error in
                if let e = error {
                    print("There was a issue saving data to firestore \(e) ")
                } else {
                    print("Succesfully saved thirty")
                    self.calculateProgress()
                }
            }
        } else {
            DefaultsManager.standard.set(value: userModel.coins, forKey: .coins)
            DefaultsManager.standard.set(value: dailyBonus, forKey: .dailyBonus)
            calculateProgress()
        }
    }

    func updateBonus() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"

        if let lastTutorialDate = DefaultsManager.standard.value(forKey: .ltd).string {
            if DefaultsManager.standard.value(forKey: .newUser).boolValue {
                progressiveDisclosure(lastStreakDate: lastTutorialDate)
            }
            progressiveDisclosure(lastStreakDate: formatter.string(from: Calendar.current.date(byAdding: .hour, value: 12, to: Date()) ?? Date()))
        } else if DefaultsManager.standard.value(forKey: .newUser).boolValue {
            let dte = formatter.string(from: Calendar.current.date(byAdding: .hour, value: 12, to: Date()) ?? Date())
            DefaultsManager.standard.set(value: dte, forKey: .ltd)
            progressiveDisclosure(lastStreakDate: dte)
        } else {
            DefaultsManager.standard.set(value: true, forKey: .day1)
            DefaultsManager.standard.set(value: true, forKey: .day2)
            DefaultsManager.standard.set(value: true, forKey: .day3)
            DefaultsManager.standard.set(value: 1, forKey: .day)
        }

        if let email = Auth.auth().currentUser?.email {
            let docRef = db.collection(K.userPreferences).document(email)
            docRef.getDocument { snapshot, _ in
                if let document = snapshot, document.exists {
                    self.totalBonuses = 0
                    if let streak = document["streak"] as? String {
                        self.streak = streak
                        if let plus = self.streak?.firstIndex(of: "+"), let streak = self.streak {
                            self.streakNumber = Int(streak[..<plus]) ?? 0
                            let plusOffset = streak.index(plus, offsetBy: 1)
                            self.lastStreakDate = String(streak[plusOffset...])
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
                    if self.dailyBonus != "" && (self.formatter.date(from: self.dailyBonus) ?? Date()) - Date() > 0 {
                        self.createDailyCountdown()
                    }
                }
            }
        } else {
            totalBonuses = 0
            if let lSD = DefaultsManager.standard.value(forKey: .lastStreakDate).string {
                lastStreakDate = lSD
            }
            if let streak = DefaultsManager.standard.value(forKey: .streak).string {
                self.streak = streak
                if let plus = self.streak?.firstIndex(of: "+"), let streak = self.streak {
                    streakNumber = Int(streak[..<plus]) ?? 0
                    let plusOffset = streak.index(plus, offsetBy: 1)
                    lastStreakDate = String(streak[plusOffset...])
                }
            } else {
                lastStreakDate = formatter.string(from: Date())
                streakNumber = 0
            }
            if let seven = DefaultsManager.standard.value(forKey: .seven).integer {
                sevenDay = seven
            }
            if let thirty = DefaultsManager.standard.value(forKey: .thirty).integer {
                thirtyDay = thirty
            }
            if let dailyBonus = DefaultsManager.standard.value(forKey: .dailyBonus).string {
                self.dailyBonus = dailyBonus
            }
            calculateProgress()
            if dailyBonus != "" && (self.formatter.date(from: dailyBonus) ?? Date()) - Date() > 0 {
                createDailyCountdown()
            }
            updateLaunchNumber()
        }
    }

    private func updateTips(tip: String) {
        var segments = storySegments
        segments = storySegments.filter { str in !str.lowercased().contains("tip") }

        segments.insert(tip)
        DefaultsManager.standard.set(value: Array(segments), forKey: .storySegments)
        storySegments = segments
        StorylyManager.refresh()
    }

    private func updateLaunchNumber() {
        var launchNum = DefaultsManager.standard.value(forKey: .dailyLaunchNumber).integerValue

        if launchNum == 7 {
            Analytics.shared.log(event: .seventh_time_coming_back)
            if DefaultsManager.standard.value(forKey: .referTip).boolValue {
                DefaultsManager.standard.set(value: true, forKey: .referTip)
                updateTips(tip: "Tip Referrals")
            }
        } else if launchNum >= 2 && !DefaultsManager.standard.value(forKey: .remindersOn).boolValue {
            DefaultsManager.standard.set(value: true, forKey: .remindersOn)
            updateTips(tip: "Tip Reminders")
        } else if showWidgetTip && !DefaultsManager.standard.value(forKey: .widgetTip).boolValue {
            DefaultsManager.standard.set(value: true, forKey: .widgetTip)
            updateTips(tip: "Tip Widget")
        } else if DefaultsManager.standard.value(forKey: .day4).boolValue && DefaultsManager.standard.value(forKey: .plusCoins).boolValue {
            DefaultsManager.standard.set(value: true, forKey: .plusCoins)
            updateTips(tip: "Tip Potion Shop")
        }

        if Date() - (formatter.date(from: lastStreakDate) ?? Date()) >= 86400 && Date() - (formatter.date(from: lastStreakDate) ?? Date()) <= 172_800 {
            launchNum += 1

        } else if Date() - (formatter.date(from: lastStreakDate) ?? Date()) > 172_800 {
            launchNum += 1
        }
        DefaultsManager.standard.set(value: launchNum, forKey: .dailyLaunchNumber)
        let identify = AMPIdentify()
            .set("dailyLaunchNumber", value: NSNumber(value: launchNum))
        Amplitude.instance().identify(identify ?? AMPIdentify())
    }

    func updateStreak() {
        if let email = Auth.auth().currentUser?.email {
            lastStreakDate = calculateStreak(lastStreakDate: lastStreakDate)
            if streakNumber == 7 {
                if !userModel.ownedPlants.contains(where: { p in p.title == "Red Mushroom" }) {
                    userModel.willBuyPlant = Plant.badgePlants.first(where: { plant in plant.title == "Red Mushroom" })
                    userModel.buyPlant(unlockedStrawberry: true)
                    userModel.triggerAnimation = true
                }
            } else if streakNumber == 30 {
                if !userModel.ownedPlants.contains(where: { p in p.title == "Cherry Blossoms" }) {
                    userModel.willBuyPlant = Plant.badgePlants.first(where: { plant in plant.title == "Cherry Blossoms" })
                    userModel.buyPlant(unlockedStrawberry: true)
                    userModel.triggerAnimation = true
                }
            }
            streak = String(streakNumber) + "+" + lastStreakDate
            db.collection(K.userPreferences).document(email).updateData([
                "streak": String(streakNumber) + "+" + lastStreakDate,
                "longestStreak": DefaultsManager.standard.value(forKey: .longestStreak).integerValue,
            ]) { error in
                if let e = error {
                    print("There was a issue saving data to firestore \(e) ")
                } else {
                    print("Succesfully saved streak")
                }
            }
        } else {
            lastStreakDate = calculateStreak(lastStreakDate: lastStreakDate)
            DefaultsManager.standard.set(value: String(streakNumber) + "+" + lastStreakDate, forKey: .streak)
        }
    }

    private func calculateStreak(lastStreakDate: String = "") -> String {
        var lastStreakDate = lastStreakDate

        if !SceneDelegate.profileModel.isLoggedIn {
            streak = DefaultsManager.standard.value(forKey: .streak).stringValue
        }

        if let plus = streak?.firstIndex(of: "+"), let streak = streak {
            streakNumber = Int(streak[..<plus]) ?? 0
            let plusOffset = streak.index(plus, offsetBy: 1)
            lastStreakDate = String(streak[plusOffset...])

            // for new users only
            let streakDate = (formatter.date(from: lastStreakDate) ?? Date()).setTime(hour: 00, min: 00, sec: 00)
            let currentDate = Date().setTime(hour: 00, min: 00, sec: 00) ?? Date()
            let interval = currentDate.interval(ofComponent: .day, fromDate: streakDate ?? Date())

            if interval >= 1 && interval < 2 { // update streak number and date
                updatedStreak = true
                streakNumber += 1
                updateLongest()
            } else if interval >= 2 { // broke streak
                updatedStreak = true
                if userModel.streakFreeze >= interval - 1 {
                    freezeStreak(interval: interval)
                    updateLongest()
                } else {
                    updatedStreak = true
                    streakNumber = 1
                    if let email = Auth.auth().currentUser?.email {
                        db.collection(K.userPreferences).document(email).updateData([
                            "sevenDay": 0,
                            "thirtyDay": 0,
                            "seven": 0,
                            "thirty": 0,
                        ]) { error in
                            if let e = error {
                                print("There was a issue saving data to firestore \(e) ")
                            } else {
                                print("Succesfully saved seven & thirty progress")
                            }
                        }
                    } else {
                        DefaultsManager.standard.set(value: 0, forKey: .sevenDay)
                                                     DefaultsManager.standard.set(value: 0, forKey: .thirtyDay)
                    }
                }
            } else {
                if streakNumber == 0 {
                    updatedStreak = true
                    streakNumber = 1
                    updateLongest()
                }
            }
            lastStreakDate = formatter.string(from: Date())
        } else {
            lastStreakDate = formatter.string(from: Date())
            updatedStreak = true
            streakNumber = 1
            updateLongest()
        }

        UserDefaults(suiteName: K.widgetDefault)?.setValue(streakNumber, forKey: "streakNumber")
        UserDefaults(suiteName: K.widgetDefault)?.setValue(UserDefaults.standard.bool(forKey: "isPro"), forKey: "isPro")
        WidgetCenter.shared.reloadAllTimelines()

        return lastStreakDate
    }

    private func recSaveFreeze(day: Int, dates: [Date], session: [String: String]) {
        if day == dates.count {
            return
        } else {
            gardenModel.save(key: "sessions", saveValue: session, date: dates[day], freeze: true, coins: userModel.coins) { [self] in
                let day = day + 1
                recSaveFreeze(day: day, dates: dates, session: session)
            }
        }
    }

    private func freezeStreak(interval _: Int) {
        let datesBetweenArray = Date.dates(from: formatter.date(from: lastStreakDate) ?? Date(), to: Date())
        var session = [String: String]()
        session[K.defaults.plantSelected] = "Ice Flower"
        session[K.defaults.meditationId] = "0"
        session[K.defaults.duration] = "0"
        recSaveFreeze(day: 1, dates: datesBetweenArray, session: session)

        userModel.streakFreeze -= datesBetweenArray.count
        userModel.saveIAP()
        updatedStreak = true
        streakNumber += 1
    }

    private func updateLongest() {
        let longestStreak = DefaultsManager.standard.value(forKey: .longestStreak).integerValue
        if longestStreak > 0 {
            if longestStreak < streakNumber {
                DefaultsManager.standard.set(value: streakNumber, forKey: .longestStreak)
            }

            DefaultsManager.standard.set(value: true, forKey: .updatedStreak)
        } else {
            DefaultsManager.standard.set(value: 1, forKey: .longestStreak)
        }
    }

    private func progressiveDisclosure(lastStreakDate _: String) {
//        if formatter.date(from: lastStreakDate)! - Date() <= 0 {
//            let dte =  formatter.string(from: Calendar.current.date(byAdding: .hour, value: 12, to: Date())!)
//            DefaultsManager.standard.set(value: dte,forKey: "ltd")
//            if UserDefaults.standard.bool(forKey: "day1") {
//                if UserDefaults.standard.bool(forKey: "day2") {
//                    if UserDefaults.standard.bool(forKey: "day3") {
//                        if UserDefaults.standard.bool(forKey: "day4") {
//
//                        } else { //fourth day back unlock plusCoins
//
//                            DefaultsManager.standard.set(value: true, forKey: "day4")
//                            DefaultsManager.standard.set(value: 4, forKey: "day")
//                        }
//                    } else { // third day back
//                        showWidgetTip = true
//                        DefaultsManager.standard.set(value: true, forKey: "day3")
//                        DefaultsManager.standard.set(value: 3, forKey: "day")
//                    }
//                } else { // second day back
//                    NotificationHelper.addUnlockedFeature(title: "⚙️ Widget has been unlocked", body: "Add it to your home screen!")
//                    DefaultsManager.standard.set(value: true, forKey: "day2")
//                    DefaultsManager.standard.set(value: 2, forKey: "day")
//                }
//            } else { // first day back
//                NotificationHelper.addUnlockedFeature(title: "🛍 Your Store Page has been unlocked!", body: "Start collecting, and make your MindGarden beautiful!")
//                DefaultsManager.standard.set(value: true, forKey: "day1")
//                DefaultsManager.standard.set(value: 1, forKey: "day")
//            }
//        }
        createProgressiveCountdown()
    }

    private func calculateProgress() {
        totalBonuses = 0
        if dailyBonus != "" {
            if Date() - (formatter.date(from: dailyBonus) ?? Date()) >= 0 {
                totalBonuses += 1
                NotificationCenter.default.post(name: .runCounter, object: nil)
            }
        } else {
            totalBonuses += 1
            NotificationCenter.default.post(name: .runCounter, object: nil)
        }

        if sevenDay > 0 {
            let leftOver = streakNumber - (sevenDay * 7)
            sevenDayProgress = Double(leftOver) / 7.0
        } else {
            sevenDayProgress = Double(streakNumber) / 7.0
        }
        if sevenDayProgress <= 0.1 {
            sevenDayProgress = 0.1
        }

        if thirtyDay > 0 {
            let leftOver = streakNumber - (thirtyDay * 30)
            thirtyDayProgress = Double(leftOver) / 30.0
        } else {
            thirtyDayProgress = Double(streakNumber) / 30.0
        }
        if thirtyDayProgress <= 0.08 {
            thirtyDayProgress = 0.08
        }

        if sevenDayProgress >= 1.0 {
            totalBonuses += 1
            NotificationCenter.default.post(name: .runCounter, object: nil)
        }
        if thirtyDayProgress >= 1.0 {
            totalBonuses += 1
            NotificationCenter.default.post(name: .runCounter, object: nil)
        }
    }
}
