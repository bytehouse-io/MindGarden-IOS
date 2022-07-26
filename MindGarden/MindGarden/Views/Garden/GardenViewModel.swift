//
//  GardenViewModel.swift
//  MindGarden
//
//  Created by Dante Kim on 8/6/21.
//

import Combine
import Firebase
import FirebaseFirestore
import Foundation
import WidgetKit


class GardenViewModel: ObservableObject {
    @Published var grid = [String: [String:[String:[String:Any]]]]()
    @Published var isYear: Bool = false
    @Published var selectedYear: Int = 2021
    @Published var selectedMonth: Int = 1
    @Published var monthTiles = [Int: [Int: (Plant?, Mood?)]]()
    @Published var totalMoods = [Mood:Int]()
    @Published var totalMins = 0
    @Published var totalSessions = 0
    @Published var favoritePlants = [String: Int]()
    @Published var recentMeditations: [Meditation] = []
    @Published var gratitudes = 0
    @Published var lastFive =  [(String, Plant?,Mood?)]()
    @Published var entireHistory = [([Int], [[String: String]])]()
    var allTimeMinutes = 0
    var allTimeSessions = 0
    var placeHolders = 0
    let db = Firestore.firestore()
    

    init() {
        selectedMonth = (Int(Date().get(.month)) ?? 1)
        selectedYear = Int(Date().get(.year)) ?? 2021
    }
    
    func getRecentMeditations() {
        var yearSortDict = [String: [[[String:String]]]]()
        
        for (key,value) in grid {
            print(value.keys, value, key)
            let months = value.keys.sorted { Int($0) ?? 1 > Int($1) ?? 1 }
            let yearIds = [[[String:String]]]()
            for mo in months  {
                if let singleDay = value[String(mo)]{
                    let days = singleDay.keys.sorted { Int($0) ?? 1 > Int($1) ?? 1 }
                    for day in days { // we can improve performance by stopping when we get the last two different sessions
                        var dataArr = [[String: String]]()
                        if let sessions = singleDay[String(day)]?["sessions"] as? [[String: String]] {
                            for sess in sessions { // sort by timestamp here
                                dataArr.append(sess)
                            }
                        }
                            if let moods = singleDay[String(day)]?["moods"] as? [[String: String]] {
                                for mood in moods {
                                    dataArr.append(mood)
                                }
                            } else if let moods = singleDay[String(day)]?["moods"] as? [String] {
                                for mood in moods {
                                    var moodObj = [String: String]()
                                    moodObj["mood"] = mood
                                    moodObj["elaboration"] = mood
                                    moodObj["timeStamp"] = "12:00 AM"
                                    dataArr.append(moodObj)
                                }
                            }
 
                            if let journals = singleDay[String(day)]?["journals"] as? [[String: String]] {
                                for journal in journals {
                                    dataArr.append(journal)
                                }
                            } else if let journals = singleDay[String(day)]?["gratitudes"] as? [String] {
                                for journal in journals {
                                    var journalObj = [String: String]()
                                    journalObj["question"] = "None"
                                    journalObj["gratitude"] = journal
                                    journalObj["timeStamp"] = "12:00 AM"
                                    dataArr.append(journalObj)
                                }
                            }
                        
                        
                        entireHistory.append(([Int(day) ?? 1, Int(mo) ?? 1, Int(key) ?? 2022], dataArr)) // append day data and attach date
                    }
                }
            }
            yearSortDict[key] = yearIds
            // TODO get old timestamp sorting code from github
//            UserDefaults.standard.setValue(ids, forKey: "recent")
            // TODO instead of timestamp, save entire date.
        }
        
        entireHistory = entireHistory.sorted { (lhs, rhs) in
            let date1 = lhs.0
            let date2 = rhs.0
            if  date1[2] == date2[2] { //same year
                if date1[1] == date2[1] { // same month
                    return date1[0] > date2[0]
                }
                return date1[1] > date2[1]
            }
            return date1[2] > date2[2]
        }
    }

