//
//  IAPModal.swift
//  MindGarden
//
//  Created by Dante Kim on 4/3/22.
//

import SwiftUI
import Purchases
import AppsFlyerLib
import Amplitude

struct IAPModal: View {
    @Binding var shown: Bool

    var body: some View {
        GeometryReader { g in
            VStack(spacing: 10) {
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .center, spacing: 0) {
                        ZStack {
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation { shown.toggle() }
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(.gray.opacity(0.5))
                                    .font(.system(size: 22))
                                    .padding()
                            }.position(x: 30, y: 35)
                            HStack(alignment: .center) {
                                Text("Daily Bonus")
                                    .font(Font.mada(.bold, size: 30))
                                    .foregroundColor(Clr.black1)
                                    .padding()
                            }.padding(.bottom, -5)

                        }.frame(height: g.size.height * 0.08)
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            
                        } label: {
                            PurchaseBox(width: g.size.width, height: g.size.height, img: Img.streak, title: "Freeze Streak", subtitle: "Protect your streak if you a miss a day of meditation. Equip 2 at once")
                        }.padding(.bottom, 10)
                        .buttonStyle(NeumorphicPress())
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            
                        } label: {
                            PurchaseBox(width: g.size.width, height: g.size.height, img: Img.sunshinepotion, title: "Sunshine Potion", subtitle: "Potion will activate & triple coins after every meditation for 1 WEEK")
                        }.padding(.bottom, 10)
                            .buttonStyle(NeumorphicPress())
                        Spacer()
                        Spacer()
                    }
                    .frame(width: g.size.width * 0.85, height: g.size.height * 0.7, alignment: .center)
                    .background(Clr.darkWhite)
                    .cornerRadius(12)
                    Spacer()
                }
                Spacer()
            }
        }
    }
    
    struct PurchaseBox: View {
        let width, height: CGFloat
        let img: Image
        let title: String
        let subtitle: String


        var body: some View {
            ZStack(alignment: .center){
                Rectangle()
                    .fill(Clr.darkWhite)
                    .cornerRadius(15)
                    .neoShadow()
                Capsule()
                    .fill(Clr.yellow)
                    .frame(width: 75, height: 25)
                    .neoShadow()
                    .overlay(HStack(spacing: 5) {
                        Img.moneybag
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 12)
                        Text("0.99")
                            .foregroundColor(Clr.darkgreen)
                            .font(Font.mada(.medium, size: 16))
                    })
                    .position(x: width * 0.615, y: height * 0.03)
                HStack(spacing: 10){
                    Img.fire
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35)
                    VStack(alignment: .leading) {
                        HStack {
                            Text(title)
                                .foregroundColor(title == "Freeze Streak" ? Clr.freezeBlue : Clr.sunshine)
                                .font(Font.mada(.bold, size: 18))
                        }
                        Text(subtitle)
                            .foregroundColor(Clr.black2)
                            .font(Font.mada(.medium, size: 12))
                    }.frame(width: width * 0.5)
                        .padding(.trailing)
                }.frame(width: width * 0.75)
            }
            .frame(width: width * 0.75, height: height * 0.125)
            .padding()
        }
    }
}

struct IAPModal_Previews: PreviewProvider {
    static var previews: some View {
        IAPModal(shown: .constant(false))
    }
}
