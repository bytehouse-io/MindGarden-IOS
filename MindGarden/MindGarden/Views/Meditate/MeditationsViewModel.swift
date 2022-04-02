//
//  MeditationsViewModel.swift
//  MindGarden
//
//  Created by Dante Kim on 7/15/21.
//

import SwiftUI
import Combine
import Firebase
import AVKit
import FirebaseFirestore
import OneSignal

class MeditationViewModel: ObservableObject {
    @Published var selectedMeditations: [Meditation] = []
    @Published var favoritedMeditations: [Meditation] = []
    @Published var newMeditations:  [Meditation] = []
    @Published var weeklyMeditation: Meditation?
    @Published var featuredMeditation: Meditation?
    @Published var selectedMeditation: Meditation? = Meditation(title: "Timed Meditation", description: "Timed unguided (no talking) meditation, with the option to turn on background noises such as rain. A bell will signal the end of your session.", belongsTo: "none", category: .unguided, img: Img.daisy3, type: .course, id: 0, duration: 0, reward: 0, url: "", instructor: "None",  imgURL: "", isNew: false)
    @Published var selectedCategory: Category? = .all
    @Published var isFavorited: Bool = false
    @Published var playImage: Image = Img.seed
    @Published var recommendedMeds: [Meditation] = []
    var viewRouter: ViewRouter?
    var selectedPlant: Plant?
    //user needs to meditate at least 5 mins for plant
    var isOpenEnded = false
    var totalTime: Float = 0
    var bellPlayer: AVAudioPlayer!
    @Published var secondsRemaining: Float = 0
    @Published var secondsCounted: Float = 0
    //animation glitch with a picture so added this var to trigger it manually
    @Published var lastSeconds: Bool = false
    var timer: Timer = Timer()
    var forwardCounter = 0
    var isStreakUpdate = true

    private var validationCancellables: Set<AnyCancellable> = []
    let db = Firestore.firestore()

    func checkIfFavorited() {
        isFavorited = self.favoritedMeditations.contains(self.selectedMeditation!) ? true : false
    }

    init() {
        $selectedCategory
            .sink { [unowned self] value in
                if value == .all { self.selectedMeditations =  Meditation.allMeditations.filter { $0.type != .lesson }.reversed()
                } else {
                    self.selectedMeditations = Meditation.allMeditations.filter { med in
                        if value == .courses && (med.title == "Intro to Meditation" || med.title == "The Basics Course" ) {
                            return true
                        } else {
                            return med.category == value && med.type != .lesson
                        }
                    }
                }
            }
            .store(in: &validationCancellables)

        $selectedMeditation
            .sink { [unowned self] value in 
                if value?.type == .course {
                    selectedMeditations = Meditation.allMeditations.filter { med in med.belongsTo == value?.title }
                }
                secondsRemaining = value?.duration ?? 0
                totalTime = secondsRemaining
            }
            .store(in: &validationCancellables)
        getFeaturedMeditation()
        getRecommendedMeds()
    }

    func getFeaturedMeditation()  {
        var filtedMeds = Meditation.allMeditations.filter { med in
            med.type != .lesson && med.id != 22 && med.id != 45 && med.id != 55 && med.id != 56  && med.type != .weekly}
        if Calendar.current.component( .hour, from:Date() ) < 16 {
            filtedMeds = filtedMeds.filter { med in // day time meds only
            med.id != 27 && med.id != 54 && med.id != 39 }
        }
        if Calendar.current.component(.hour, from: Date()) > 11 { // not morning
            filtedMeds = filtedMeds.filter { med in
                med.id != 53 && med.id != 49
            }
        }
        if UserDefaults.standard.bool(forKey: "intermediateCourse") {
            filtedMeds = filtedMeds.filter { med in
                med.id != 15 && med.id != 16 && med.id != 17 && med.id != 18 && med.id != 19 && med.id != 20 && med.id != 21 && med.id != 14
            }
        }
        if UserDefaults.standard.string(forKey: "experience") == "Have tried to meditate" ||  UserDefaults.standard.string(forKey: "experience") == "Have never meditated" {
            if !UserDefaults.standard.bool(forKey: "beginnerCourse") {
                if UserDefaults.standard.integer(forKey: "launchNumber") <= 5 {
                    featuredMeditation = Meditation.allMeditations.first(where: { med in med.id == 6 })
                } else {
                    setFeaturedReason()
                }
            } else if !UserDefaults.standard.bool(forKey: "intermediateCourse") {
                if UserDefaults.standard.integer(forKey: "launchNumber") <= 5 {
                    featuredMeditation = Meditation.allMeditations.first(where: { med in med.id == 14 })
                } else {
                    setFeaturedReason()
                }
            } else {
                setFeaturedReason()
            }
        } else {
            if UserDefaults.standard.integer(forKey: "launchNumber") <= 3 {
                featuredMeditation = Meditation.allMeditations.first(where: { med in
                    med.id == 2
                })
            } else {
                setFeaturedReason()
            }
        }
    }

