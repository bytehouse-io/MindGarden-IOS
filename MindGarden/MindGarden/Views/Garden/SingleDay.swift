//
//  SingleDay.swift
//  MindGarden
//
//  Created by Dante Kim on 6/19/21.
//

import SwiftUI

struct SingleDay: View {
    @Binding var showSingleModal: Bool

    var date : String {
        let formatter = DateFormatter()
        return "January 1, 2020"
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { g in
                ZStack {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all)
                    VStack(alignment: .leading) {
                        ZStack {
                            Img.greenBlob
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: g.size
                                        .width/1, height: g.size.height/1.6)
                                .offset(x: g.size.width/6, y: -g.size.height/4)
                            Img.redTulips3
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: g.size.width/2.2)
                                .offset(y: -35)
                        }.padding(.bottom, -95)

                        Text("Stats For the Day: ")
                            .foregroundColor(.black)
                            .font(Font.mada(.semiBold, size: 26))
                            .padding(.leading, 35)
                        HStack(spacing: 15) {
                            VStack(spacing: 25) {
                                StatBox(label: "Total Mins", img: Img.iconTotalTime, value: "255")
                                StatBox(label: "Total Sessions", img: Img.iconSessions, value: "23")
                                ZStack {
                                    Rectangle()
                                        .fill(Clr.darkWhite)
                                        .cornerRadius(15)
                                        .neoShadow()
                                    VStack(spacing: -5) {
                                        Text("Moods:")
                                            .foregroundColor(.black)
                                            .font(Font.mada(.regular, size: 16))
                                        HStack(spacing: 0) {
                                            K.getMoodImage(mood: .happy)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .padding(5)
                                            K.getMoodImage(mood: .angry)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .padding(5)

                                        }
                                    }.padding(3)
                                }
                                .padding(.trailing, 10)
                            }
                            .frame(maxWidth: g.size.width * 0.38)
                            ZStack {
                                Rectangle()
                                    .fill(Clr.darkWhite)
                                    .cornerRadius(15)
                                    .neoShadow()
                                VStack(spacing: 5){
                                    Text("Gratitude: ")
                                        .foregroundColor(.black)
                                        .font(Font.mada(.semiBold, size: 16))
                                    ScrollView(showsIndicators: false) {
                                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
                                            .fixedSize(horizontal: false, vertical: true)
                                            .foregroundColor(.black)
                                            .font(Font.mada(.regular, size: 14))
                                    }
                                }.padding(5)
                            }
                        }.frame(maxHeight: g.size.height * 0.40)
                        .padding(.horizontal, g.size.width * 0.1)

                        Spacer()
                    }
                }.navigationBarItems(leading: xButton,
                                     trailing: title)
            }
        }
    }

    var xButton: some View {
        Button {
            showSingleModal = false
        } label: {
            Image(systemName: "xmark").font(.title)
                .foregroundColor(Clr.black1)
        }
    }

    var title: some View {
        VStack(alignment: .trailing){
            Text(date)
                .font(Font.mada(.semiBold, size: 26))
            Text("Blueberry Plant")
                .font(Font.mada(.bold, size: 38))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("Total Sessions")
                .font(Font.mada(.semiBold, size: 18))
        }.padding(.top, 60)
        .foregroundColor(.white)
    }
}

struct SingleDay_Previews: PreviewProvider {
    static var previews: some View {
            SingleDay(showSingleModal: .constant(true))
                .navigationViewStyle(StackNavigationViewStyle())
    }
}

