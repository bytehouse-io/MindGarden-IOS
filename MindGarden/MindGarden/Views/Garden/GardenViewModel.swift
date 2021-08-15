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
    @Published var tiles = []
    let db = Firestore.firestore()
//    let formatter: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.dateFormat = ""
//    }



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

    func saveGratitude(gratitude: String) {

    }
}