    func populateMonth() {
        totalMins = 0
        totalSessions = 0
        placeHolders = 0
        gratitudes = 0
        monthTiles = [Int: [Int: (Plant?, Mood?)]]()
        totalMoods = [Mood:Int]()
        favoritePlants = [String: Int]()
        var startsOnSunday = false
        let strMonth = String(selectedMonth)
        let numOfDays = Date().getNumberOfDays(month: strMonth, year: String(selectedYear))
        let intWeek = Date().weekDayToInt(weekDay: Date.dayOfWeek(day: "1", month: strMonth, year: String(selectedYear)))

        if intWeek != 0 {
            placeHolders = intWeek
        } else { //it starts on a sunday
            startsOnSunday = true
        }

        var weekNumber = 0
        for day in 1...numOfDays {
            let weekday = Date.dayOfWeek(day: String(day), month: strMonth, year: String(selectedYear))
            let weekInt = Date().weekDayToInt(weekDay: weekday)
            if weekInt == 0 && !startsOnSunday {
                weekNumber += 1
            } else if startsOnSunday {
                startsOnSunday = false
            }

            var plant: Plant? = nil
            var mood: Mood? = nil
            if let sessions = grid[String(selectedYear)]?[strMonth]?[String(day)]?[K.defaults.sessions] as? [[String: String]] {
                let fbPlant = sessions[sessions.count - 1][K.defaults.plantSelected]
                plant = Plant.allPlants.first(where: { $0.title == fbPlant })
                for session in sessions {
                    totalMins += (Double(session[K.defaults.duration] ?? "0.0") ?? 0).toInt() ?? 0
                    let plant = session[K.defaults.plantSelected] ?? ""
                    if var count = favoritePlants[plant] {
                        count += 1
                        favoritePlants[plant] = count
                    } else {
                        favoritePlants[plant] = 1
                    }
                }
                totalSessions += sessions.count
            }

            if let moods = grid[String(selectedYear)]?[strMonth]?[String(day)]?[K.defaults.moods] as? [[String: String]] {
                mood = Mood.getMood(str: moods[moods.count - 1]["mood"] ?? "bad")
                for forMood in moods {
                    let singleMood = Mood.getMood(str: forMood["mood"] ?? "bad")
                    if var count = totalMoods[singleMood] {
                        count += 1
                        totalMoods[singleMood] = count
                    } else {
                        totalMoods[singleMood] = 1
                    }
                }
            }
            if let gratitudez = grid[Date().get(.year)]?[strMonth]?[String(day)]?["gratitudes"] as? [String] {
                gratitudes += gratitudez.count
            }


            if let _ = monthTiles[weekNumber] {
                monthTiles[weekNumber]?[day] = (plant, mood)
            } else { // first for this week
                monthTiles[weekNumber] = [day: (plant,mood)]
            }
        }
    }
    
    func getLastFive() {
        let lastFive = Date.getDates(forLastNDays: 5)
        var returnFive = [(String, Plant?,Mood?)]()
        for day in 0...lastFive.count - 1 {
            let selMon = Int(lastFive[day].get(.month)) ?? 1
            let selYear = String(Int(lastFive[day].get(.year)) ?? 2021)
            let selDay = String(Int(lastFive[day].get(.day)) ?? 1)
            var plant: Plant? = nil
            var mood: Mood? = nil
            if let sessions = grid[selYear]?[String(selMon)]?[selDay]?[K.defaults.sessions] as? [[String: String]] {
                let fbPlant = sessions[sessions.count - 1][K.defaults.plantSelected]
                plant = Plant.allPlants.first(where: { $0.title == fbPlant })
            }

            if let moods = grid[selYear]?[String(selMon)]?[selDay]?[K.defaults.moods] as? [String] {
                mood = Mood.getMood(str: moods[moods.count - 1])
            }
            let dayString = Date().intToAbrev(weekDay: Int(lastFive[day].get(.weekday)) ?? 1 )
            returnFive.append((dayString, plant,mood))
        }

        self.lastFive = returnFive.reversed()
    }

