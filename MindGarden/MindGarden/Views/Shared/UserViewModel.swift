//
//  UserViewModel.swift
//  MindGarden
//
//  Created by Dante Kim on 7/25/21.
//

import Foundation
import Combine
import Firebase

var userCoins: Int = 0
class UserViewModel: ObservableObject {
    @Published var ownedPlants: [Plant] = [Plant(title: "White Daisy", price: 100, selected: false, description: "With their white petals and yellow centers, white daisies symbolize innocence and the other classic daisy traits, such as babies, motherhood, hope, and new beginnings.", packetImage: Img.daisyPacket, one: Img.daisy1, two: Img.daisy2, coverImage: Img.daisy3, head: Img.daisyHead, badge: Img.daisyBadge)]
    @Published var selectedPlant: Plant?
    @Published var willBuyPlant: Plant?
    private var validationCancellables: Set<AnyCancellable> = []

    var name: String = ""
    var joinDate: String = ""
    var greeting: String = ""
    let db = Firestore.firestore()

    init() {
        getSelectedPlant()
        getGreeting()
    }

    func getSelectedPlant() {
        if let plantTitle = UserDefaults.standard.string(forKey: K.defaults.selectedPlant) {
            self.selectedPlant = Plant.plants.first(where: { plant in
                return plant.title == plantTitle
            })
        }
    }

    func updateSelf() {
        if let defaultName = UserDefaults.standard.string(forKey: "name") {
            self.name = defaultName
        }
        if let coins = UserDefaults.standard.value(forKey: "coins") as? Int {
            userCoins = coins
        }
        
        if let email = Auth.auth().currentUser?.email {
            db.collection(K.userPreferences).document(email).getDocument { (snapshot, error) in
                if let document = snapshot, document.exists {
                    if let joinDate = document[K.defaults.joinDate] as? String {
                        self.joinDate = joinDate
                    }

                    if let coins = document[K.defaults.coins] as? Int {
                        userCoins = coins
                        UserDefaults.standard.set(userCoins, forKey: "coins")
                    }

                    if let name = document["name"] as? String {
                        self.name = name
                        UserDefaults.standard.set(self.name, forKey: "name")
                        tappedSignIn = false
                    }

                    if let fbPlants = document[K.defaults.plants] as? [String] {
                        self.ownedPlants = Plant.plants.filter({ plant in
                            return fbPlants.contains(where: { str in
                                plant.title == str
                            })
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

    func getGreeting() {
        let hour = Calendar.current.component( .hour, from:Date() )

        if hour < 11 {
            greeting = "Good Morning"
        }
        else if hour < 16 {
            greeting = "Good Afternoon"
        }
        else {
            greeting = "Good Evening"
        }
    }

    func buyPlant(isUnlocked: Bool = false) {
        userCoins -= willBuyPlant?.price ?? 0
        if let plant = willBuyPlant {
            ownedPlants.append(plant)
            if !isUnlocked {
                selectedPlant = willBuyPlant
            }
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
                        K.defaults.coins: userCoins
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
