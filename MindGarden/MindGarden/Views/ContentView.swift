//
//  ContentView.swift
//  MindGarden
//
//  Created by Dante Kim on 5/25/21.
//

import SwiftUI
import Combine

struct PlusMenu: View {
    let width: CGFloat
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    Text("bingo").font(.title)
                }
            }
        }
        .frame(width: width/2.5, height: width/2.5)
        .transition(.scale)
        .zIndex(-10)
        .background(Color.black)
    }
}


struct ContentView: View {
    @ObservedObject var viewRouter: ViewRouter
    @State var showPopUp = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                switch viewRouter.currentPage {
                case .meditate:
                    Text("med")
                case .garden:
                    Text("garden")
                case .shop:
                    Text("shop")
                case .profile:
                    Home().frame(height: geometry.size.height -  geometry.size.height/18)
                }

                ZStack {
//                    PlusMenu(width: geometry.size.width)
//                        .offset(y: showPopUp ?  -geometry.size.height/6 : 0)
//                        .opacity(showPopUp ? 1 : 0)
                    HStack {
                        TabBarIcon(viewRouter: viewRouter, assignedPage: .garden, width: geometry.size.width/5, height: geometry.size.height/40, tabName: "Garden", img: Img.plantIcon)
                        TabBarIcon(viewRouter: viewRouter, assignedPage: .meditate, width: geometry.size.width/5, height: geometry.size.height/40, tabName: "Meditate", img: Img.meditateIcon)
                        ZStack {
                            Rectangle()
                                .cornerRadius(21)
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width/7, height: geometry.size.width/7)
                                .shadow(color: showPopUp ? .black.opacity(0) : .black.opacity(0.25), radius: 4, x: 4, y: 4)
                                .zIndex(1)
                            Image(systemName: "plus")
                                .foregroundColor(Clr.darkgreen)
                                .font(Font.title.weight(.semibold))
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width/5.5-6 , height: geometry.size.width/5.5-6)
                                .zIndex(2)
                        }
                        .onTapGesture {
                            withAnimation {
                                showPopUp.toggle()
                            }
                        }
                        
                        .offset(y: -geometry.size.height/16/2)
                        TabBarIcon(viewRouter: viewRouter, assignedPage: .shop, width: geometry.size.width/5, height: geometry.size.height/40, tabName: "Shop", img: Img.shopIcon)
                        TabBarIcon(viewRouter: viewRouter, assignedPage: .profile, width: geometry.size.width/5, height: geometry.size.height/40, tabName: "Profile", img: Img.profileIcon)
                    }.frame(width: geometry.size.width, height: geometry.size.height/11)
                    .background(Clr.darkgreen.shadow(radius: 2))
                    
                }
                
                
            }
            .edgesIgnoringSafeArea(.bottom)
        }.environmentObject(viewRouter)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewDisparateDevices {
            ContentView(viewRouter: ViewRouter())
        }
    }
}
