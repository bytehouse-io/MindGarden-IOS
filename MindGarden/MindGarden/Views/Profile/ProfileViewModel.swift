//
//  ProfileViewModel.swift
//  MindGarden
//
//  Created by Dante Kim on 8/31/21.
//

import Swift
import Combine
import Firebase
import FirebaseAuth

class ProfileViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = true
    @Published var signUpDate: String = ""
    @Published var totalMins: Int = 0
    @Published var name: String = ""

    init() {
        if Auth.auth().currentUser != nil {
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
    }
}
