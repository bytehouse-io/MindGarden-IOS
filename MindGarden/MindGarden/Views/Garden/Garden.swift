//
//  Garden.swift
//  MindGarden
//
//  Created by Dante Kim on 6/19/21.
//

import SwiftUI

struct Garden: View {
    @State var isMonth: Bool = true
    @State private var fitInScreen = false

    var body: some View {
        GeometryReader { gp in
            ScrollView(.vertical) {
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
                        Rectangle()
                            .fill(Clr.dirtBrown)
                            .frame(width: gp.size.width * 0.12, height: gp.size.width * 0.12)
                            .shadow(color: .black.opacity(0.25), radius: 10, x: 4, y: 4)
                    }.offset(y: -10)
                    HStack(spacing: 5) {
                        VStack(spacing: 15) {
                            StatBox(label: "Total Mins", img: Img.iconTotalTime, value: "255")
                            StatBox(label: "Total Sessions", img: Img.iconSessions, value: "23")
                        }
                        .frame(maxWidth: gp.size.width * 0.33, maxHeight: gp.size.height * 0.16)
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
                                HStack {
                                    Mood(mood: "okay", value: 7)
                                    Mood(mood: "angry", value: 5)
                                }.padding(.horizontal, 10)
                            }
                        }.frame(maxWidth: gp.size.width * 0.47, maxHeight: gp.size.height * 0.16)
                    }
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
                                    .frame(maxWidth: gp.size.width * 0.20)
                                Spacer()
                                FavoritePlant(title: "Tulips", count: 5, img: Img.tulips3)
                                    .frame(maxWidth: gp.size.width * 0.20)
                                Spacer()
                                FavoritePlant(title: "Blue Tulips", count: 5, img: Img.tulips3)
                                    .frame(maxWidth: gp.size.width * 0.20)
                                Spacer()
                            }.padding()
                        }.frame(maxWidth: gp.size.width * 0.82, maxHeight: gp.size.height * 0.18)
                    }.padding(.top, 15)
                }.padding(.horizontal, 25)
                .padding(.vertical, 15)
                .background(GeometryReader {
                                // calculate height by consumed background and store in
                                // view preference
                                Color.clear.preference(key: ViewHeightKey.self,
                                                       value: $0.frame(in: .local).size.height) })
            }
            .onPreferenceChange(ViewHeightKey.self) {
                self.fitInScreen = $0 < gp.size.height
            }
            .disabled(self.fitInScreen)
        }
    }
}
struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}



//MARK: - preview
struct Garden_Previews: PreviewProvider {
    static var previews: some View {
            Garden()
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
            .frame(maxWidth: 100)
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
        VStack {
            img
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(10)
                .overlay(RoundedRectangle(cornerRadius: 15)
                            .stroke(Clr.darkgreen))
            HStack {
                Text("\(title)")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text("\(count)").bold()
            }

        }
    }
}
