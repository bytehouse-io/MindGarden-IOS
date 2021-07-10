//
//  ProfileScene.swift
//  MindGarden
//
//  Created by Dante Kim on 7/6/21.
//

import SwiftUI

enum settings {
    case setttings
    case journey
}


struct ProfileScene: View {
    @State private var selection: settings = .journey

    var body: some View {
        NavigationView {
            GeometryReader { g in
                let width = g.size.width
                let height = g.size.height
                VStack(alignment: .center, spacing: 0) {
                    HStack(alignment: .bottom, spacing: 0) {
                        SelectionButton(selection: $selection, type: .setttings)
                            .frame(width: g.size.width/2.5 - 2.5)
                        VStack {
                            Rectangle().fill(Color.gray.opacity(0.3))
                                .frame(width: 2, height: 35)
                                .padding(.top, 10)
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 5)
                        }.frame(width: 5)
                        SelectionButton(selection: $selection, type: .journey)
                            .frame(width: g.size.width/2.5 - 2.5)
                    }.background(Clr.darkWhite)
                    .cornerRadius(12)
                    .padding(.top)
                    .neoShadow()
                    if selection == .setttings {
                        List {
                            Row(title: "Notifications", img: Image(systemName: "bell.fill"))
                                .frame(height: 40)
                            Row(title: "Notifications", img: Image(systemName: "bell.fill"))
                                .frame(height: 40)
                            Row(title: "Invite Friends", img: Image(systemName: "arrowshape.turn.up.right.fill"))
                                .frame(height: 40)
                            Row(title: "Contact Us", img: Image(systemName: "envelope.fill"))
                                .frame(height: 40)
                            Row(title: "Restore Purchases", img: Image(systemName: "arrow.triangle.2.circlepath"))
                                .frame(height: 40)
                            Row(title: "Join the Community", img: Img.redditIcon)
                                .frame(height: 40)
                            Row(title: "Daily Motivation", img: Img.instaIcon)
                                .frame(height: 40)
                        }
                        .neoShadow()
                    } else {
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
                                }.frame(width: width - 75, alignment: .leading)
                                .frame(height: 25)
                                Text("July 1, 2020")
                                    .font(Font.mada(.bold, size: 34))
                                    .foregroundColor(Clr.darkgreen)
                            }
                        }.frame(width: width - 75, height: height/6)
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
                                }.frame(width: width - 100, alignment: .leading)
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
                        }.frame(width: width - 75, height: height/6)
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
                                }.frame(width: width - 100, alignment: .leading)
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
                        }.frame(width: width - 75, height: height/6)
                        .padding()
                        .padding(.leading)
                    }
                    Button {
                        print("sign out")
                    } label: {
                        Capsule()
                            .fill(Clr.redGradientBottom)
                            .neoShadow()
                            .overlay(Text("Sign Out").foregroundColor(.white).font(Font.mada(.bold, size: 24)))
                    }
                    .frame(width: width - 100, height: 50, alignment: .center)

                }.navigationBarTitle("Dante", displayMode: .inline)
                .frame(width: width)
                .background(Clr.darkWhite)
            }
        }
        .onAppear {
            // Set the default to clear
            UITableView.appearance().backgroundColor = .clear
        }
    }

    struct Row: View {
        var title: String
        var img: Image

        var body: some View {
            Button {

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
                    }.padding([.top, .leading,.trailing])
                    Divider()
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
                    Text(type == .setttings ? "Settings" : "Journey")
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
