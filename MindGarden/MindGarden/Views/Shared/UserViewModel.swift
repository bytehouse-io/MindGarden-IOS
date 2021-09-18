//
//  UserViewModel.swift
//  MindGarden
//
//  Created by Dante Kim on 7/25/21.
//

import Foundation
import Combine
import Firebase

class UserViewModel: ObservableObject {
    @Published var coins: Int = 0
    @Published var ownedPlants: [Plant] = [Plant(title: "Red Tulips", price: 90, selected: false, description: "Tulips are a genus of spring-blooming perennial herbaceous bulbiferous geophytes. The flowers are usually large, showy and brightly colored, generally red, pink, yellow, or white. ", packetImage: Img.redTulipsPacket, coverImage: Img.redTulips3, head: Img.redTulipHead)]
    @Published var selectedPlant: Plant?
    @Published var willBuyPlant: Plant?
    private var validationCancellables: Set<AnyCancellable> = []

    var name: String = ""
    var joinDate: String = ""
    let db = Firestore.firestore()

    init() {
        getSelectedPlant()
    }

    func getSelectedPlant() {
        if let plantTitle = UserDefaults.standard.string(forKey: K.defaults.selectedPlant) {
            self.selectedPlant = Plant.plants.filter({ plant in
                return plant.title == plantTitle
            })[0]
        }
    }

    func updateSelf() {
        if let email = Auth.auth().currentUser?.email {
            db.collection(K.userPreferences).document(email).getDocument { (snapshot, error) in
                if let document = snapshot, document.exists {
                    if let coins = document[K.defaults.coins] as? Int {
                        self.coins = coins
                    }
                    if let fbPlants = document[K.defaults.plants] as? [String] {
                        self.ownedPlants = Plant.plants.filter({ plant in
                            if let _ = fbPlants.firstIndex(where: { $0 == plant.title }) {
                                return true
                            }
                            return false
                        })
                    }
                }
            }
        }
        
        //set selected plant
        selectedPlant = Plant.plants.first(where: { plant in
            return plant.title == UserDefaults.standard.string(forKey: K.defaults.selectedPlant)
        })
    }

    func buyPlant() {
        coins -= willBuyPlant?.price ?? 0
        if let plant = willBuyPlant {
            ownedPlants.append(plant)
            selectedPlant = willBuyPlant
            var finalPlants: [String] = [String]()
            if let email = Auth.auth().currentUser?.email {
                let docRef = db.collection(K.userPreferences).document(email)
                docRef.getDocument { (snapshot, error) in
                    if let document = snapshot, document.exists {
                        if let plants = document[K.defaults.plants] as? [String] {
                            finalPlants = plants
                        }
                        finalPlants.append(plant.title)
                    }
                    self.db.collection(K.userPreferences).document(email).updateData([
                        K.defaults.plants: finalPlants,
                        K.defaults.coins: self.coins
                    ]) { (error) in
                        if let e = error {
                            print("There was a issue saving data to firestore \(e) ")
                        } else {
                            print("Succesfully saved user model")
                        }
                    }
                }
            }
        }
    }
}
