//
//  Garden.swift
//  MindGarden
//
//  Created by Dante Kim on 6/19/21.
//

import SwiftUI

struct Garden: View {
    @State var isMonth: Bool = true

    var body: some View {
        VStack {
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
            GridStack(rows: 5, columns: 7) { row, col in
                Rectangle()
                    .fill(Clr.dirtBrown)
                    .frame(minWidth: 40, maxWidth: 55, minHeight: 40, maxHeight: 55)
                    .shadow(color: .black.opacity(0.25), radius: 10, x: 4, y: 4)
            }.offset(y: -10)
            HStack(spacing: 5) {
                VStack(spacing: 15) {
                    StatBox(label: "Total Mins", img: Img.iconTotalTime, value: "255")
                    StatBox(label: "Total Sessions", img: Img.iconSessions, value: "23")
                }
                ZStack {
                    Rectangle()
                        .fill(Clr.darkWhite)
                        .cornerRadius(15)
                        .neoShadow()
                    VStack(spacing: 0) {
                        HStack(alignment: .bottom) {
                            Mood(mood: "happy", value: 13)
                            Mood(mood: "sad", value: 2)
                        }.padding(.horizontal, 10)
                        HStack {
                            Mood(mood: "okay", value: 7)
                            Mood(mood: "angry", value: 5)
                        }.padding(.horizontal, 10)
                    }
                }.frame(maxWidth: 200, maxHeight: 135)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text("Favorite Plants:")
                    .foregroundColor(.black)
                    .font(Font.mada(.semiBold, size: 20))
                    .padding(.leading, 5)
                HStack {
                    Rectangle()
                        .fill(Clr.darkWhite)
                        .cornerRadius(15)
                        .neoShadow()
                }.frame(maxWidth: 350, maxHeight: 150)
            }.padding(.top, 25)

        }.padding(.horizontal, 25)
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
                    .font(Font.mada(.regular, size: 12))
                Text(String(value))
                    .font(Font.mada(.semiBold, size: 18))
            }.frame(maxWidth: 32)
        }.frame(maxWidth: 80, maxHeight: 60)
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
