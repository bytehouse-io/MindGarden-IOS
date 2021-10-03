//
//  Register.swift
//  MindGarden
//
//  Created by Dante Kim on 7/3/21.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn

struct Authentication: View {
    @State var isSignUp: Bool = false
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var medModel: MeditationViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    @State private var alertError = false
    @State private var showForgotAlert = false
    @ObservedObject var viewModel: AuthenticationViewModel
    @State private var isEmailValid = true
    @State private var isPasswordValid = true
    @State private var signUpDisabled = true
    var tappedSignOut: Bool = false

    init(isSignUp: Bool, viewModel: AuthenticationViewModel) {
        self.isSignUp = isSignUp
        self.viewModel = viewModel
        viewModel.isSignUp = isSignUp
        tappedSignOut = UserDefaults.standard.string(forKey: K.defaults.onboarding) == "done"
    }

    var body: some View {
        LoadingView(isShowing: $viewModel.isLoading) {
            NavigationView {
                ZStack {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all)
                    VStack(spacing: 0)  {
                        Text(isSignUp ?  "Sign Up." : "Sign In.")
                            .foregroundColor(Color.black)
                            .font(Font.mada(.bold, size: 32))
                            .padding()
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Clr.darkWhite)
                                .neoShadow()
                                .padding(20)
                            HStack {
                                TextField("Email", text: $viewModel.email)
                                    .foregroundColor(Color.black)
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
                        .frame(height: 100)
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Clr.darkWhite)
                                .neoShadow()
                                .padding(.horizontal, 20)
                            HStack {
                                SecureField("Password (6+ characters)", text: $viewModel.password)
                                    .foregroundColor(Color.black)
                                    .font(Font.mada(.bold, size: 20))
                                    .padding(.leading, 40)
                                    .padding(.trailing, 60)
                                Image(systemName: isPasswordValid ? "xmark" : "checkmark")
                                    .foregroundColor(isPasswordValid ? Color.red : Clr.brightGreen)
                                    .offset(x: -40)
                                    .onReceive(viewModel.validatedPassword) {
                                        self.isPasswordValid = $0 == "invalid"
                                    }
                            }
                        }
                        .frame(height: 60)
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            viewModel.isLoading = true
                            if isSignUp {
                                viewModel.signUp()
                            } else {
                                viewModel.signIn()
                            }
                        } label: {
                            ZStack(alignment: .center) {
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(signUpDisabled ? Color.gray.opacity(0.5) : Clr.brightGreen)
                                    .neoShadow()
                                Text(isSignUp ? "Register" : "Login")
                                    .foregroundColor(Color.white)
                                    .font(Font.mada(.bold, size: 20))
                                    .padding()
                            }
                            .padding(20)
                            .frame(maxHeight: 100)
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
                        if !isSignUp {
                            Text("Forgot Password?")
                                .font(Font.mada(.medium, size: 18))
                                .foregroundColor(.blue)
                                .underline()
                                .padding(5)
                                .onTapGesture {
                                    showForgotAlert = true
                                }
                        }
                        Divider().padding(20)
                        viewModel
                            .siwa
                            .padding(20)
                            .padding(.horizontal, 20)
                            .frame(height: 100)
                            .neoShadow()
                        Img.siwg
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .padding(40)
                            .frame(height: 70)
                            .neoShadow()
                            .onTapGesture {
                                viewModel.signInWithGoogle()
                            }
                        if tappedSignOut {
                            Button {
                                self.isSignUp.toggle()
                                viewModel.isSignUp = self.isSignUp
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            } label: {
                                Capsule()
                                    .fill(Clr.darkWhite)
                                    .overlay(
                                        Text(isSignUp ? "Already have an account" : "Sign up for an account")
                                            .foregroundColor(Clr.darkgreen)
                                            .font(Font.mada(.bold, size: 18))
                                    )
                            }.frame(height: 50)
                                .padding(.horizontal, 40)
                                .padding(.top, 20)
                                .buttonStyle(NeumorphicPress())
                        }
                        Spacer()
                    }
                    .background(Clr.darkWhite)
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
                    .edgesIgnoringSafeArea(.bottom)
                    .navigationBarTitle("", displayMode: .inline)
                    .navigationBarItems(leading: Img.topBranch.padding(.leading, -20),
                                        trailing: Image(systemName: "arrow.backward")
                                            .font(.system(size: 22))
                                            .foregroundColor(Clr.darkgreen)
                                            .edgesIgnoringSafeArea(.all)
                                            .padding()
                                            .onTapGesture {
                        withAnimation {
                            if tappedSignIn {
                                tappedSignIn = false
                                viewRouter.currentPage = .onboarding
                            } else {
                                viewRouter.currentPage = .notification
                            }
                        }
                    }
                                            .opacity(tappedSignOut ? 0 : 1)
                                            .disabled(tappedSignOut)
                    )
                    .navigationBarBackButtonHidden(true)
                }
            }.onDisappear {
                if tappedSignIn || tappedSignOut {
                    userModel.updateSelf()
                    gardenModel.updateSelf()
                    medModel.updateSelf()
                }
            }
        }
    }
}


//MARK: - preview
struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Authentication(isSignUp: false, viewModel: AuthenticationViewModel(userModel: UserViewModel(), viewRouter: ViewRouter()))
    }
}
