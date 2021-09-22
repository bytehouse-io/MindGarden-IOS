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

class MeditationViewModel: ObservableObject {
    @Published var selectedMeditations: [Meditation] = []
    @Published var favoritedMeditations: [Meditation] = []
    @Published var recentMeditations: [Meditation] = []
    @Published var selectedMeditation: Meditation? = Meditation(title: "Timed Meditation", description: "Timed unguided (no talking) meditation, with the option to turn on background noises such as rain. A bell will signal the end of your session.", belongsTo: "none", category: .unguided, img: Img.daisy, type: .course, id: 0, duration: 0, reward: 0)
    @Published var courseMeditations: [Meditation] = []
    @Published var selectedCategory: Category? = .all
    @Published var isFavorited: Bool = false
    @Published var playImage: Image = Img.seed
    //user needs to meditate at least 5 mins for plant
    var isOpenEnded = false
    var totalTime: Float = 0
    var bellPlayer: AVAudioPlayer!
    @Published var secondsRemaining: Float = 0
    @Published var secondsCounted: Float = 0
    @Published var finishedMeditation: Bool = false
    @Published var featuredMeditation: Meditation?
    //animation glitch with a picture so added this var to trigger it manually
    @Published var lastSeconds: Bool = false
    var timer: Timer = Timer()
    private var validationCancellables: Set<AnyCancellable> = []
    let db = Firestore.firestore()

    func checkIfFavorited() {
        isFavorited = self.favoritedMeditations.contains(self.selectedMeditation!) ? true : false
    }

    init() {
        $selectedCategory
            .sink { [unowned self] value in
                if value == .all { self.selectedMeditations =  Meditation.allMeditations.filter { $0.type != .lesson }
                } else {
                    self.selectedMeditations = Meditation.allMeditations.filter     { med in med.category == value && med.type != .lesson }
                }
            }
            .store(in: &validationCancellables)

        $selectedMeditation
            .sink { [unowned self] value in 
                if value?.type == .course {
                    selectedMeditations = Meditation.allMeditations.filter { med in med.belongsTo == value?.title
                    }
                }
                secondsRemaining = value?.duration ?? 0
                totalTime = secondsRemaining
            }
            .store(in: &validationCancellables)

        getFeaturedMeditation()
    }

    private func getFeaturedMeditation()  {
        if UserDefaults.standard.string(forKey: "experience") == "Have tried to meditate" ||  UserDefaults.standard.string(forKey: "experience") == "Have never meditated" {
            if !UserDefaults.standard.bool(forKey: "beginnerCourse") {
                featuredMeditation = Meditation.allMeditations.first(where: { med in med.id == 6 })
            } else if !UserDefaults.standard.bool(forKey: "intermediateCourse") {
                featuredMeditation = Meditation.allMeditations.first(where: { med in med.id == 14 })
            }
        } else {
            featuredMeditation = Meditation.allMeditations[0]
        }
    }

    func updateSelf() {
        if let defaultFavorites = UserDefaults.standard.value(forKey: K.defaults.favorites) as? [Int] {
            self.favoritedMeditations = Meditation.allMeditations.filter({ med in defaultFavorites.contains(med.id) })
        }
        if let email = Auth.auth().currentUser?.email {
            db.collection(K.userPreferences).document(email).getDocument { (snapshot, error) in
                if let document = snapshot, document.exists {
                    if let favorites = document[K.defaults.favorites] as? [Int] {
                        self.favoritedMeditations = Meditation.allMeditations.filter({ med in favorites.contains(med.id) })
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
                        self.favoritedMeditations.append(selectMeditation)
                        favorites.append(selectMeditation.id)
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
        }
    }


    //MARK: - timer
    func startCountdown() {
        bellPlayer.prepareToPlay()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
            self.secondsRemaining -= 1
            withAnimation {
                if secondsRemaining <= totalTime * 0.25 { //15 = 0
                    lastSeconds = true
                    playImage = Img.redTulips3
                } else if secondsRemaining <= totalTime * 0.5 { //30 - 15
                    playImage = Img.redTulips2
                } else if secondsRemaining <= totalTime * 0.75 { //45-30
                    playImage = Img.redTulips1
                } else { //60 - 45
                    playImage = Img.seed
                }
                if secondsRemaining <= 0 {
                    bellPlayer.play()
                    stop()
                    finishedMeditation = true
                    if self.selectedMeditation?.id == 13 {
                        UserDefaults.standard.setValue(true, forKey: "beginnerCourse")
                    } else if self.selectedMeditation?.id == 21 {
                        UserDefaults.standard.setValue(true, forKey: "intermediateCourse")
                    }
//                    viewRouter.currentPage = .finished
                    return
                }
            }
        }
        timer.fire()
    }

    func stop() {
        timer.invalidate()
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in self.secondsCounted += 1 }
        timer.fire()
    }


    func secondsToMinutesSeconds (totalSeconds: Float) -> String {
        let minutes = Int(totalSeconds / 60)
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        return String(format:"%02d:%02d", minutes, seconds)
    }
}
