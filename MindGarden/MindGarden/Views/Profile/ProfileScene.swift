//
//  ProfileScene.swift
//  MindGarden
//
//  Created by Dante Kim on 7/6/21.
//

import SwiftUI
import FirebaseAuth


enum settings {
    case settings
    case journey
}


struct ProfileScene: View {
    @EnvironmentObject var userModel: UserViewModel
    @State private var selection: settings = .journey
    @State private var showNotification = false
    @State private var isSignedIn = true
    @State private var tappedSignedIn = false

    var body: some View {
        NavigationView {
            GeometryReader { g in
                let width = g.size.width
                let height = g.size.height
                ZStack {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                    VStack(alignment: .center, spacing: 0) {
                        HStack(alignment: .bottom, spacing: 0) {
                            SelectionButton(selection: $selection, type: .settings)
                                .frame(width: abs(g.size.width/2.5 - 2.5))
                            VStack {
                                Rectangle().fill(Color.gray.opacity(0.3))
                                    .frame(width: 2, height: 35)
                                    .padding(.top, 10)
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 5)
                            }.frame(width: 5)
                            SelectionButton(selection: $selection, type: .journey)
                                .frame(width: abs(g.size.width/2.5 - 2.5))
                        }.background(Clr.darkWhite)
                        .cornerRadius(12)
                        .neoShadow()
                        if showNotification && selection == .settings {
                            Button {
                                showNotification = false
                            } label: {
                                Capsule()
                                    .fill(Clr.darkWhite)
                                    .padding(.horizontal)
                                    .overlay(
                                        Text("Go Back")
                                            .font(Font.mada(.semiBold, size: 20))
                                            .foregroundColor(Clr.darkgreen)
                                    )
                                    .frame(width: width * 0.35, height: 30)
                            }
                            .buttonStyle(NeumorphicPress())
                            .padding(.top)
                        }
                        if selection == .settings {
                            if showNotification {
                                List {
                                    Row(title: "Mindful Reminders", img: Image(systemName: "envelope.fill"), swtch: true,action: {})
                                        .frame(height: 40)
                                    Row(title: "Motivational Quotes", img: Image(systemName: "arrow.triangle.2.circlepath"), swtch: true,action: {})
                                        .frame(height: 40)
                                }.frame(maxHeight: g.size.height * 0.60)
                                .padding()
                                .neoShadow()
                                .transition(.slide)
                                .animation(.default)
                            } else {
                                List {
                                    Row(title: "Notifications", img: Image(systemName: "bell.fill"), action: { showNotification = true })
                                        .frame(height: 40)
                                    Row(title: "Invite Friends", img: Image(systemName: "arrowshape.turn.up.right.fill"), action: {})
                                            .frame(height: 40)
                                    Row(title: "Contact Us", img: Image(systemName: "envelope.fill"), action: { print("360")})
                                        .frame(height: 40)
                                    Row(title: "Restore Purchases", img: Image(systemName: "arrow.triangle.2.circlepath"), action: { print("bing")})
                                        .frame(height: 40)
                                    Row(title: "Join the Community", img: Img.redditIcon, action: {print("romain")})
                                        .frame(height: 40)
                                    Row(title: "Daily Motivation", img: Img.instaIcon, action: {print("shji")})
                                        .frame(height: 40)
                                }.frame(maxHeight: g.size.height * 0.60)
                                .padding()
                                .neoShadow()
                            }
                        } else {
                            // Journey
                            ZStack {
                                Rectangle()
                                    .fill(Clr.darkWhite)
                                    .cornerRadius(12)
                                    .neoShadow()
                                VStack(alignment: .leading) {
                                    HStack(alignment: .center, spacing: 10) {
                                        Image(systemName: "calendar")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                        Text("MindGarden Journey Begins")
                                            .font(Font.mada(.regular, size: 20))
                                            .foregroundColor(Clr.black1)
                                            .padding(.top, 3)
                                    }.frame(width: abs(width - 75), alignment: .leading)
                                    .frame(height: 25)
                                    Text("July 1, 2020")
                                        .font(Font.mada(.bold, size: 34))
                                        .foregroundColor(Clr.darkgreen)
                                }
                            }.frame(width: abs(width - 75), height: height/6)
                            .padding()
                            .padding(.leading)
                            ZStack {
                                Rectangle()
                                    .fill(Clr.darkWhite)
                                    .cornerRadius(12)
                                    .neoShadow()
                                VStack(alignment: .leading) {
                                    HStack(alignment: .center, spacing: 10) {
                                        Image(systemName: "clock")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                        Text("Total Time Meditated")
                                            .font(Font.mada(.regular, size: 20))
                                            .foregroundColor(Clr.black1)
                                            .padding(.top, 3)
                                    }.frame(width: abs(width - 100), alignment: .leading)
                                    .frame(height: 25)
                                    HStack {
                                        Text("90")
                                            .font(Font.mada(.bold, size: 40))
                                            .foregroundColor(Clr.darkgreen)
                                        Text("minutes")
                                            .font(Font.mada(.regular, size: 28))
                                            .foregroundColor(Clr.black1)
                                    }
                                }
                            }.frame(width: abs(width - 75), height: height/6)
                            .padding()
                            .padding(.leading)
                            ZStack {
                                Rectangle()
                                    .fill(Clr.darkWhite)
                                    .cornerRadius(12)
                                    .neoShadow()
                                VStack(alignment: .leading) {
                                    HStack(alignment: .center, spacing: 10) {
                                        Image(systemName: "star.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                        Text("Your Favorite Meditation")
                                            .font(Font.mada(.regular, size: 20))
                                            .foregroundColor(Clr.black1)
                                            .padding(.top, 3)
                                    }.frame(width: abs(width - 100), alignment: .leading)
                                    .frame(height: 25)
                                    HStack {
                                        Text("90")
                                            .font(Font.mada(.bold, size: 40))
                                            .foregroundColor(Clr.darkgreen)
                                        Text("minutes")
                                            .font(Font.mada(.semiBold, size: 28))
                                            .foregroundColor(Clr.black1)
                                    }
                                }
                            }.frame(width: abs(width - 75), height: height/6)
                            .padding()
                            .padding(.leading)
                        }
                        Button {
                            print("signing out")
                            if isSignedIn {
                                do { try Auth.auth().signOut() }
                                catch { print("already logged out") }
                            } else {
                                tappedSignedIn = true
                                //                            NavigationLink("", destination: Authentication(isSignUp: false, viewModel: AuthenticationViewModel(userModel: userModel)), isActive: $tappedSignedIn)
                            }
                            isSignedIn.toggle()
                        } label: {
                            Capsule()
                                .fill(Clr.redGradientBottom)
                                .neoShadow()
                                .overlay(Text("Sign Out").foregroundColor(.white).font(Font.mada(.bold, size: 24)))
                        }
                        .frame(width: abs(width - 100), height: 50, alignment: .center)
                        Spacer()
                    }.navigationBarTitle("Dante", displayMode: .inline)
                    .frame(width: width, height: height)
                    .background(Clr.darkWhite)
                }
            }
        }
        .onAppear {
            // Set the default to clear
            UITableView.appearance().backgroundColor = .clear
            if let _ = Auth.auth().currentUser?.email {
                isSignedIn = true
            } else {
                isSignedIn = false
            }
        }
    }

