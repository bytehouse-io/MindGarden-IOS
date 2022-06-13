//
//  JourneyModel.swift
//  MindGarden
//
//  Created by Vishal Davara on 11/06/22.
//

import SwiftUI
import Combine
import Firebase
import FirebaseFirestore


struct Journey: Codable,Identifiable {
    var id: String = UUID().uuidString
    let level: Int
    let medid: Int
    let index: Int
}

class JourneyModel: ObservableObject {
    @Published var currentJouney: Journey?
    @Published var allJourneys: [Journey] = []
    let db = Firestore.firestore()
    
    func getAllJourney(){
        if let email = Auth.auth().currentUser?.email {
            db.collection(K.journey).document(email).collection(K.defaults.journeys).getDocuments { [weak self] (querySnapshot, error) in
                if let err = error {
                    print("Error getting documents \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        var id = ""
                        var medID = 0
                        var level = 0
                        var index = 0
                        if let idx = document["id"] as? String {
                            id = idx
                        }
                        if let lev = document["level"] as? Int {
                            level = lev
                        }
                        if let ind = document["index"] as? Int {
                            index = ind
                        }
                        if let medid = document["medid"] as? Int {
                            medID = medid
                        }
                        let jrn = Journey(id: id, level: level, medid: medID, index: index)
                        self?.allJourneys.append(jrn)
                    }
                }
            }
        } else {
            if let data = UserDefaults.standard.data(forKey: K.defaults.journeys) {
                do {
                    let decoder = JSONDecoder()
                    let journeys = try decoder.decode([Journey].self, from: data)
                    self.allJourneys = journeys
                } catch {
                    print("Unable to Decode Note (\(error))")
                }
            }
        }
    }
    
    func addJourney(journey:Journey){
        self.allJourneys.append(journey)
        if let email = Auth.auth().currentUser?.email {
            self.db.collection(K.journey).document(email).collection(K.defaults.journeys).addDocument(data:[
                "id":journey.id,
                "level": journey.level,
                "index": journey.index,
                "medid": journey.medid,
            ]) { (err) in
                if err != nil {
                    print(err?.localizedDescription as Any)
                    return
                }
            }
        } else {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(self.allJourneys)
                UserDefaults.standard.set(data, forKey: K.defaults.journeys)
            } catch {
                print("Unable to Encode Array of Notes (\(error))")
            }
        }
    }
}
