//
//  ContentView.swift
//  MindGarden
//
//  Created by Dante Kim on 5/25/21.
//

import SwiftUI
import Combine
import Stinsen

struct ContentView: View {
    @ObservedObject var viewRouter: ViewRouter
    @State var showPopUp = true

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                switch viewRouter.currentPage {
                case .meditate:
                    Text("med")
                case .garden:
                    Text("garden")
                case .shop:
                    Text("shop")
                case .profile:
                    Text("profile")
                }

                Spacer()
                HStack {
                    TabBarIcon(viewRouter: viewRouter, assignedPage: .garden, width: geometry.size.width/5, height: geometry.size.height/40, tabName: "Garden", img: Img.plantIcon)
                    TabBarIcon(viewRouter: viewRouter, assignedPage: .meditate, width: geometry.size.width/5, height: geometry.size.height/40, tabName: "Meditate", img: Img.meditateIcon)
                    ZStack {
                        if showPopUp {
                            PlusMenu(width: geometry.size.width)
                                .offset(y: -geometry.size.height/8)

                        }
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
                    .offset(y: -geometry.size.height/10/2)
                    TabBarIcon(viewRouter: viewRouter, assignedPage: .garden, width: geometry.size.width/5, height: geometry.size.height/40, tabName: "Shop", img: Img.shopIcon)
                        .background(Color.red).zIndex(2)
                    TabBarIcon(viewRouter: viewRouter, assignedPage: .garden, width: geometry.size.width/5, height: geometry.size.height/40, tabName: "Profile", img: Img.profileIcon)
                }.frame(width: geometry.size.width, height: geometry.size.height/11)

                .padding(.top, 10)
                .background(Clr.darkgreen.shadow(radius: 2))
            }         .edgesIgnoringSafeArea(.bottom)
        }.environmentObject(viewRouter)
    }
}

struct PlusMenu: View {
    let width: CGFloat

    var body: some View {
         VStack {
            HStack {
                Text("bingo").font(.title)
            }
         }
         .frame(width: width/2.5, height: width/2.5)
         .background(Color.white)
         .cornerRadius(20)
         .shadow(color: .black.opacity(0.25), radius: 4, x: 4, y: 4)
     }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewRouter: ViewRouter())
    }
}
