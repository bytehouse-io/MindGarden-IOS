//
//  MeditationsViewModel.swift
//  MindGarden
//
//  Created by Dante Kim on 7/15/21.
//

import SwiftUI
import Combine

struct Meditation: Hashable {
    let title: String
    let description: String
    let category: Category
//    let img: Img
}

class MeditationViewModel: ObservableObject {
    @Published var selectedMeditations: [Meditation] = []
    @Published var allMeditations = [Meditation(title: "Open-Ended Meditation", description: "description", category: .unguided), Meditation(title: "Coping with Anxiety", description: "description", category: .anxiety), Meditation(title: "The Art of Focus", description: "description", category: .focus)]
    @Published var selectedCategory: Category? = .focus
    private var validationCancellables: Set<AnyCancellable> = []

    init() {
        $selectedCategory
            .sink { [unowned self] value in
                let filteredMeds = allMeditations.filter { med in
                    med.category == value
                }
                self.selectedMeditations = filteredMeds
            }
            .store(in: &validationCancellables)
    }
}
