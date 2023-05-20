//
//  UserViewModel.swift
//  MindGarden
//
//  Created by Dante Kim on 7/25/21.
//

import Amplitude
import Combine
import Firebase
import FirebaseFirestore
import Foundation
//import Purchases
import WidgetKit
import MWMPublishingSDK

class UserViewModel: ObservableObject {
    @Published var ownedPlants: [Plant] = [Plant(title: "White Daisy", price: 100, selected: false, description: "With their white petals and yellow centers, white daisies symbolize innocence and the other classic daisy traits, such as babies, motherhood, hope, and new beginnings.", packetImage: Img.daisyPacket, one: Img.daisy1, two: Img.daisy2, coverImage: Img.daisy3, head: Img.daisyHead, badge: Img.daisyBadge), Plant(title: "Red Tulip", price: 900, selected: false, description: "🌷 Red Tulips are a genus of spring-blooming perennial herbaceous bulbiferous geophytes. Red tulips symbolize eternal love, undying love, perfect love, true love.", packetImage: Img.redTulipsPacket, one: Img.redTulips1, two: Img.redTulips2, coverImage: Img.redTulips3, head: Img.redTulipsHead, badge: Img.redTulipsBadge)]
    @Published var selectedPlant: Plant?
    @Published var willBuyPlant: Plant?
    @Published var streakFreeze = 0
    @Published var potion = ""
    @Published var chest = ""
    @Published var triggerAnimation = false
    @Published var timeRemaining = TimeInterval()
    @Published var isPotion: Bool = false
    @Published var isChest: Bool = false
    @Published var coins: Int = 0
    @Published var plantedTrees = [String]()
    @Published var showPlantAnimation = false
    @Published var showCoinAnimation = false
    @Published var completedMeditations: [String] = []
    @Published var journeyProgress: [String] = []
    @Published var show50Off = false
    @Published var referredCoins: Int = 0
    @Published var name: String = ""
    @Published var userCoinCollectedLevel: Int = 0
    @Published var journeyFinished = false
    @Published var selectedMood: Mood = .none
    @Published var elaboration: String = ""
    @Published var completedIntroDay = false
    @Published var completedEntireCourse = false
    @Published var completedDayTitle = ""
    @Published var showDay1Complete = false
    private var validationCancellables: Set<AnyCancellable> = []
    var joinDate: String = ""
    var greeting: String = ""
    var referredStack: String = ""
    let db = Firestore.firestore()
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter
    }()

    init() {
        getSelectedPlant()
        getGreeting()
        updateTimeRemaining()
        isIntroDone()
    }

    func isIntroDone() {
        // case where old = new means that it's not done, trigger is loaded for that day.

        if let oldSegs = UserDefaults.standard.array(forKey: "oldSegments") as? [String] { // brand new users
            if let oldIntroDay = oldSegs.first(where: { seg in seg.lowercased().contains("intro/day") }) {
                if let newSegs = UserDefaults.standard.array(forKey: "storySegments") as? [String] {
                    let newIntroDay = newSegs.first { seg in seg.lowercased().contains("intro/day") }
                    let components = oldIntroDay.components(separatedBy: " ")
                    completedDayTitle = components[1]
                    if oldIntroDay == newIntroDay {
                        if oldIntroDay.lowercased() == "intro/day 11" {
                            completedEntireCourse = true
                        } else {
                            completedIntroDay = false
                        }
                        // case where old != new => completed intro day course.
                    } else {
                        completedIntroDay = true
                    }
                }
            } else { // old users
//                var arr = oldSegs
//                arr.append("intro/day 2")
//                DefaultsManager.standard.set(value: arr, forKey: "oldSegments")
//                if let newSegs = UserDefaults.standard.array(forKey: "storySegments") as? [String] {
//                    var newArr = newSegs
//                    newArr.append("intro/day 2")
//                    DefaultsManager.standard.set(value: newArr, forKey: "storySegments")
//                }
//                completedDayTitle = "2"
//                completedIntroDay = false
//                storySegments = Set(arr)
//                StorylyManager.refresh()
            }
        }
    }

    func updateTimeRemaining() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        if let date = dateFormatter.date(from: potion), date > Date() {
            timeRemaining = date - Date()
            isPotion = timeRemaining > 0
        } else if let date = dateFormatter.date(from: chest), date > Date() {
            timeRemaining = date - Date()
            isChest = timeRemaining > 0
        }
    }

    func getSelectedPlant() {
        if let plantTitle = UserDefaults.standard.string(forKey: K.defaults.selectedPlant) {
            selectedPlant = Plant.allPlants.first(where: { plant in
                plant.title == plantTitle
            })
        }
    }

    func saveIAP() {
        if let email = Auth.auth().currentUser?.email {
            // Read Data from firebase, for syncing
            db.collection(K.userPreferences).document(email).updateData([
                "streakFreeze": streakFreeze,
                "potion": potion,
                "chest": chest,
            ]) { error in
                if let e = error {
                    print("There was a issue saving data to firestore \(e) ")
                } else {
                    print("Succesfully saved meditations")
                }
            }
        } else {
            DefaultsManager.standard.set(value: potion, forKey: .potion)
            DefaultsManager.standard.set(value: chest, forKey: .chest)
            DefaultsManager.standard.set(value: streakFreeze, forKey: .streakFreeze)
        }
    }

    func updateSelf() {
        if let defaultName = DefaultsManager.standard.value(forKey: .name).string {
            name = defaultName
        }

        if let coins = DefaultsManager.standard.value(forKey: .coins).integer {
            self.coins = coins
        }

        if let email = Auth.auth().currentUser?.email {
            db.collection(K.userPreferences).document(email).getDocument { [self] snapshot, _ in
                if let document = snapshot, document.exists {
                    if let joinDate = document[K.defaults.joinDate] as? String {
                        self.joinDate = joinDate
                    }

                    if let coins = document[K.defaults.coins] as? Int {
                        self.coins = coins
                        DefaultsManager.standard.set(value: coins, forKey: .coins)
                    }

                    if let name = document["name"] as? String {
                        self.name = name
                        DefaultsManager.standard.set(value: name, forKey: .name)
                        tappedSignIn = false
                    }

                    if let strFreeze = document["streakFreeze"] as? Int {
                        self.streakFreeze = strFreeze
                    }

                    if let fbPotion = document["potion"] as? String {
                        self.potion = fbPotion
                    }

                    if let fbChest = document["chest"] as? String {
                        self.chest = fbChest
                    }
                    if let fbTrees = document["plantedTrees"] as? [String] {
                        self.plantedTrees = fbTrees
                    }

                    if let refCoins = document["lastReferred"] as? Int {
                        self.referredCoins = refCoins
                    }
                    if let fbJourney = document["finishedJourney"] as? Bool {
                        self.journeyFinished = fbJourney
                    }
                    if let longestStreak = document["longestStreak"] as? Int {
                        DefaultsManager.standard.set(value: longestStreak, forKey: .longestStreak)
                    }

                    if let fbPlants = document[K.defaults.plants] as? [String] {
                        self.ownedPlants = Plant.allPlants.filter { plant in
                            fbPlants.contains(where: { str in
                                plant.title == str
                            })
                        }
                        DefaultsManager.standard.set(value: fbPlants, forKey: .plants)
                    }

                    if let stack = document["referredStack"] as? String {
                        self.referredStack = stack
                        let plusIndex = stack.indexInt(of: "+") ?? 0
                        let numRefs = Int(stack.substring(from: plusIndex + 1)) ?? 0

                        if numRefs > UserDefaults.standard.integer(forKey: "numRefs") {
                            showCoinAnimation = true
                            DefaultsManager.standard.set(value: numRefs, forKey: .numRefs)
                        }

                        if numRefs >= 1 && !UserDefaults.standard.bool(forKey: "referPlant") && !ownedPlants.contains(where: { plt in
                            plt.title == "Venus Fly Trap"
                        }) {
                            willBuyPlant = Plant.badgePlants.first(where: { $0.title == "Venus Fly Trap" })
                            buyPlant(unlockedStrawberry: true)
                            DefaultsManager.standard.set(value: true, forKey: .referPlant)
                            showPlantAnimation = true
                        }
                    }

                    if let completedMeditations = document[K.defaults.completedMeditations] as? [String] {
                        self.completedMeditations = completedMeditations
                        DefaultsManager.standard.set(value: completedMeditations, forKey: .completedMeditations)
                    }

                    if let level = document[K.defaults.userCoinCollectedLevel] as? Int {
                        self.userCoinCollectedLevel = level
                        SceneDelegate.medModel.getUserMap()
                        DefaultsManager.standard.set(value: level, forKey: .userCoinCollectedLevel)
                    }

                    self.updateTimeRemaining()
                }
            }
        } else {
            if let plants = UserDefaults.standard.value(forKey: K.defaults.plants) as? [String] {
                ownedPlants = Plant.allPlants.filter { plant in
                    plants.contains(where: { str in
                        plant.title == str
                    })
                }
            }

            if let name = DefaultsManager.standard.value(forKey: .name).string {
                self.name = name
            }

            if let joinDate = DefaultsManager.standard.value(forKey: .joinDate).string {
                self.joinDate = joinDate
            }
            if let potion = DefaultsManager.standard.value(forKey: .potion).string {
                self.potion = potion
            }
            if let chest = DefaultsManager.standard.value(forKey: .chest).string {
                self.chest = chest
            }
            if let completedMeditations = UserDefaults.standard.value(forKey: K.defaults.completedMeditations) as? [String] {
                self.completedMeditations = completedMeditations
            }

            if let level = UserDefaults.standard.value(forKey: K.defaults.userCoinCollectedLevel) as? Int {
                userCoinCollectedLevel = level
                SceneDelegate.medModel.getUserMap()
            }
            if let finJourney = DefaultsManager.standard.value(forKey: .finishedJourney).bool {
                journeyFinished = finJourney
            }

            streakFreeze = DefaultsManager.standard.value(forKey: .streakFreeze).integerValue

            coins = DefaultsManager.standard.value(forKey: .coins).integerValue
            updateTimeRemaining()
        }

        // set selected plant
        selectedPlant = Plant.allPlants.first(where: { plant in
            plant.title == DefaultsManager.standard.value(forKey: .selectedPlant).stringValue
        })
    }

    func shouldBeChecked(id: Int, roadMapArr: [Int], idx: Int) -> Bool {
        let meditation = Meditation.allMeditations.first { med in med.id == id } ?? Meditation.allMeditations[0]
        let dups = Dictionary(grouping: roadMapArr, by: { $0 }).filter { $1.count > 1 }.keys

        if meditation.type == .course {
            var entireCourse = Meditation.allMeditations.filter { med in med.belongsTo == meditation.title }
            entireCourse = entireCourse.sorted { med1, med2 in med1.id < med2.id }
            if completedMeditations.contains(String(entireCourse[entireCourse.count - 1].id)) {
                return true
            }
        }

        if dups.contains(meditation.id) { // is a repeat meditaiton
            var comMedCount = completedMeditations.filter { med in Int(med) == meditation.id }.count
            let startingIdx = roadMapArr.firstIndex(of: id) ?? 0
            let endingIdx = roadMapArr.lastIndex(of: id) ?? 0
            // [2,3,3,3] [4, 3, 3] comMedCount = 2, idx = 2, id = 3, end - start = 2 + 1 = 3

            for indx in startingIdx ... endingIdx {
                if comMedCount == 0 { return false } else {
                    if idx == indx {
                        return true
                    } else {
                        comMedCount -= 1
                    }
                }
            }
        } else if completedMeditations.contains(String(meditation.id)) {
            return true
        }
        return false
    }

    func finishedJourney() {
        journeyFinished = true
        if let email = Auth.auth().currentUser?.email {
            // Read Data from firebase, for syncing
            db.collection(K.userPreferences).document(email).updateData([
                "finishedJourney": true,
            ]) { error in
                if let e = error {
                    print("There was a issue saving data to firestore \(e) ")
                } else {
                    print("Succesfully saved meditations")
                }
            }
        } else {
            DefaultsManager.standard.set(value: true, forKey: .finishedJourney)
        }
    }

    func finishedMeditation(id: String) {
        completedMeditations.append(id)
        if let email = Auth.auth().currentUser?.email {
            db.collection(K.userPreferences).document(email).updateData([
                K.defaults.completedMeditations: completedMeditations,
            ])
        }
        DefaultsManager.standard.set(value: completedMeditations, forKey: .completedMeditations)
    }

    func getCourseCounter(title: String) -> Int {
        return Meditation.allMeditations.filter { $0.belongsTo == title }.filter { self.completedMeditations.contains("\($0.id)") }.count
    }

    private func buyBonsai() {
        if !UserDefaults.standard.bool(forKey: "bonsai") {
            userWentPro = true
            if !ownedPlants.contains(Plant.badgePlants.first(where: { plant in plant.title == "Bonsai Tree" }) ?? Plant.badgePlants[0]) {
                buyPlant(unlockedStrawberry: true)
            }
            DefaultsManager.standard.set(value: true, forKey: .bonsai)
        }
    }

    func modTitle() -> String {
        let title = selectedPlant?.title ?? "s"
        let endIdx = title.count
        if title[endIdx - 1] == "s" {
            return title
        } else {
            return "a " + title
        }
    }

    func checkIfPro() {
        // using mwm Publishing SDK
        let isUserPremium = MWM.inAppManager().isAnyPremiumFeatureUnlocked()
        if isUserPremium {
            DefaultsManager.standard.set(value: true, forKey: .isPro)
            UserDefaults(suiteName: K.widgetDefault)?.setValue(true, forKey: "isPro")
            WidgetCenter.shared.reloadAllTimelines()
            buyBonsai()
        } else {
            DefaultsManager.standard.set(value: false, forKey: .isPro)
            let identify = AMPIdentify()
                .set("plan_type", value: NSString(utf8String: "free"))
            Amplitude.instance().identify(identify ?? AMPIdentify())
            if UserDefaults.standard.bool(forKey: "freeTrial") && !UserDefaults.standard.bool(forKey: "freeTrialTo50") {
                // cancelled free trial
                show50Off = true
            }
        }
        // removing revenue cat purchase
//        Purchases.shared.purchaserInfo { [self] purchaserInfo, _ in
//            if purchaserInfo?.entitlements.all["isPro"]?.isActive == true {
//                DefaultsManager.standard.set(value: true, forKey: "isPro")
//                UserDefaults(suiteName: K.widgetDefault)?.setValue(true, forKey: "isPro")
//                WidgetCenter.shared.reloadAllTimelines()
//                buyBonsai()
//            } else {
//                DefaultsManager.standard.set(value: false, forKey: "isPro")
//                let identify = AMPIdentify()
//                    .set("plan_type", value: NSString(utf8String: "free"))
//                Amplitude.instance().identify(identify ?? AMPIdentify())
//                if UserDefaults.standard.bool(forKey: "freeTrial") && !UserDefaults.standard.bool(forKey: "freeTrialTo50") {
//                    // cancelled free trial
//                    show50Off = true
//                }
//            }
//        }
    }

    func getGreeting() {
        let hour = Calendar.current.component(.hour, from: Date())

        if hour < 11 {
            greeting = "Good Morning"
        } else if hour < 16 {
            greeting = "Good Afternoon"
        } else {
            greeting = "Good Evening"
        }
    }

    func buyPlant(isUnlocked _: Bool = false, unlockedStrawberry: Bool = false, realTree: Bool = false) {
        if let plant = willBuyPlant {
            if !unlockedStrawberry {
                coins -= willBuyPlant?.price ?? 0
                selectedPlant = willBuyPlant
                Amplitude.instance().logEvent("store_bought_plant", withEventProperties: ["plant": plant.title])
            }

            if unlockedStrawberry {
                triggerAnimation = true
                Amplitude.instance().logEvent("badge_unlocked_plant", withEventProperties: ["plant": plant.title])
            }

            ownedPlants.append(plant)

            if realTree {
                Analytics.shared.log(event: .store_bought_real_tree)
                plantedTrees.append(dateFormatter.string(from: Date()))
            }

            var finalPlants = [String]()
            if let email = Auth.auth().currentUser?.email {
                let docRef = db.collection(K.userPreferences).document(email)
                docRef.getDocument { snapshot, error in
                    if let document = snapshot, document.exists {
                        if let plants = document[K.defaults.plants] as? [String] {
                            finalPlants = plants
                        }
                        finalPlants.append(plant.title)
                    }

                    let uniquePlants = [String](Set(finalPlants))
                    self.db.collection(K.userPreferences).document(email).updateData([
                        K.defaults.plants: uniquePlants,
                        K.defaults.coins: self.coins,
                        "plantedTrees": self.plantedTrees,
                    ]) { error in
                        if let e = error {
                            print("There was a issue saving data to firestore \(e) ")
                        } else {
                            print("Succesfully saved user model")
                        }
                    }
                }
            } else {
                if let plants = UserDefaults.standard.value(forKey: K.defaults.plants) as? [String] {
                    var newPlants = plants
                    newPlants.append(plant.title)
                    DefaultsManager.standard.set(value: newPlants, forKey: .plants)
                } else {
                    var newPlants = ["White Daisy", "Red Tulips"]
                    newPlants.append(plant.title)
                    DefaultsManager.standard.set(value: newPlants, forKey: .plants)
                }
                DefaultsManager.standard.set(value: coins, forKey: .coins)
            }
        }
    }

    func getRefered() {
        if let email = Auth.auth().currentUser?.email, referredCoins > 0 {
            db.collection(K.userPreferences).document(email).updateData([
                "lastReferred": 0,
            ]) { error in
                if let e = error {
                    print("There was a issue saving data to firestore \(e) ")
                } else {
                    print("Succesfully saved user model")
                }
            }
        }
    }

    func getUserID() -> String? {
        return UserDefaults.standard.value(forKey: K.defaults.giftQuotaId) as? String ?? UUID().uuidString
    }

    func updateCoins(plusCoins: Int) {
        coins += plusCoins
        userCoinCollectedLevel += 1
        DefaultsManager.standard.set(value: coins, forKey: .coins)
        DefaultsManager.standard.set(value: userCoinCollectedLevel, forKey: .userCoinCollectedLevel)
        if let email = Auth.auth().currentUser?.email {
            db.collection(K.userPreferences).document(email).updateData([
                K.defaults.coins: coins,
                K.defaults.userCoinCollectedLevel: userCoinCollectedLevel,
            ]) { error in
                if let e = error {
                    print("There was a issue saving data to firestore \(e) ")
                } else {
                    print("Succesfully saved coin")
                }
            }
        }
    }
}
