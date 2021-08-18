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
    @Published var selectedMonth: String = ""
    @Published var isYear: Bool = false
    @Published var selectedYear: String = ""
    @Published var monthTiles = [Int: [Int: (Plant?, Mood?)]]()
    let db = Firestore.firestore()
//    let formatter: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.dateFormat = ""
//    }

    init() {
        selectedMonth = Date().get(.month)
        selectedYear = Date().get(.year)
        populateMonth()
    }

    func populateMonth() {
        let numOfDays = Date().getNumberOfDays(month: selectedMonth, year: selectedYear)
        let weekday = Date.dayOfWeek(day: "1", month: selectedMonth, year: selectedYear)
        let weekInt = Date().weekDayToInt(weekDay: weekday)
        for idx in 0...weekInt {
            monthTiles[0] = [idx: (nil,nil)]
        }
        var weekNumber = 0
        for day in 1...numOfDays {
            let weekday = Date.dayOfWeek(day: String(day), month: selectedMonth, year: selectedYear)
            let weekInt = Date().weekDayToInt(weekDay: weekday)
            if weekInt == 0 {
                weekNumber += 1
            }
            var plant: Plant? = nil
            var mood: Mood? = nil
            if let session = grid[selectedYear]?[selectedMonth]?[String(day)]?[K.defaults.sessions] as? [String: String] {
                let fbPlant = session[K.defaults.plantSelected]
                plant = Plant.plants.first(where: { $0.title ==  fbPlant })
            }
            if let moods = grid[selectedYear]?[selectedMonth]?[String(day)]?[K.defaults.moods] as? [String] {
                mood = Mood.getMood(str: moods[moods.count - 1])
            }
            monthTiles[weekNumber] = [day: (plant, mood)]
            monthTiles[Int(selectedMonth) ?? 0] = [day: (nil,nil)]
        }
    }
 
    func updateSelf() {
        if let email = Auth.auth().currentUser?.email {
            db.collection(K.userPreferences).document(email).getDocument { (snapshot, error) in
                if let document = snapshot, document.exists {
                    if let gardenGrid = document[K.defaults.gardenGrid] as? [String: [String:[String:[String:Any]]]] {
                        self.grid = gardenGrid
                    }
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
                            self.grid[Date().get(.year)]?[Date().get(.month)] = [Date().get(.month): [key: [saveValue]]]
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
