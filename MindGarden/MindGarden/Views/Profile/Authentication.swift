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
    var isSignUp: Bool
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var isShowingDetailView = false
    @State private var alertError = false
    @State private var showForgotAlert = false
    @ObservedObject var viewModel: AuthenticationViewModel
    @State private var isEmailValid = true
    @State private var isPasswordValid = true
    @State private var signUpDisabled = true

    init(isSignUp: Bool, viewModel: AuthenticationViewModel) {
        self.isSignUp = isSignUp
        self.viewModel = viewModel
        viewModel.isSignUp = isSignUp
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
                                    print("tapping")
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
                                            .font(.title)
                                            .foregroundColor(Clr.darkgreen)
                                            .edgesIgnoringSafeArea(.all)
                                            .padding()
                                            .onTapGesture {
                                                withAnimation {
                                                    viewRouter.currentPage = .notification
                                                }
                                            }
                    )
                    .navigationBarBackButtonHidden(true)
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
