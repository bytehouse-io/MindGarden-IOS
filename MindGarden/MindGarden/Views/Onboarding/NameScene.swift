//
//  NameScene.swift
//  MindGarden
//
//  Created by Dante Kim on 9/23/21.
//

import SwiftUI

struct NameScene: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var name: String = ""
    @State var isFirstResponder = true
    var body: some View {
        ZStack {
            NavigationView {
                GeometryReader { g in
                    let width = g.size.width
                    ZStack {
                        Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                        VStack(spacing: -5) {
                            Spacer()
                            Text("What's your name?")
                                .font(Font.mada(.bold, size: 30))
                                .foregroundColor(Clr.darkgreen)
                                .multilineTextAlignment(.center)
                                .padding()
                            LegacyTextField(text: $name, isFirstResponder: $isFirstResponder)
                                .padding()
                                .background(
                                    Rectangle()
                                        .foregroundColor(Clr.darkWhite)
                                        .cornerRadius(14)
                                )
                                .frame(width: width * 0.8, height: 60)
                                .neoShadow()
                                .disableAutocorrection(true)
                            Spacer()
                            Button {
                                Analytics.shared.log(event: .name_tapped_continue)
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                                    if !name.isEmpty {
                                        UserDefaults.standard.set(name, forKey: "name")
                                        fromPage = "onboarding2"
                                        viewRouter.currentPage = .pricing
                                    }
                                }
                            } label: {
                                Capsule()
                                    .fill(Clr.yellow)
                                    .overlay(
                                        Text("Continue")
                                            .foregroundColor(Clr.darkgreen)
                                            .font(Font.mada(.bold, size: 20))
                                    )
                            }.frame(height: 50)
                                .padding()
                                .buttonStyle(NeumorphicPress())
                        }.frame(width: width * 0.9)
                            .padding(.bottom, g.size.height * 0.15)
                    }
                }.navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(
                        leading: Img.topBranch.padding(.leading, -20),
                        trailing: Image(systemName: "arrow.backward")
                            .font(.system(size: 22))
                            .foregroundColor(Clr.darkgreen)
                            .padding()
                            .onTapGesture {
                                viewRouter.currentPage = .notification
                            })
                .onAppearAnalytics(event: .screen_load_name)
            }
        }
    }
}

struct NameScene_Previews: PreviewProvider {
    static var previews: some View {
        NameScene()
    }
}

import UIKit
struct LegacyTextField: UIViewRepresentable {
    @Binding public var isFirstResponder: Bool
    @Binding public var text: String

    public var configuration = { (view: UITextField) in }

    public init(text: Binding<String>, isFirstResponder: Binding<Bool>, configuration: @escaping (UITextField) -> () = { _ in }) {
        self.configuration = configuration
        self._text = text
        self._isFirstResponder = isFirstResponder
    }

    public func makeUIView(context: Context) -> UITextField {
        let view = UITextField()
        view.addTarget(context.coordinator, action: #selector(Coordinator.textViewDidChange), for: .editingChanged)
        view.delegate = context.coordinator
        return view
    }

    public func updateUIView(_ uiView: UITextField, context: Context) {
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
            self.text.wrappedValue = textField.text ?? ""
        }

        public func textFieldDidBeginEditing(_ textField: UITextField) {
            self.isFirstResponder.wrappedValue = true
        }

        public func textFieldDidEndEditing(_ textField: UITextField) {
            self.isFirstResponder.wrappedValue = false
        }
    }
}
