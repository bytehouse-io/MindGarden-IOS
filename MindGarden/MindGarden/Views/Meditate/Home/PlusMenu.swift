//
//  PlusMenu.swift
//  MindGarden
//
//  Created by Dante Kim on 6/28/21.
//

import SwiftUI

struct PlusMenu: View {
    @Binding var showPopUp: Bool
    @Binding var addMood: Bool
    @Binding var addGratitude: Bool

    let width: CGFloat
    var body: some View {
        ZStack {
            VStack {
                Button {
                    withAnimation {
                        showPopUp = false
                        addMood = true
                    }
                } label: {
                    MenuChoice(title: "Mood Check", img: Image(systemName: "face.smiling"))
                        .frame(width: width/2.25, height: width/10)
                }
                Button {
                    withAnimation {
                        showPopUp = false
                        addGratitude = true
                    }
                } label: {
                    MenuChoice(title: "Gratitude", img: Image(systemName: "square.and.pencil"))
                        .frame(width: width/2.25, height: width/10)
                }
                Button {
                    withAnimation {
                        showPopUp = false
                    }                } label: {
                        MenuChoice(title: "Meditate", img: Image(systemName: "play"))
                            .frame(width: width/2.25, height: width/10)
                    }
            }
        }
        .frame(width: width/2, height: width/2.25)
        .transition(.scale)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Clr.black1.opacity(0.5), radius: 4, x: 0, y: -8)
        .zIndex(-10)
    }

    struct MenuChoice: View {
        let title: String
        let img: Image

        var body: some View {
            ZStack {
                Capsule()
                    .fill(Clr.brightGreen)
                HStack {
                    img
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .padding(3)
                    Text(title)
                        .font(Font.mada(.medium, size: 20))
                        .minimumScaleFactor(0.5)
                        .foregroundColor(.white)
                }
                .padding(5)
            }
            .neoShadow()
        }
    }
}
