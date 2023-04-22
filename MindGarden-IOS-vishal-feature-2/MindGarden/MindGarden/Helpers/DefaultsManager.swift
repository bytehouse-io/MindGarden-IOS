//
//  DefaultsManager.swift
//  MindGarden
//
//  Created by apple on 22/04/23.
//

import Foundation

struct DefaultsManager {
    
    static var standard = DefaultsManager()
    
    private let standardDefaults = UserDefaults.standard
    private var value: Any? = nil
    private var lock = NSLock()
    
    private init() { }
    
    mutating func value(forKey key: Keys) -> Any? {
        lock.lock()
        value = standardDefaults.value(forKey: key.rawValue)
        lock.unlock()
        return value
    }
    
    func set(value: Any, forKey key: Keys) {
        lock.lock()
        standardDefaults.set(value, forKey: key.rawValue)
        lock.unlock()
    }
}

extension DefaultsManager {
    var boolValue: Bool {
        if let value = value as? Bool {
            return value
        } else {
            return false
        }
    }
    
    var stringValue: String {
        if let value = value as? String {
            return value
        } else {
            return ""
        }
    }
    
    var onboardingValue: OnboardingScreens? {
        let onbValue: OnboardingScreens? = enumValue()
        return onbValue
    }
}

extension DefaultsManager {
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
    }
}
