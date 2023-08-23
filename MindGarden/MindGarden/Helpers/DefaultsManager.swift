//
//  DefaultsManager.swift
//  MindGarden
//
//  Created by apple on 22/04/23.
//

import Foundation

struct DefaultsManager {
    
    static var standard = DefaultsManager()
    
    private let standardDefaults: UserDefaults
    
    private init() {
        standardDefaults = UserDefaults.standard
    }
    
    mutating func value(forKey key: Keys) -> DefaultsValues {
        let defaultsValues = DefaultsValues(value: standardDefaults.value(forKey: key.rawValue))
        return defaultsValues
    }
    
    func set(value: Any, forKey key: Keys) {
        standardDefaults.set(value, forKey: key.rawValue)
        standardDefaults.synchronize()
    }
}

struct DefaultsValues {
    private var value: Any? = nil
    
    init(value: Any? = nil) {
        self.value = value
    }
    
    var bool: Bool? {
        value as? Bool
    }
    
    var boolValue: Bool {
        if let value = value as? Bool {
            return value
        } else {
            return false
        }
    }
    
    var string: String? {
        value as? String
    }
    
    var stringValue: String {
        if let value = value as? String {
            return value
        } else {
            return ""
        }
    }
    
    var integer: Int? {
        value as? Int
    }
    
    var integerValue: Int {
        if let value = value as? Int {
            return value
        } else {
            return 0
        }
    }
    
    var float: Float? {
        value as? Float
    }
    
    var floatValue: Float {
        if let value = value as? Float {
            return value
        } else {
            return 0
        }
    }
    
    var isNil: Bool {
        value == nil
    }
    
    var isNotNil: Bool {
        !isNil
    }
    
    var onboardingValue: DefaultsManager.OnboardingScreens? {
        let onbValue: DefaultsManager.OnboardingScreens? = enumValue()
        return onbValue
    }
    
    var arrayValue: [Any] {
        if let value = value as? [Any] {
            return value
        } else {
            return []
        }
    }
}

extension DefaultsValues {
    func enumValue<E: RawRepresentable>() -> E? {
        if let value = value as? E.RawValue {
            let enumCase = E(rawValue: value)
            return enumCase
        } else {
            return nil
        }
    }
}

extension DefaultsManager {
    enum Keys: String {
        case isPro
        case onboarding
        case review
        case favorites = "favorited"
        case name
        case plants
        case coins
        case joinDate
        case selectedPlant
        case gardenGrid
        case sessions
        case moods
        case journals
        case plantSelected
        case meditationId
        case duration
        case lastStreakDate
        case streak
        case seven
        case thirty
        case dailyBonus
        case meditationReminder
        case loggedIn
        case referred
        case completedMeditations
        case userCoinCollectedLevel
        case journeys
        case giftQuotaId
        case dailyLaunchNumber
        case reviewedApp
        case showWidget
        case fiveHundredBonus = "500bonus"
        case christmasLink
        case introLink
        case happinessLink
        case isNotifOn
        case notifOn
        case isPlayMusic
        case vibrationMode
        case backgroundAnimation
        case falseAppleId
        case appleAuthorizedUserIdKey
        case redditOne
        case launchNumber
        case storySegments
        case oldSegments
        case userDate
        case abTest
        case sound
        case frequency
        case notifTypes
        case newUser
        case ltd
        case day1
        case day2
        case day3
        case day4
        case day7
        case day
        case referTip
        case remindersOn
        case widgetTip
        case plusCoins
        case sevenDay
        case thirtyDay
        case longestStreak
        case updatedStreak
        case authx
        case firstStory
        case completedCourses
        case showedChallenge
//        case signedIn
        case mindful
        case reddit
        case tileDates
        case singleOnboarding1
        case numSessions
        case grid
        case playTutorialModal
        case backgroundVolume
        case bellVolume
        case saveProgress
        case day1Intro
        case day2Intro
        case day3Intro
        case day4Intro
        case day5Intro
        case day6Intro
        case unlockedCherry
        case tenDays = "10days"
        case beginnerCourse
        case intermediateCourse
        case storeTutorial
        case freeTrialTo50
        case freeTrial
        case fourteenDayModal = "14DayModal"
        case showedNotif
        case notif
        case referPlant
        case bonsai
        case reason1
        case reason
        case firstTap
        case onboarded
        case oneDayNotif
        case onboardingNotif
        case threeDayNotif
        case numGrads
        case allTimeMinutes
        case allTimeSessions
        case tappedRate
        case meditationGoal
        case numMoods
        case challengeDate
        case potion
        case chest
        case streakFreeze
        case numRefs
        case finishedJourney
        case selectedMood
        case elaboration
        case experience
        case showImages
        case tappedTile
        case showTip
        case hasBeenLaunchedBeforeFlag
        case fiftyTimer
    }
    
    enum OnboardingScreens: String {
        case signedUp
        case mood
        case gratitude
        case done
        case stats
        case garden
        case single
        case meditate
        case calendar
//        case loadingIllusion
    }
}
