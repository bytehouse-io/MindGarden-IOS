//
//  NameScene.swift
//  MindGarden
//
//  Created by Dante Kim on 9/23/21.
//

import OneSignal
import SwiftUI

struct NameScene: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var userModel: UserViewModel
    @State private var name: String = ""
    @State var isFirstResponder = true
    @State private var showLoading = false
    
    var onReviewCompletion: (() -> Void)? = nil

    init(onReviewCompletion: (() -> Void)?) {
        self.onReviewCompletion = onReviewCompletion
    }
    
    var body: some View {
        ZStack {
            GeometryReader { g in
                let width = g.size.width
                ZStack {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all)
                    VStack(spacing: -5) {
                        HStack {
                            Img.topBranch
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.screenWidth * 0.6)
                                .padding(.leading, -20)
                                .offset(x: -20, y: -10)
                            Spacer()
                            Image(systemName: "arrow.backward")
                                .font(.system(size: 22))
                                .foregroundColor(Clr.darkgreen)
                                .padding()
                                .onTapGesture {
                                    MGAudio.sharedInstance.playBubbleSound()
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    withAnimation {
                                        arr = []
                                        viewRouter.progressValue -= 0.3
                                        viewRouter.currentPage = .reason
                                    }
                                }
                                .offset(x: -20, y: 20)
                        }
                        Spacer()
                        HStack {
                            // FOX IMAGE
                            Img.foxStudy
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 100)
                                .padding(.trailing, 15)
                                .neoShadow()
                            
                            VStack {
                                // TITLE
                                Text("What's your name?")
                                    .font(Font.fredoka(.bold, size: 26))
                                    .foregroundColor(Clr.darkgreen)
                                    .multilineTextAlignment(.center)
                                    .frame(width: width * 0.55, height: 60)
                                    .minimumScaleFactor(0.05)
                                    .lineLimit(1)
                                // NAME FIELD
                                LegacyTextField(text: $name, isFirstResponder: $isFirstResponder)
                                    .padding(15)
                                    .background(
                                        Rectangle()
                                            .foregroundColor(Clr.darkWhite)
                                            .cornerRadius(14)
                                    )
                                    .frame(width: width * 0.55, height: 60)
                                    .oldShadow()
                                    .disableAutocorrection(true)
                            } //: VStack
                        } //: HStack
                        .frame(height: 80)
                        
                        Spacer()
                        
                        // CONTINUE BUTTON
                        Button {
                            MGAudio.sharedInstance.playBubbleSound()
                            // Analytics.shared.log(event: .name_tapped_continue)
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation(.easeOut(duration: 0.3)) {
                                DispatchQueue.main.async {
                                    if !name.isEmpty {
                                        DefaultsManager.standard.set(value: name, forKey: .name)
//                                        viewRouter.progressValue += 0.2
                                        //                                        viewRouter.currentPage = .notification // it is removed due to new oonboarding
                                        
                                        showLoading = true
                                        // Analytics.shared.log(event: .review_tapped_tutorial)
                                        fromOnboarding = true
                                        fromPage = "onboarding2"
                                        DefaultsManager.standard.set(value: DefaultsManager.OnboardingScreens.signedUp.rawValue, forKey: .onboarding)
                                        DefaultsManager.standard.set(value: true, forKey: .onboarded)
                                        DefaultsManager.standard.set(value: true, forKey: .review)
                                        let data: [String: Any] = [
                                            "name": name
                                        ]
                                        MGAnalytics.shared.logActual(event: .onboarding_completed, with: data) // "Triggered when the user has completed the action at a certain step of the onboarding (click ""next"", enter name, enter information, etc).
                                        withAnimation {
                                            viewRouter.progressValue = 1
                                            if onReviewCompletion != nil {
                                                onReviewCompletion?()
                                                MGAnalytics.shared.log(event: .app_entered) // Triggers when the user passes the paywall. Must be sent only once, when user has passed the paywall.
                                            } else {
                                                // goto home screen now
                                                viewRouter.currentPage = .meditate
                                                if fromInfluencer != "" {
                                                    // Analytics.shared.log(event: .user_from_influencer)
                                                    fromPage = "home"
                                                    viewRouter.currentPage = .pricing
                                                } else {
                                                    fromPage = "home"
                                                    viewRouter.currentPage = .pricing
                                                }
                                            }
                                        }
                                        
                                        userModel.name = name
                                    }
                                }
                            }
                        } label: {
                            Rectangle()
                                .fill(!name.isEmpty ? Clr.yellow : Clr.yellow.opacity(0.3))
                                .overlay(
                                    Text("Continue 👉")
                                        .foregroundColor(!name.isEmpty ? Clr.darkgreen : Clr.darkgreen.opacity(0.3))
                                        .font(Font.fredoka(.bold, size: 20))
                                )
                                .addBorder(!name.isEmpty ? .black: .black.opacity(0.3), width: 1.5, cornerRadius: 24)
                        } //: Button
                        .frame(height: 50)
                        .padding()
                        .buttonStyle(NeumorphicPress())
                        .offset(y: 100)
                        .disabled(name.isEmpty)
                    } //: VStack
                    .frame(width: width * 0.9)
                    .padding(.bottom, g.size.height * 0.15)
                } //: ZStack
            } //: GeometryReader
            // .onAppearAnalytics(event: .screen_load_name)
             .onAppearAnalytics(event: .onboarding_completed)
        } //: ZStack
        .transition(.move(edge: .trailing))
        .fullScreenCover(isPresented: $showLoading) {
            LoadingIllusion()
                .frame(height: UIScreen.screenHeight + 50)
        }
    }
}

struct NameScene_Previews: PreviewProvider {
    static var previews: some View {
        NameScene(onReviewCompletion: nil)
    }
}

import UIKit
struct LegacyTextField: UIViewRepresentable {
    @Binding public var isFirstResponder: Bool
    @Binding public var text: String

    public var configuration = { (_: UITextField) in }

    public init(text: Binding<String>, isFirstResponder: Binding<Bool>, configuration: @escaping (UITextField) -> Void = { _ in }) {
        self.configuration = configuration
        _text = text
        _isFirstResponder = isFirstResponder
    }

    public func makeUIView(context: Context) -> UITextField {
        let view = UITextField()
        view.autocorrectionType = .no
        view.addTarget(context.coordinator, action: #selector(Coordinator.textViewDidChange), for: .editingChanged)
        view.delegate = context.coordinator
        return view
    }

    public func updateUIView(_ uiView: UITextField, context _: Context) {
        uiView.text = text
        switch isFirstResponder {
        case true: uiView.becomeFirstResponder()
        case false: uiView.resignFirstResponder()
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator($text, isFirstResponder: $isFirstResponder)
    }

    public class Coordinator: NSObject, UITextFieldDelegate {
        var text: Binding<String>
        var isFirstResponder: Binding<Bool>

        init(_ text: Binding<String>, isFirstResponder: Binding<Bool>) {
            self.text = text
            self.isFirstResponder = isFirstResponder
        }

        @objc public func textViewDidChange(_ textField: UITextField) {
            text.wrappedValue = textField.text ?? ""
        }

        public func textFieldDidBeginEditing(_: UITextField) {
            isFirstResponder.wrappedValue = true
        }

        public func textFieldDidEndEditing(_: UITextField) {
            isFirstResponder.wrappedValue = false
        }
    }
}