    private func setFeaturedReason() {
        var filtedMeds = Meditation.allMeditations.filter { med in
            med.type != .lesson && med.id != 22 && med.id != 45 && med.id != 55 && med.id != 56 && med.type != .weekly }
        if Calendar.current.component( .hour, from:Date() ) < 18 {
            filtedMeds = filtedMeds.filter { med in // day time meds only
            med.id != 27 && med.id != 54 && med.id != 39 }
        }
        if Calendar.current.component(.hour, from: Date()) > 11 { // not morning
            filtedMeds = filtedMeds.filter { med in
                med.id != 53 && med.id != 49
            }
        }
        if UserDefaults.standard.bool(forKey: "intermediateCourse") {
            filtedMeds = filtedMeds.filter { med in
                med.id != 15 && med.id != 16 && med.id != 17 && med.id != 18 && med.id != 19 && med.id != 20 && med.id != 21 && med.id != 14
            }
        }
        switch UserDefaults.standard.string(forKey: "reason") {
        case "Sleep better":
            if Calendar.current.component( .hour, from:Date() ) >= 18 {
                filtedMeds = filtedMeds.filter { med in // day time meds only
                    med.id == 27 || med.id == 54 || med.id == 39 }
            }
            let randomInt = Int.random(in: 0..<filtedMeds.count)
            featuredMeditation = filtedMeds[randomInt]
        case "Get more focused":
            filtedMeds = filtedMeds.filter { med in
                med.category == .focus
            }
            let randomInt = Int.random(in: 0..<filtedMeds.count)
            featuredMeditation = filtedMeds[randomInt]
        case "Managing Stress & Anxiety":
            filtedMeds = filtedMeds.filter { med in
                med.category == .anxiety
            }
            let randomInt = Int.random(in: 0..<filtedMeds.count)
            featuredMeditation = filtedMeds[randomInt]
        case "Just trying it out":
            filtedMeds = filtedMeds.filter { med in
                med.category == .beginners
            }
            let randomInt = Int.random(in: 0..<filtedMeds.count)
            featuredMeditation = filtedMeds[randomInt]
        default:
            let randomInt = Int.random(in: 0..<filtedMeds.count)
            featuredMeditation = filtedMeds[randomInt]
        }
    }

    private func getRecommendedMeds() {
        var filteredMeds = Meditation.allMeditations.filter { med in med.type != .lesson && med.id != 6 && med.id != 14 && med.id != 22 && med.id != 45 && med.type != .weekly }
        if Calendar.current.component( .hour, from:Date() ) < 16 {
            filteredMeds = filteredMeds.filter { med in // day time meds only
                med.id != 27 && med.id != 54 && med.id != 39 && med.id != 55 && med.id != 56 }
        }
        if Calendar.current.component(.hour, from: Date()) > 11 { // not morning
            filteredMeds = filteredMeds.filter { med in
                med.id != 53 && med.id != 49
            }
        }
        if UserDefaults.standard.bool(forKey: "intermediateCourse") || self.selectedMeditation?.id == 14 {
            filteredMeds = filteredMeds.filter { med in
                med.id != 15 && med.id != 16 && med.id != 17 && med.id != 18 && med.id != 19 && med.id != 20 && med.id != 21
            }
        }
        if UserDefaults.standard.string(forKey: "experience") == "Have tried to meditate" ||  UserDefaults.standard.string(forKey: "experience") == "Have never meditated" {
            if !UserDefaults.standard.bool(forKey: "beginnerCourse") {
                filteredMeds = filteredMeds.filter { med in med.type != .lesson && med.id != 22 && med.type != .weekly}
            } else if !UserDefaults.standard.bool(forKey: "intermediateCourse") {
                filteredMeds = filteredMeds.filter { med in med.type != .lesson && med.id != 14 && med.id != 22 && med.type != .weekly }
            }
        }
        let randomInt = Int.random(in: 0..<filteredMeds.count)
        var randomInt2 =  Int.random(in: 0..<filteredMeds.count)
        while randomInt2 == randomInt {
            randomInt2 = Int.random(in: 0..<filteredMeds.count)
        }
        recommendedMeds = [filteredMeds[randomInt], filteredMeds[randomInt2]]
    }