    func updateSelf() {
        if let defaultRecents = UserDefaults.standard.value(forKey: "recent") as? [Int] {
            self.recentMeditations = Meditation.allMeditations.filter({ med in defaultRecents.contains(med.id) }).reversed()
        }

        if let email = Auth.auth().currentUser?.email {
            db.collection(K.userPreferences).document(email).getDocument { (snapshot, error) in
                if let document = snapshot, document.exists {
                    if let gardenGrid = document[K.defaults.gardenGrid] as? [String: [String:[String:[String:Any]]]] {
                        self.grid = gardenGrid
                        UserDefaults(suiteName: "group.io.bytehouse.mindgarden.widget")?.setValue(self.grid, forKey: "grid")
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                    self.getLastFive()
                    if let allTimeMins = document["totalMins"] as? Int {
                        self.allTimeMinutes = allTimeMins
                    }
                    if let allTimeSess = document["totalSessions"] as? Int {
                        self.allTimeSessions = allTimeSess
                    }
                    self.populateMonth()
                    self.getRecentMeditations()
                }
            }
        } else {
            if let gridd = UserDefaults.standard.value(forKey: "grid") as? [String: [String:[String:[String:Any]]]] {
                self.grid = gridd
            }
            getLastFive()
            if let allTimeMins = UserDefaults.standard.value(forKey: "allTimeMinutes") as? Int {
                self.allTimeMinutes = allTimeMins
            }
            if let allTimeSess = UserDefaults.standard.value(forKey: "allTimeSessions") as? Int {
                self.allTimeSessions = allTimeSess
            }
            self.populateMonth()
            self.getRecentMeditations()
            UserDefaults(suiteName: "group.io.bytehouse.mindgarden.widget")?.setValue(self.grid, forKey: "grid")
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    

    func save(key: String, saveValue: Any, date: Date = Date(), freeze: Bool = false, coins: Int,  completionHandler:  @escaping ()->Void = { }) {
        
        if key == "sessions" {
            if let session = saveValue as? [String: String] {
                if !freeze {  self.allTimeSessions += 1  }
                if let myNumber = (Double(session[K.defaults.duration] ?? "0.0") ?? 0).toInt() {
                    self.allTimeMinutes += myNumber
                }
            }
        }

        if let email = Auth.auth().currentUser?.email {
            let docRef = db.collection(K.userPreferences).document(email)
            docRef.getDocument { (snapshot, error) in
                
                if let document = snapshot, document.exists {
                    if let gardenGrid = document[K.defaults.gardenGrid] {
                        self.grid = gardenGrid as! [String: [String:[String:[String:Any]]]]
                    }
                    if let year = self.grid[date.get(.year)] {
                        if let month = year[date.get(.month)] {
                            if let day = month[date.get(.day)] {
                                if var values = day[key] as? [Any] {
                                    values.append(saveValue)
                                    self.grid[date.get(.year)]?[date.get(.month)]?[date.get(.day)]?[key] = values
                                } else { // first of that type today
                                    self.grid[date.get(.year)]?[date.get(.month)]?[date.get(.day)]?[key] = [saveValue]
                                }
                            } else { // first save of type that day
                                self.grid[date.get(.year)]?[date.get(.month)]?[date.get(.day)] = [key: [saveValue]]
                            }
                        } else { //first session of month
                            self.grid[date.get(.year)]?[date.get(.month)] = [date.get(.day): [key: [saveValue]]]
                        }
                    } else {
                        self.grid[date.get(.year)] = [date.get(.month): [date.get(.day): [key: [saveValue]]]]
                    }
                }

                self.db.collection(K.userPreferences).document(email).updateData([
                    "gardenGrid": self.grid,
                    "totalMins": self.allTimeMinutes,
                    "totalSessions": self.allTimeSessions,
                    "coins": coins,
                ]) { (error) in
                    if let e = error {
                        print("There was a issue saving data to firestore \(e) ")
                    } else {
                        self.updateData(completionHandler: completionHandler, key: key)
                    }
                }
            }
        } else {
            UserDefaults.standard.setValue(self.allTimeMinutes, forKey: "allTimeMinutes")
            UserDefaults.standard.setValue(self.allTimeSessions, forKey: "allTimeSessions")
            UserDefaults.standard.setValue(coins, forKey: "coins")
            if let gridd = UserDefaults.standard.value(forKey: "grid") as? [String: [String:[String:[String:Any]]]] {
                self.grid = gridd
            }
            if let year = self.grid[date.get(.year)] {
                if let month = year[date.get(.month)] {
                    if let day = month[date.get(.day)] {
                        if var values = day[key] as? [Any] {
                            //["plantSelected" : "coogie", "meditationId":3]
                            values.append(saveValue)
                            self.grid[date.get(.year)]?[date.get(.month)]?[date.get(.day)]?[key] = values
                        } else { // first of that type today
                            self.grid[date.get(.year)]?[date.get(.month)]?[date.get(.day)]?[key] = [saveValue]
                        }
                    } else { // first save of type that day
                        self.grid[date.get(.year)]?[date.get(.month)]?[date.get(.day)] = [key: [saveValue]]
                    }
                } else { //first session of month
                    self.grid[date.get(.year)]?[date.get(.month)] = [date.get(.day): [key: [saveValue]]]
                }
            } else {
                self.grid[date.get(.year)] = [date.get(.month): [date.get(.day): [key: [saveValue]]]]
            }
            self.updateData(completionHandler: completionHandler, key: key)
        }
    }
    
    private func updateData(completionHandler: ()->Void = { }, key: String) {
        UserDefaults.standard.setValue(self.grid, forKey: "grid")
        UserDefaults(suiteName: "group.io.bytehouse.mindgarden.widget")?.setValue(self.grid, forKey: "grid")
        WidgetCenter.shared.reloadAllTimelines()
        self.populateMonth()
        self.getLastFive()
        if key == "sessions" {
            self.getRecentMeditations()
        }
        completionHandler()
    }
}


