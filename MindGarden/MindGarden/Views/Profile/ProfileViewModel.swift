//
//  ProfileViewModel.swift
//  MindGarden
//
//  Created by Dante Kim on 8/31/21.
//

import Combine
import Firebase
import FirebaseAuth
import Foundation
//import Purchases
import Swift

class ProfileViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = true
    @Published var signUpDate: String = ""
    @Published var totalMins: Int = 0
    @Published var totalSessions: Int = 0
    @Published var name: String = ""
    @Published var showWidget: Bool = false

    init() {}

    func update(userModel: UserViewModel, gardenModel: GardenViewModel) {
        signUpDate = userModel.joinDate
        name = userModel.name
        totalMins = gardenModel.allTimeMinutes
        totalSessions = gardenModel.allTimeSessions
    }

    func signOut() {
        do { try Auth.auth().signOut() }
        catch { print("already logged out") }

        UserDefaults.deleteAll()
        DefaultsManager.standard.set(value: false, forKey: .loggedIn)
        DefaultsManager.standard.set(value: "White Daisy", forKey: .selectedPlant)
        DefaultsManager.standard.set(value: false, forKey: .isPro)
        DefaultsManager.standard.set(value: "", forKey: .onboarding)
        DefaultsManager.standard.set(value: "432hz", forKey: .sound)
        DefaultsManager.standard.set(value: 50, forKey: .coins)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd,yyyy"
        DefaultsManager.standard.set(value: formatter.string(from: Date()), forKey: .joinDate)
    }
}