    func updateSelf() {
        if let defaultFavorites = UserDefaults.standard.value(forKey: K.defaults.favorites) as? [Int] {
            self.favoritedMeditations = Meditation.allMeditations.filter({ med in defaultFavorites.contains(med.id) }).reversed()
        }
        if let email = Auth.auth().currentUser?.email {
            db.collection(K.userPreferences).document(email).getDocument { (snapshot, error) in
                if let document = snapshot, document.exists {
                    if let favorites = document[K.defaults.favorites] as? [Int] {
                        self.favoritedMeditations = Meditation.allMeditations.filter({ med in favorites.contains(med.id) }).reversed()
                    }
                }
            }
        }
    }

    func favorite(selectMeditation: Meditation) {
        if let email = Auth.auth().currentUser?.email {
            let docRef = db.collection(K.userPreferences).document(email)
            //Read Data from firebase, for syncing
            var favorites: [Int] = []
            docRef.getDocument { (snapshot, error) in
                if let document = snapshot, document.exists {
                    if let favorited = document[K.defaults.favorites] {
                        favorites = favorited as! [Int]
                    }
                    if favorites.contains(where: { id in id == selectMeditation.id }) {
                        favorites.removeAll { fbId in
                            return fbId == selectMeditation.id
                        }
                        self.favoritedMeditations.removeAll { med in
                            med.id == selectMeditation.id
                        }
                    } else {
                        self.favoritedMeditations.insert(selectMeditation, at: 0)
                        favorites.insert(selectMeditation.id, at: 0)
                    }
                    self.checkIfFavorited()
                }
                UserDefaults.standard.setValue(favorites, forKey: K.defaults.favorites)
                self.db.collection(K.userPreferences).document(email).updateData([
                    "favorited": favorites,
                ]) { (error) in
                    if let e = error {
                        print("There was a issue saving data to firestore \(e) ")
                    } else {
                        print("Succesfully saved meditations")
                    }
                }
            }
        } else {
            if var favorites = UserDefaults.standard.value(forKey: K.defaults.favorites) as? [Int] {
                if favorites.contains(where: { id in id == selectMeditation.id }) {
                    favorites.removeAll { fbId in
                        return fbId == selectMeditation.id
                    }
                    self.favoritedMeditations.removeAll { med in
                        med.id == selectMeditation.id
                    }
                } else {
                    self.favoritedMeditations.insert(selectMeditation, at: 0)
                    favorites.insert(selectMeditation.id, at: 0)
                }
                self.checkIfFavorited()
                UserDefaults.standard.setValue(favorites, forKey: K.defaults.favorites)
            } else {
                var favorites = [Int]()
                self.favoritedMeditations.insert(selectMeditation, at: 0)
                favorites.insert(selectMeditation.id, at: 0)
                UserDefaults.standard.setValue(favorites, forKey: K.defaults.favorites)
            }
        }
    }

    func getReward() -> Int {
        let duration = selectedMeditation?.duration ?? 0
        var reward = 0
        if (forwardCounter > 2 && duration <= 120) || (forwardCounter > 6)  {
            reward = 0
            isStreakUpdate = false
        } else if selectedMeditation?.duration == -1 {
            switch secondsRemaining {
            case 0...299: reward = 1
            case 300...599: reward = 5
            case 600...899: reward = 10
            case 900...1199: reward = 12
            case 1200...1499: reward = 15
            case 1500...1799: reward = 18
            default: reward = 20
            }
        } else {
            reward = selectedMeditation?.reward ?? 0
        }
        return reward
    }
}