    struct Row: View {
        var title: String
        var img: Image
        var swtch: Bool = false
        var action: () -> ()

        var body: some View {
            Button {
                action()
            } label: {
                VStack(spacing: 20) {
                    HStack() {
                        img
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25)
                            .offset(x: -10)
                            .foregroundColor(Clr.darkgreen)
                        Text(title)
                            .font(Font.mada(.medium, size: 20))
                            .foregroundColor(Clr.black1)
                        Spacer()
                        if title == "Notifications" {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        } else if swtch {
                            if #available(iOS 14.0, *) {
                                Toggle("", isOn: .constant(true))
                                    .toggleStyle(SwitchToggleStyle(tint: Clr.gardenGreen))
                                    .frame(width: UIScreen.main.bounds.width * 0.1)
                            }
                        }
                    }.padding()
                }
                .listRowBackground(Clr.darkWhite)
            }
        }
    }
}

struct ProfileScene_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScene()
    }
}

struct SelectionButton: View {
    @Binding var selection: settings
    var type: settings

    var body: some View {
        VStack {
            Button {
                selection = type
            } label: {
                HStack {
                    Text(type == .settings ? "Settings" : "Journey")
                        .font(Font.mada(.bold, size: 20))
                        .foregroundColor(selection == type ? Clr.brightGreen : Clr.black1)
                        .padding(.top, 10)
                }
            }.frame(height: 25)
            Rectangle()
                .fill(selection == type ?  Clr.brightGreen : Color.gray.opacity(0.3))
                .frame(height: 5)
        }
    }
}
