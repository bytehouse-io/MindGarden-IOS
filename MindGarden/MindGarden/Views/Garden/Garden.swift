//
//  Garden.swift
//  MindGarden
//
//  Created by Dante Kim on 6/19/21.
//

import SwiftUI

struct Garden: View {
    @State var isMonth: Bool = true
    @State var showSingleModal = false

    var body: some View {
        GeometryReader { gp in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .center, spacing: 20) {
                    HStack(spacing: 40) {
                        Button {
                            isMonth = true
                        } label: {
                            MenuButton(title: "Month", isMonth: isMonth)
                        }
                        Button {
                            isMonth = false
                        } label: {
                            MenuButton(title: "Year", isMonth: !isMonth)
                        }
                    }
                    HStack {
                        Text("April 2021")
                            .font(Font.mada(.bold, size: 30))
                        Spacer()
                        Button {

                        } label: {
                            OperatorButton(imgName: "lessthan.square.fill")
                        }

                        Button {

                        } label: {
                            OperatorButton(imgName: "greaterthan.square.fill")
                        }
                    }
                    .padding(.horizontal, 10)
                    GridStack(rows: 5, columns: 7) { row, col in
                        ZStack {
                            Rectangle()
                                .fill(Clr.dirtBrown)
                                .frame(width: gp.size.width * 0.12, height: gp.size.width * 0.12)
                                .shadow(color: .black.opacity(0.25), radius: 10, x: 4, y: 4)
                            Img.oneBlueberry
                                .padding(3)
                        }
                    }.offset(y: -10)
                    .onTapGesture {
                        showSingleModal = true
                    }
                    HStack(spacing: 5) {
                        VStack(spacing: 15) {
                            StatBox(label: "Total Mins", img: Img.iconTotalTime, value: "255")
                            StatBox(label: "Total Sessions", img: Img.iconSessions, value: "23")
                        }
                        .frame(maxWidth: gp.size.width * 0.33)
                        ZStack {
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .cornerRadius(15)
                                .neoShadow()
                            VStack(spacing: 10) {
                                HStack(alignment: .bottom) {
                                    Mood(mood: "happy", value: 13)
                                    Mood(mood: "sad", value: 2)
                                }.padding(.horizontal, 10)
                                HStack(alignment: .bottom) {
                                    Mood(mood: "okay", value: 7)
                                    Mood(mood: "angry", value: 5)
                                }.padding(.horizontal, 10)
                            }
                        }.frame(maxWidth: gp.size.width * 0.47)
                    }.frame(maxHeight: gp.size.height * 0.16)
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Favorite Plants:")
                            .foregroundColor(.black)
                            .font(Font.mada(.semiBold, size: 20))
                            .padding(.leading, 5)
                        ZStack {
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .cornerRadius(15)
                                .neoShadow()
                            HStack{
                                Spacer()
                                FavoritePlant(title: "Tulips", count: 5, img: Img.tulips3)
                                Spacer()
                                FavoritePlant(title: "Tulips", count: 5, img: Img.tulips3)
                                Spacer()
                                FavoritePlant(title: "Blue Tulips", count: 5, img: Img.tulips3)
                                Spacer()
                            }
                        }.frame(maxWidth: gp.size.width * 0.8, maxHeight: gp.size.height * 0.4)
                    }.padding(.top, 15)
                }.padding(.horizontal, 25)
                .padding(.vertical, 15)
            }
            .sheet(isPresented: $showSingleModal) {
                SingleDay(showSingleModal: $showSingleModal)
                    .navigationViewStyle(StackNavigationViewStyle())
            }
        }
    }
}


//MARK: - preview
struct Garden_Previews: PreviewProvider {
    static var previews: some View {
        PreviewDisparateDevices {
            Garden()
        }
    }
}

//MARK: - components
struct Mood: View {
    let mood: String
    let value: Int

    var body: some View {
        HStack(spacing: 0) {
            K.getMoodImage(mood: mood)
                .resizable()
                .aspectRatio(contentMode: .fit)
            VStack(alignment: .center) {
                Text(mood)
                    .font(.subheadline)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                Text(String(value))
                    .font(.headline)
                    .bold()
            }.padding(.leading, 3)
            .frame(maxWidth: 40)
        }.padding(3)
    }
}


struct MenuButton: View {
    var title: String
    var isMonth: Bool

    var body: some View {
        ZStack {
            Capsule()
                .fill(isMonth ? Clr.gardenGreen : Clr.darkWhite)
                .frame(width: 100, height: 35)
                .neoShadow()
            Text(title)
                .font(Font.mada(.regular, size: 16))
                .foregroundColor(isMonth ? .white : Clr.black1)
        }
    }
}

struct OperatorButton: View {
    let imgName: String

    var body: some View {
        Image(systemName: imgName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .background(Clr.darkgreen)
            .foregroundColor(Clr.darkWhite)
            .cornerRadius(10)
            .frame(height: 35)
            .neoShadow()
    }
}

struct FavoritePlant: View {
    let title: String
    let count: Int
    let img: Image

    var body: some View {
            VStack(spacing: 0) {
                img
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(8)
                    .overlay(RoundedRectangle(cornerRadius: 15)
                                .stroke(Clr.darkgreen))
                HStack {
                    Text("\(title)")
                        .font(Font.mada(.regular, size: 16))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Text("\(count)").bold()
                        .font(Font.mada(.bold, size: 16))
                }.padding(.top, 8)
            }.frame(width: 70, height: 120)
            .padding(10)
        }
}
