//
//  Register.swift
//  MindGarden
//
//  Created by Dante Kim on 7/3/21.
//

import SwiftUI
import FirebaseUI
import FirebaseAuth
import GoogleSignIn

struct Register: View {
    @State var email = "Email"
    @State var password = "Password"
    @State private var isShowingDetailView = false
    @State private var alertError = false

    @StateObject var viewModel = AuthenticationViewModel()
    @State private var isEmailValid = true
    @State private var isPasswordValid = true
    @State private var signUpDisabled = true
    @State private var goToHome = false

    init() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.shadowImage = UIImage()
        navBarAppearance.shadowColor = .clear
        if #available(iOS 14.0, *) {
            navBarAppearance.backgroundColor = UIColor(Clr.darkWhite)
        } else {
            // Fallback on earlier versions
        }
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0)  {
                Text("Sign Up.")
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
                .frame(maxHeight: 100)
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
                .frame(maxHeight: 60)
                NavigationLink(destination: ContentView(viewRouter: ViewRouter())
                                .navigationBarTitle("")
                                .navigationBarHidden(true)) {
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(signUpDisabled ? Color.gray.opacity(0.5) : Clr.brightGreen)
                            .neoShadow()
                        Text("Register")
                            .foregroundColor(Color.white)
                            .font(Font.mada(.bold, size: 20))
                            .padding()
                    }
                }.padding(20)
                .frame(maxHeight: 100)
                .disabled(signUpDisabled)
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

                Divider().padding(20)
                viewModel
                    .siwa
                    .padding(20)
                    .padding(.horizontal, 20)
                    .frame(maxHeight: 100)
                    .neoShadow()

                Img.siwg
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .padding(40)
                    .frame(maxHeight: 70)
                    .neoShadow()
                    .onTapGesture {
                        viewModel.signIn()
                    }
                Spacer()
            }
            .alert(isPresented: $viewModel.alertError) {
                Alert(title: Text("Something went wrong"), message: Text("Please try again using a different email or method"), dismissButton: .default(Text("Got it!")))
            }
            .background(Clr.darkWhite)
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading: Img.topBranch.padding(.leading, -20),
                                trailing: Image(systemName: "arrow.backward")
                                    .font(.title)
                                    .foregroundColor(Clr.darkgreen)
                                    .edgesIgnoringSafeArea(.all)
                                    .padding()
            )
        }
    }
}


extension Register {


}
