//
//  PlayViewModel.swift
//  MindGarden
//
//  Created by Dante Kim on 7/9/21.
//

import SwiftUI
import Combine

class PlayViewModel: ObservableObject {
    var totalTime: Float = 0
    var isOpenEnded = false
    @Published var secondsRemaining: Float = 150
    @Published var secondsCounted: Float = 0
    var timer: Timer = Timer()

    init() {
        totalTime = secondsRemaining
    }

    func startCountdown() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in self.secondsRemaining -= 1 }
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
