//
//  ContentView.swift
//  MindGarden
//
//  Created by Dante Kim on 5/25/21.
//

import SwiftUI
import Combine


struct ContentView: View {
    @ObservedObject var viewRouter: ViewRouter
    @State var showPopUp = false
    @State var addMood = false
    @State var addGratitude = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    switch viewRouter.currentPage {
                    case .meditate:
                        Home()
                            .frame(height: geometry.size.height - 25)
                            .navigationViewStyle(StackNavigationViewStyle())
                    case .garden:
                        Garden()
                            .frame(height: geometry.size.height - 25)
                            .navigationViewStyle(StackNavigationViewStyle())
                    case .shop:
                        Store()
                            .frame(height: geometry.size.height - 25)
                            .navigationViewStyle(StackNavigationViewStyle())
                    case .profile:
                        Text("profile")
                    }
                }.edgesIgnoringSafeArea(.all)

                if showPopUp {
                    Color.black
                        .opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .frame(height: showPopUp ? geometry.size.height: 0)
                        .offset(y: K.hasNotch ? 40 : 0)
                        .animation(.interpolatingSpring(stiffness: 10, damping: 1))
                }
                    ZStack {
                        PlusMenu(showPopUp: $showPopUp, addMood: $addMood, addGratitude: $addGratitude, width: geometry.size.width)
                            .offset(y: showPopUp ?  geometry.size.height/2 - (K.hasNotch ? 70 : 110) : geometry.size.height/2 + 60)
                            .opacity(showPopUp ? 1 : 0)
                        HStack {
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .garden, width: geometry.size.width/5, height: geometry.size.height/40, tabName: "Garden", img: Img.plantIcon)
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .meditate, width: geometry.size.width/5, height: geometry.size.height/40, tabName: "Meditate", img: Img.meditateIcon)
                            ZStack {
                                Rectangle()
                                    .cornerRadius(21)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: geometry.size.width/7, maxHeight: geometry.size.width/7)
                                    .shadow(color: showPopUp ? .black.opacity(0) : .black.opacity(0.25), radius: 4, x: 4, y: 4)
                                    .zIndex(1)
                                Image(systemName: "plus")
                                    .foregroundColor(Clr.darkgreen)
                                    .font(Font.title.weight(.semibold))
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: geometry.size.width/5.5-6 , maxHeight: geometry.size.width/5.5-6)
                                    .zIndex(2)
                                    .rotationEffect(showPopUp ? .degrees(45) : .degrees(0))
                            }
                            .onTapGesture {
                                withAnimation {
                                    showPopUp.toggle()
                                }
                            }
                            .offset(y: -geometry.size.height/14/2)
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .shop, width: geometry.size.width/5, height: geometry.size.height/40, tabName: "Shop", img: Img.shopIcon)
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .profile, width: geometry.size.width/5, height: geometry.size.height/40, tabName: "Profile", img: Img.profileIcon)
                        }.frame(width: geometry.size.width, height: 80)
                        .background(Clr.darkgreen.shadow(radius: 2))
                        .offset(y: geometry.size.height/2 + (K.hasNotch ? 60 : 10))
                    }
            }.edgesIgnoringSafeArea(.all)
            MoodCheck(shown: $addMood).offset(y: addMood ? 80 : geometry.size.height + 80)
        }.background(Clr.darkWhite)
        .environmentObject(viewRouter)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
                PreviewDisparateDevices {
                    ContentView(viewRouter: ViewRouter())
                }
//        ContentView(viewRouter: ViewRouter())
    }
}
