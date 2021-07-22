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
    let belongsTo: String
    let category: Category
    let img: Image
    let type: MeditationType
    let id: Int
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: Meditation, rhs: Meditation) -> Bool {
        return lhs.title == rhs.title
    }
}

enum MeditationType {
    case single
    case lesson
    case course
}

class MeditationViewModel: ObservableObject {
    @Published var selectedMeditations: [Meditation] = []
    @Published var selectedMeditation: Meditation? = Meditation(title: "Timed Meditation", description: "Timed unguided (no talking) meditation, with the option to turn on background noises such as rain. A bell will signal the end of your session.", belongsTo: "none", category: .unguided, img: Img.daisy, type: .course, id: 2)
    @Published var courseMeditations: [Meditation] = []
    @Published var allMeditations = [Meditation(title: "Open-Ended Meditation", description: "description", belongsTo: "none", category: .unguided, img: Img.daisy, type: .course, id: 1), Meditation(title: "Timed Meditation", description: "Timed unguided (no talking) meditation, with the option to turn on background noises such as rain. A bell will signal the end of your session.", belongsTo: "none", category: .unguided, img: Img.daisy, type: .course, id: 2),  Meditation(title: "1 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy, type: .lesson, id: 3), Meditation(title: "2 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy, type: .lesson, id: 4), Meditation(title: "5 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.daisy, type: .lesson, id: 5)]
    @Published var selectedCategory: Category? = .focus
    private var validationCancellables: Set<AnyCancellable> = []

    init() {
        $selectedCategory
            .sink { [unowned self] value in
                self.selectedMeditations = allMeditations.filter { med in
                    med.category == value
                }
            }
            .store(in: &validationCancellables)

        $selectedMeditation
            .sink { [unowned self] value in
                if value?.type == .course {
                    selectedMeditations = allMeditations.filter { med in
                        med.belongsTo == value?.title
                    }
                }
            }
            .store(in: &validationCancellables)
    }
}
