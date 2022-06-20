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
    @State private var showEmailForms = false
    @State private var showProfile = false
    @State private var isEmailValid = true
    @State private var showFields = false
    @State private var isPasswordValid = true
    @State private var signUpDisabled = true
    @State private var focusedText = false
    @State private var showForgotAlert = false

    init(viewModel: AuthenticationViewModel) {
        self.viewModel = viewModel
        self.viewModel.isSignUp = true
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
                                        viewRouter.currentPage = .meditate
                                    } else {
                                        if fromPage == "profile" {
                                            viewRouter.currentPage = .meditate
                                        } else if fromPage == "singleIntro" {
                                            medModel.selectedMeditation = Meditation.allMeditations.first(where: { $0.id == 6 })
                                            viewRouter.currentPage = .middle
                                        } else if fromPage == "onboarding" {
                                            viewRouter.currentPage = .onboarding
                                        } else {
                                            withAnimation {
                                                viewRouter.currentPage = .garden
                                            }
                                        }
                                    }
                                }
                            }
                    }
                }.frame(width: UIScreen.screenWidth)

                Text(tappedRefer ? "Sign Up to Refer" : showFields ? viewModel.isSignUp ? "Sign Up with Email" : "Sign in" : "Create a profile to save your progress")
                    .foregroundColor(Clr.black2)
                    .font(Font.mada(.semiBold, size: 28))
                    .multilineTextAlignment(.center)
                    .frame(width: UIScreen.screenWidth * 0.8)
                Spacer()
                if !showFields {
                    Img.signUpImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.screenWidth * 0.65)
                        .padding()
                } else {
                    if showFields && !tappedSignOut {
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation {
                                showFields = false
                            }
                        } label: {
                            Capsule()
                                .fill(Clr.darkWhite)
                                .padding(.horizontal)
                                .overlay(
                                    Text("Go Back")
                                        .font(Font.mada(.semiBold, size: 20))
                                        .foregroundColor(Clr.darkgreen)
                                )
                                .frame(width: UIScreen.screenWidth * 0.35, height: 30)
                        }
                        .buttonStyle(NeumorphicPress())
                    }
                    VStack(spacing: 0) {
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Clr.darkWhite)
                                .neoShadow()
                                .padding(20)
                            HStack {
                                TextField("Email", text: $viewModel.email, onEditingChanged: { focused in
                                    withAnimation {
        //                                focusedText = focused
                                    }
                                })
                                    .foregroundColor(Clr.black2)
                                    .font(Font.mada(.bold, size: 20))
                                    .padding(.leading, 40)
                                    .padding(.trailing, 60)
                                Image(systemName: isEmailValid ? "xmark" : "checkmark")
                                    .foregroundColor(isEmailValid ? Color.red : Clr.brightGreen)
                                    .offset(x: -40)
                                    .onReceive(viewModel.validatedEmail) {
                                        self.isEmailValid = $0 == "invalid"
                                    }
                            }
                        }
                        .frame(width: UIScreen.screenWidth * 0.9, height: 100)
                        .frame(height: 100)
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Clr.darkWhite)
                                .neoShadow()
                                .padding(.horizontal, 20)
                            HStack {
                                SecureField("Password (6+ characters)", text: $viewModel.password)
                                    .foregroundColor(Clr.black2)
                                    .font(Font.mada(.bold, size: 20))
                                    .padding(.leading, 40)
                                    .padding(.trailing, 60)
                                    .disableAutocorrection(true)
                                Image(systemName: isPasswordValid ? "xmark" : "checkmark")
                                    .foregroundColor(isPasswordValid ? Color.red : Clr.brightGreen)
                                    .offset(x: -40)
                                    .onReceive(viewModel.validatedPassword) {
                                        self.isPasswordValid = $0 == "invalid"
                                    }
                            }
                        }
                        .frame(width: UIScreen.screenWidth * 0.9, height: 60)
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
    //                            viewModel.isLoading = true
                            if viewModel.isSignUp {
                                viewModel.signUp()
                            } else {
                                viewModel.signIn()
                            }
                        } label: {
                            ZStack(alignment: .center) {
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(signUpDisabled ? Color.gray.opacity(0.5) : Clr.brightGreen)
                                    .neoShadow()
                                Text(viewModel.isSignUp ? "Register" : "Login")
                                    .foregroundColor(Color.white)
                                    .font(Font.mada(.bold, size: 20))
                                    .padding()
                            }
                            .padding(20)
                            .frame(width: UIScreen.screenWidth * 0.9, height: 100)
                            .disabled(true)
                        }.disabled(signUpDisabled)
                        .onReceive(viewModel.validatedCredentials) {
                                guard let credentials = $0 else {
                                    self.signUpDisabled = true
                                    return
                                }
                                let (_, validPassword) = credentials
                                guard validPassword != "invalid"  else {
                                    self.signUpDisabled = true
                                    return
                                }
                                self.signUpDisabled = false
                            }
                    }.padding(.bottom, -30)
                    if viewModel.isSignUp {
                        HStack {
                            CheckBoxView(checked: $viewModel.checked)
                                .frame(height: 45)
                            Text("Sign me up for the MindGarden Newsletter 🗞")
                                .font(Font.mada(.medium, size: 18))
                                .foregroundColor(Clr.black2)
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                        }.frame(height: 60)
                            .padding(.horizontal, 20)
                    }
                    if !viewModel.isSignUp {
                        Text("Forgot Password?")
                            .font(Font.mada(.medium, size: 18))
                            .foregroundColor(.blue)
                            .underline()
                            .padding(5)
                            .onTapGesture {
                                Analytics.shared.log(event: .authentication_tapped_forgot_password)
                                showForgotAlert = true
                            }
                    }
                    Divider().padding(.bottom, 15)
                }
      
                Spacer()
                Spacer()
                if !showFields  {
                    Button {
                        withAnimation {
                            Analytics.shared.log(event: .authentication_tapped_signup_email)
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            viewModel.isSignUp = true
                            showFields = true
                        }
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
                }
                
                viewModel
                    .siwa
                    .padding(20)
                    .frame(height: 100)
                    .oldShadow()
                    .disabled(viewModel.falseAppleId)
                    .frame(width: UIScreen.screenWidth * 0.9, height: K.isPad() ? 250 : 70)
                VStack {
                    if showFields && viewModel.isSignUp == false {
                        Img.siwg
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    } else {
                        Img.suwg
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                }.padding(20)
                    .frame(width: UIScreen.screenWidth * 0.9, height: K.isPad() ? 250 : 70)
                    .neoShadow()
                    .onTapGesture {
                        Analytics.shared.log(event: .authentication_tapped_google)
                        viewModel.signInWithGoogle()
                    }
                if !tappedSignOut {
                    Button {
                        Analytics.shared.log(event: .tapped_already_have_account)
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        withAnimation {
                            if !viewModel.isSignUp && showFields {
                                showFields = false
                                viewModel.isSignUp = true
                            } else {
                                tappedSignIn = true
                                viewModel.isSignUp = false
                                showFields = true
                            }
                        }
                    } label: {
                        Text(!viewModel.isSignUp && showFields ? "Create an account" : "Already have an account")
                            .underline()
                            .font(Font.mada(.semiBold, size: 18))
                            .foregroundColor(.gray)
                    }.frame(height: 30)
                    .padding()
                    .buttonStyle(BonusPress())
                }
            }
        }
        .alert(isPresented: $viewModel.alertError) {
            Alert(title: Text("Something went wrong"), message:
                    Text(viewModel.alertMessage)
                  , dismissButton: .default(Text("Got it!")))
        }
        .alert(isPresented: $showForgotAlert, TextAlert(title: "Reset Password", action: {
            if $0 != nil {
                viewModel.forgotEmail = $0 ?? ""
                viewModel.isLoading = true
                viewModel.forgotPassword()
            }
        }))
        .sheet(isPresented: $showEmailForms) {
            Authentication(viewModel: viewModel)
                .environmentObject(medModel)
                .environmentObject(userModel)
                .environmentObject(gardenModel)
        }
        .onAppearAnalytics(event: .screen_load_newAuthenticaion)
        .onAppear {
            if tappedSignOut {
                viewModel.isSignUp = false
                showFields = true
            }
        }
        .transition(.opacity)

    }
}

struct NewAuthentication_Previews: PreviewProvider {
    static var previews: some View {
        NewAuthentication(viewModel: AuthenticationViewModel(userModel: UserViewModel(), viewRouter: ViewRouter()))
    }
}
