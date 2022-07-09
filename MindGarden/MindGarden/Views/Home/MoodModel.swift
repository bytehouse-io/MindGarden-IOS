//
//  JourneyModel.swift
//  MindGarden
//
//  Created by Vishal Davara on 06/07/22.
//

import SwiftUI
import Combine
import Firebase
import FirebaseFirestore


struct MoodData: Codable,Identifiable {
    var id: String = UUID().uuidString
    let date: String
    let mood: String
    let subMood: String
}

class MoodModel: ObservableObject {
    @Published var moodList: [MoodData] = []
    let db = Firestore.firestore()
    
    func getAllMoods(){
        if let email = Auth.auth().currentUser?.email {
            db.collection(K.mood).document(email).collection(K.defaults.moods).getDocuments { [weak self] (querySnapshot, error) in
                if let err = error {
                    print("Error getting documents \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        var ids = ""
                        var date = ""
                        var mood = ""
                        var subMood = ""
                        
                        if let idx = document["id"] as? String {
                            ids = idx
                        }
                        if let dt = document["date"] as? String {
                            date = dt
                        }
                        if let ind = document["mood"] as? String {
                            mood = ind
                        }
                        if let subMd = document["subMood"] as? String {
                            subMood = subMd
                        }
                        let moodObj = MoodData(id:ids, date: date, mood: mood, subMood: subMood)
                        self?.moodList.append(moodObj)
                    }
                }
            }
        } else {
            if let data = UserDefaults.standard.data(forKey: K.defaults.moods) {
                do {
                    let decoder = JSONDecoder()
                    let moods = try decoder.decode([MoodData].self, from: data)
                    self.moodList = moods
                } catch {
                    print("Unable to Decode Note (\(error))")
                }
            }
        }
    }
    
    func addMood(mood:MoodData){
        self.moodList.append(mood)
        if let email = Auth.auth().currentUser?.email {
            self.db.collection(K.mood).document(email).collection(K.defaults.moods).addDocument(data:[
                "id":mood.id,
                "date": mood.date,
                "mood": mood.mood,
                "subMood": mood.subMood,
            ]) { (err) in
                if err != nil {
                    print(err?.localizedDescription as Any)
                    return
                }
                print("mood saved successfully")
            }
        } else {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(self.moodList)
                UserDefaults.standard.set(data, forKey: K.defaults.moods)
            } catch {
                print("Unable to Encode Array of moods (\(error))")
            }
        }
    }
}

