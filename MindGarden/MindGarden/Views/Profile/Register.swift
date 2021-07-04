//
//  Register.swift
//  MindGarden
//
//  Created by Dante Kim on 7/3/21.
//

import SwiftUI
import AuthenticationServices

struct Register: View {
    @State var email = "Email"
    @State var password = "Password"
    var body: some View {
        VStack(spacing: 0) {
            Text("Sign Up.")
                .foregroundColor(Color.black)
                .font(Font.mada(.bold, size: 34))
                .padding()
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Clr.darkWhite)
                    .neoShadow()
                TextField("", text: $email)
                    .foregroundColor(Color.black)
                    .font(Font.mada(.bold, size: 20))
                    .padding()
            }
            .padding(20)
            .frame(maxHeight: 100)
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Clr.darkWhite)
                    .neoShadow()
                TextField("", text: $password)
                    .foregroundColor(Color.black)
                    .font(Font.mada(.bold, size: 20))
                    .padding()
            }
            .padding(20)
            .frame(maxHeight: 100)
            Button {
                print("register")
            } label: {
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Clr.brightGreen)
                        .neoShadow()
                    Text("Register")
                        .foregroundColor(Color.white)
                        .font(Font.mada(.bold, size: 20))
                        .padding()
                }
            }.padding(20)
            .frame(maxHeight: 100)
            Divider().padding(20)
            QuickSignInWithApple()
                .padding(20)
                .frame(maxHeight: 100)
                .neoShadow()
        }
    }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register()
    }
}

struct QuickSignInWithApple: UIViewRepresentable {
  typealias UIViewType = ASAuthorizationAppleIDButton

  func makeUIView(context: Context) -> UIViewType {
    return ASAuthorizationAppleIDButton()
    // or just use UIViewType() 😊 Not recommanded though.
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {
  }
}

