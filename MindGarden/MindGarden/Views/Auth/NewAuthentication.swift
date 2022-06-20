//
//  NewAuthentication.swift
//  MindGarden
//
//  Created by Dante Kim on 6/19/22.
//

import SwiftUI

struct NewAuthentication: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var medModel: MeditationViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    @EnvironmentObject var bonusModel: BonusViewModel
    @EnvironmentObject var profileModel: ProfileViewModel
    @ObservedObject var viewModel: AuthenticationViewModel
    var tappedSignOut: Bool = false
    @State private var showEmailForms = false
    @State private var showProfile = false

    init(viewModel: AuthenticationViewModel) {
        self.viewModel = viewModel
        self.viewModel.isSignUp = true
        tappedSignOut = UserDefaults.standard.string(forKey: K.defaults.onboarding) == "done"
    }
    var body: some View {
        ZStack {
            Clr.darkWhite.edgesIgnoringSafeArea(.all)
            VStack(spacing: 15) {
                HStack {
                    Img.topBranch
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.screenWidth * 0.6)
                        .padding(.leading, -20)
                    Spacer()
                    ZStack {
                        Image(systemName: "xmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                            .foregroundColor(.gray)
                            .padding(.bottom, 50)
                            .opacity(0.5)
                            .offset(x: -40, y: 40)
                            .onTapGesture {
                                withAnimation {
                                    if tappedRefer {
                                        showProfile = true
                                    } else {
                                        if fromPage == "profile" {
                                            showProfile = true
                                        } else if fromPage == "singleIntro" {
                                            medModel.selectedMeditation = Meditation.allMeditations.first(where: { $0.id == 6 })
                                            viewRouter.currentPage = .middle
                                        } else {
                                            viewRouter.currentPage = .garden
                                        }
                                    }
                                }
                            }
                    }
                }.frame(width: UIScreen.screenWidth)
          
                Text(tappedRefer ? "Sign Up to Refer" : "Create a profile to save your progress")
                    .foregroundColor(Clr.black2)
                    .font(Font.mada(.semiBold, size: 28))
                    .multilineTextAlignment(.center)
                    .frame(width: UIScreen.screenWidth * 0.8)
                Spacer()
                Img.signUpImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.screenWidth * 0.65)
                    .padding()
                Spacer()
                Button {
                    Analytics.shared.log(event: .authentication_tapped_signup_email)
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    viewModel.isSignUp = true
                    showEmailForms = true
                } label: {
                    Capsule()
                        .fill(Clr.darkWhite)
                        .overlay(
                            HStack(spacing: 15) {
                                Image(systemName: "envelope.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20)
                                    .foregroundColor(Clr.darkgreen)
                                Text("Sign up with Email")
                                    .foregroundColor(Clr.darkgreen)
                                    .font(Font.mada(.bold, size: 18))
                            }.offset(x: -20)
                           
                        )
                }.frame(height: 60)
                    .padding(.top, 20)
                    .buttonStyle(NeumorphicPress())
                    .frame(width: UIScreen.screenWidth * 0.8, height: K.isPad() ? 250 : 70, alignment: .center)
                viewModel
                    .siwa
                    .padding(20)
                    .frame(height: 100)
                    .oldShadow()
                    .disabled(viewModel.falseAppleId)
                    .frame(width: UIScreen.screenWidth * 0.9, height: K.isPad() ? 250 : 70)
                Img.suwg
                    .resizable()
                    .aspectRatio(contentMode: K.isPad() ? .fit : .fill)
                    .padding(20)
                    .frame(width: UIScreen.screenWidth * 0.9, height: K.isPad() ? 250 : 70)
                    .neoShadow()
                    .onTapGesture {
                        Analytics.shared.log(event: .authentication_tapped_google)
                        viewModel.signInWithGoogle()
                    }
                Button {
                    Analytics.shared.log(event: .tapped_already_have_account)
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    withAnimation {
                        tappedSignIn = true
                        viewModel.isSignUp = false
                        showEmailForms = true
                    }
                } label: {
                    Text("Already have an account")
                        .underline()
                        .font(Font.mada(.semiBold, size: 18))
                        .foregroundColor(.gray)
                }.frame(height: 30)
                .padding()
                .buttonStyle(BonusPress())
                .padding(.top,20)
            }
        }.sheet(isPresented: $showEmailForms) {
            Authentication()
                .environmentObject(viewModel)
                .environmentObject(medModel)
                .environmentObject(userModel)
                .environmentObject(gardenModel)
        }.sheet(isPresented: $showProfile) {
            ProfileScene(profileModel: profileModel)
                .environmentObject(userModel)
                .environmentObject(gardenModel)
                .environmentObject(viewRouter)
        }
        .onAppearAnalytics(event: .screen_load_newAuthenticaion)
    }
}

struct NewAuthentication_Previews: PreviewProvider {
    static var previews: some View {
        NewAuthentication(viewModel: AuthenticationViewModel(userModel: UserViewModel(), viewRouter: ViewRouter()))
    }
}
