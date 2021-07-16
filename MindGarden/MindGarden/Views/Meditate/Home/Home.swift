//
//  Home.swift
//  MindGarden
//
//  Created by Dante Kim on 6/11/21.
//

import SwiftUI

struct Home: View {
    @ObservedObject var viewRouter: ViewRouter
    @ObservedObject var model: MeditationViewModel
    @State private var isRecent = false
    @State private var showModal = false

    init(viewRouter: ViewRouter, model: MeditationViewModel) {
        self.viewRouter = viewRouter
        self.model = model
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { g in
                ZStack {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                    VStack {
                        HStack {
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("Good Morning, User")
                                    .font(Font.mada(.bold, size: 25))
                                    .foregroundColor(Clr.black1)
                                    .fontWeight(.bold)
                                    .padding(.trailing, 20)
                                HStack {
                                    Text("Streak")
                                        .font(Font.mada(.semiBold, size: 20))
                                    Text("300")
                                        .font(Font.mada(.semiBold, size: 20))
                                }.padding(.trailing, 20)
                            }
                        }
                        .padding(.top, -30)
                        HStack {
                            Button {
                                withAnimation {
                                    showModal = true
                                }
                            } label: {
                                HStack {
                                    Text("Daily Bonus")
                                        .font(Font.mada(.regular, size: 14))
                                        .foregroundColor(.black)
                                        .font(.footnote)
                                }
                                .padding(8)
                                .background(Clr.yellow)
                                .cornerRadius(25)
                            }
                            .buttonStyle(NeumorphicPress())
                            Button {

                            } label: {
                                HStack {
                                    Text("Select Plant")
                                        .font(Font.mada(.regular, size: 14))
                                        .foregroundColor(.black)
                                        .font(.footnote)
                                }
                                .padding(8)
                                .background(Clr.yellow)
                                .cornerRadius(25)
                            }
                            .buttonStyle(NeumorphicPress())
                        }
                        Button {
                            withAnimation {
                                viewRouter.currentPage = .play
                            }
                        } label: {
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .border(Clr.darkWhite)
                                .cornerRadius(25)
                                .frame(width: g.size.width * 0.85, height: g.size.height * 0.3, alignment: .center)
                                .neoShadow()
                                .overlay(HStack(alignment: .top) {
                                    VStack(alignment: .leading) {
                                        Text("Featured")
                                            .font(Font.mada(.regular, size: 16))
                                            .foregroundColor(Clr.black1)
                                        Text("Anxiety and\nStress")
                                            .font(Font.mada(.bold, size: 28))
                                            .foregroundColor(Clr.black1)
                                        Spacer()
                                    }.padding(25)
                                    Spacer()
                                    ZStack {
                                        Circle().frame(width: g.size.width * 0.15, height:  g.size.width * 0.15)
                                            .foregroundColor(Clr.brightGreen)
                                        Image(systemName: "play.fill")
                                            .foregroundColor(.white)
                                            .font(.title)
                                    }
                                    .padding(25)
                                }).padding(.top, 20)
                        }.buttonStyle(NeumorphicPress())
                        VStack(spacing: 1) {
                            HStack {
                                Button {
                                    withAnimation {
                                        isRecent = true
                                    }
                                } label: {
                                    Text("Recent")
                                        .foregroundColor(.black)
                                        .font(Font.mada(.regular, size: 20))
                                }
                                Button {
                                    withAnimation {
                                        isRecent = false
                                    }
                                } label: {
                                    Text("Favorites")
                                        .foregroundColor(.black)
                                        .font(Font.mada(.regular, size: 20))
                                }
                            }
                            Rectangle().frame(width: isRecent ? CGFloat(45) : 65.0, height: 1.5)
                                .offset(x: isRecent ? -42.0 : 33.0)
                                .animation(.default, value: isRecent)
                        }.frame(width: abs(g.size.width - 75), alignment: .leading)
                        .padding(.top, 20)
                        HStack(spacing: 15) {
                            Button {

                            } label: {
                                HomeSquare(width: g.size.width, height: g.size.height, img: Img.chatBubble, title: "Open Ended Meditation")
                            }.buttonStyle(NeumorphicPress())
                            Button {
                                
                            } label: {
                                HomeSquare(width: g.size.width, height: g.size.height, img: Img.daisy, title: "Timed Meditation")
                            }.buttonStyle(NeumorphicPress())
                        }.padding(.top, 10)
                        if #available(iOS 14.0, *) {
                            Button {
                                withAnimation {
                                    viewRouter.currentPage = .categories
                                }
                            } label: { RoundedRectangle(cornerRadius: 25)
                                    .frame(width: g.size.width * 0.85, height: g.size.height/14)
                                    .foregroundColor(Clr.yellow)
                                    .overlay(Text("See All Categories")
                                                .foregroundColor(Clr.black2)
                                                .font(Font.mada(.semiBold, size: 20))
                                    )
                            }.padding(.top, 20)
                            .buttonStyle(NeumorphicPress())
                        } else {
                            // Fallback on earlier versions
                        }
                        Spacer()
                    }
                }
                if showModal {
                    Color.black
                        .opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                    Spacer()
                }
                BonusModal(shown: $showModal)
                    .offset(y: showModal ? 0 : g.size.height)
                    .edgesIgnoringSafeArea(.top)
                    .animation(.default, value: showModal)
            }.animation(nil)
            .transition(.move(edge: .leading))
            .animation(.default)
            .navigationBarItems(leading: Img.topBranch.padding(.leading, -20),
                                trailing: Image(systemName: "magnifyingglass")
                                    .font(.title)
                                    .foregroundColor(Clr.darkgreen)
                                    .padding()
            )
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(viewRouter: ViewRouter(),
             model: MeditationViewModel()).navigationViewStyle(StackNavigationViewStyle())
    }
}

