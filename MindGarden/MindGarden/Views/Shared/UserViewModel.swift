//
//  UserViewModel.swift
//  MindGarden
//
//  Created by Dante Kim on 7/25/21.
//

import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published var coins: Int = 0
    @Published var ownedPlants: [Plant] = [Plant]()
    @Published var selectedPlant: Plant?
    @Published var willBuyPlant: Plant?
    private var validationCancellables: Set<AnyCancellable> = []

    var name: String = ""
    var joinDate: String = ""

    init() {
        
    }
}
