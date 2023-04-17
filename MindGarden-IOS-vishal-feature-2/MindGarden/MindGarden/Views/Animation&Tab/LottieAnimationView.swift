//
//  LottieAnimationView.swift
//  MindGarden
//
//  Created by Vishal Davara on 25/02/22.
//

import Lottie
import SwiftUI

struct LottieAnimationView: UIViewRepresentable {
    @State private var isPlayingDefault = true

    let filename: String
    let loopMode: LottieLoopMode
    let isPlaying: Binding<Bool>?
    init(filename: String, loopMode: LottieLoopMode = .loop, isPlaying: Binding<Bool>? = nil) {
        self.filename = filename
        self.loopMode = loopMode
        self.isPlaying = isPlaying
    }

    func makeUIView(context _: Context) -> AnimationViewProxy {
        let playing = isPlaying ?? $isPlayingDefault
        return AnimationViewProxy(
            filename: filename, loopMode: loopMode, isPlaying: playing.wrappedValue
        )
    }

    func updateUIView(_ animationView: AnimationViewProxy, context _: Context) {
        let playing = isPlaying ?? $isPlayingDefault
        if playing.wrappedValue {
            animationView.play()
        } else {
            animationView.stop()
        }
    }

    final class AnimationViewProxy: UIView {
        private let animationView = AnimationView()
        private var isAnimationPlaying: Bool = true

        init(filename: String, loopMode: LottieLoopMode, isPlaying: Bool = true) {
            super.init(frame: .zero)

            animationView.animation = Animation.named(filename)
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = loopMode
            isAnimationPlaying = isPlaying
            if isPlaying {
                play()
            }

            addSubview(animationView)

            animationView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                animationView.widthAnchor.constraint(equalTo: widthAnchor),
                animationView.heightAnchor.constraint(equalTo: heightAnchor),
            ])

            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(applicationWillEnterForeground),
                                                   name: UIApplication.willEnterForegroundNotification,
                                                   object: nil)
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func play() {
            isAnimationPlaying = true
            animationView.play()
        }

        func stop() {
            isAnimationPlaying = false
            animationView.stop()
        }

        @objc private func applicationWillEnterForeground() {
            if isAnimationPlaying {
                animationView.play()
            }
        }

        override func willMove(toWindow newWindow: UIWindow?) {
            guard let _ = newWindow else {
                animationView.stop()
                return
            }

            if isAnimationPlaying {
                animationView.play()
            }
        }
    }
}
