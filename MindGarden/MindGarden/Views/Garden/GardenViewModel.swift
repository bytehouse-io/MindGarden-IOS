//
//  GardenViewModel.swift
//  MindGarden
//
//  Created by Dante Kim on 8/6/21.
//

import Combine
import Firebase

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
    let db = Firestore.firestore()

    init() {
        selectedMonth = Int(Date().get(.month)) ?? 1
        selectedYear = Int(Date().get(.year)) ?? 2021
    }

    func populateMonth() {
        totalMins = 0
        totalSessions = 0
        totalMoods = [Mood:Int]()
        favoritePlants = [String: Int]()
        let strMonth = String(selectedMonth)
        let numOfDays = Date().getNumberOfDays(month: strMonth, year: String(selectedYear))
        let intWeek = Date().weekDayToInt(weekDay: Date.dayOfWeek(day: "1", month: strMonth, year: String(selectedYear)))
        var startsOnSunday = false
        if intWeek != 0 {
            monthTiles[0] = [0: (nil,nil)]
            for idx in 1...intWeek {
                monthTiles = [0 : [idx: (nil,nil)]]
            }
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
                plant = Plant.plants.first(where: { $0.title == fbPlant })
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

            if let moods = grid[String(selectedYear)]?[strMonth]?[String(day)]?[K.defaults.moods] as? [String] {
                mood = Mood.getMood(str: moods[moods.count - 1])
                for forMood in moods {
                    let singleMood = Mood.getMood(str: forMood)
                    if var count = totalMoods[singleMood] {
                        count += 1
                        totalMoods[singleMood] = count
                    } else {
                        totalMoods[singleMood] = 1
                    }
                }
            }

            if let _ = monthTiles[weekNumber] {
                monthTiles[weekNumber]?[day] = (plant, mood)
            } else { // first for this week
                monthTiles[weekNumber] = [day: (plant,mood)]
            }
        }
    }
 
    func updateSelf() {
        if let email = Auth.auth().currentUser?.email {
            db.collection(K.userPreferences).document(email).getDocument { (snapshot, error) in
                if let document = snapshot, document.exists {
                    if let gardenGrid = document[K.defaults.gardenGrid] as? [String: [String:[String:[String:Any]]]] {
                        self.grid = gardenGrid
                    }
                    self.populateMonth()
                }
            }
        }
    }

    func save(key: String, saveValue: Any) {
        if let email = Auth.auth().currentUser?.email {
            let docRef = db.collection(K.userPreferences).document(email)
            docRef.getDocument { (snapshot, error) in
                if let document = snapshot, document.exists {
                    if let gardenGrid = document[K.defaults.gardenGrid] {
                        self.grid = gardenGrid as! [String: [String:[String:[String:Any]]]]
                    }
                    if let year = self.grid[Date().get(.year)] {
                        if let month = year[Date().get(.month)] {
                            if let day = month[Date().get(.day)] {
                                if var values = day[key] as? [Any] {
                                    //["plantSelected" : "coogie", "meditationId":3]
                                    values.append(saveValue)
                                    self.grid[Date().get(.year)]?[Date().get(.month)]?[Date().get(.day)]?[key] = values
                                } else { // first of that type today
                                    self.grid[Date().get(.year)]?[Date().get(.month)]?[Date().get(.day)]?[key] = [saveValue]
                                }
                            } else { // first save of type that day
                                self.grid[Date().get(.year)]?[Date().get(.month)]?[Date().get(.day)] = [key: [saveValue]]
                            }
                        } else { //first session of month
                            self.grid[Date().get(.year)]?[Date().get(.month)] = [Date().get(.day): [key: [saveValue]]]
                        }
                    } else {
                        self.grid[Date().get(.year)] = [Date().get(.month): [Date().get(.day): [key: [saveValue]]]]
                    }
                }
                self.db.collection(K.userPreferences).document(email).updateData([
                    "gardenGrid": self.grid,
                ]) { (error) in
                    if let e = error {
                        print("There was a issue saving data to firestore \(e) ")
                    } else {
                        print("Succesfully saved")
                    }
                }
            }
        }
    }
}
