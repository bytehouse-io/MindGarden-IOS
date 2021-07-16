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
    private let playViewModel = PlayViewModel()
    private let meditationModel = MeditationViewModel()
    @State var showPopUp = false
    @State var addMood = false
    @State var openPrompts = false
    @State var addGratitude = false

    init(viewRouter: ViewRouter) {
        self.viewRouter = viewRouter
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        playViewModel.isOpenEnded = true
        playViewModel.secondsRemaining = 150
    }

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all)
                    VStack {
                        if #available(iOS 14.0, *) {
                            switch viewRouter.currentPage {
                            case .meditate:
                                Home(viewRouter: viewRouter, model: meditationModel)
                                    .frame(height: geometry.size.height)
                                    .navigationViewStyle(StackNavigationViewStyle())
                            case .garden:
                                Garden()
                                    .frame(height: geometry.size.height)
                                    .navigationViewStyle(StackNavigationViewStyle())
                            case .shop:
                                Store()
                                    .frame(height: geometry.size.height + 20)
                                    .navigationViewStyle(StackNavigationViewStyle())
                            case .profile:
                                ProfileScene()
                                    .frame(height: geometry.size.height)
                                    .navigationViewStyle(StackNavigationViewStyle())
                            case .play:
                                Play(model: playViewModel, viewRouter: viewRouter)
                                    .frame(height: geometry.size.height)
                                    .navigationViewStyle(StackNavigationViewStyle())
                            case .categories:
                                CategoriesScene(viewRouter: viewRouter, model: meditationModel)
                                    .frame(height: geometry.size.height)
                                    .navigationViewStyle(StackNavigationViewStyle())
                            }
                        } else {
                            // Fallback on earlier versions
                        }
                    }.edgesIgnoringSafeArea(.all)
                    if viewRouter.currentPage != .play {
                        if showPopUp || addMood || addGratitude {
                            Button {
                                withAnimation {
                                    showPopUp = false
                                    addMood = false
                                    addGratitude = false
                                }
                            } label: {
                                Color.black
                                    .opacity(0.3)
                                    .edgesIgnoringSafeArea(.all)
                                    .frame(height: showPopUp || addMood || addGratitude ? geometry.size.height: 0)
                            }.animation(.easeInOut(duration: 0.1))
                        }
                        ZStack {
                            PlusMenu(showPopUp: $showPopUp, addMood: $addMood, addGratitude: $addGratitude, width: geometry.size.width)
                                .offset(y: showPopUp ?  geometry.size.height/2 - (K.hasNotch() ? 125 : K.isPad() ? 235 : 130) : geometry.size.height/2 + 60)
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
                            .offset(y: geometry.size.height/2 - (K.hasNotch() ? 0 : 15))
                        }
                        MoodCheck(shown: $addMood)
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.35)
                            .background(Clr.darkWhite)
                            .cornerRadius(12)
                            .offset(y: addMood ? geometry.size.height/(K.hasNotch() ? 2.5 : 2.75) : geometry.size.height)
                        Gratitude(shown: $addGratitude, openPrompts: $openPrompts)
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.45 * (openPrompts ? 2.25 : 1))
                            .background(Clr.darkWhite)
                            .cornerRadius(12)
                            .offset(y: addGratitude ? geometry.size.height/(K.hasNotch() ? 3.5 * (openPrompts ? 2 : 1)  : K.isPad()  ?  2.5 * (openPrompts ? 2 : 1) : 4.5 * (openPrompts ? 4.5 : 1) )  : geometry.size.height)
                    }
                }
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)
            }
            .environmentObject(viewRouter)
        }.navigationViewStyle(StackNavigationViewStyle())
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
