//
//  PricingView.swift
//  MindGarden
//
//  Created by Dante Kim on 10/26/21.
//

import SwiftUI

struct PricingView: View {
    @State private var selectedPrice = ""
    let items = [("", "😔", "🤩"), ("Total # of Meditations", "30", "Infinite"), ("Total # of Gratitudes", "40", "Infinite"), ("Total # of Mood Checks", "45", "Infinite"), ("Unlock all Meditations", "lock", "check"), ("Save data on cloud", "lock", "check")]
    var body: some View {
            GeometryReader { g in
                let width = g.size.width
                let height = g.size.height
                ZStack {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all)
                    VStack {
                        ScrollView(showsIndicators: false) {
                            ZStack {
                                Img.morningSun
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                Image(systemName: "xmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20)
                                    .foregroundColor(.gray)
                                    .padding(.leading, UIScreen.main.bounds.width/1.25)
                                    .padding(.bottom, 100)
                                    .opacity(0.5)
                            }.frame(width: g.size.width)
                            Text("Unlock Happiness with MindGarden Plus ➕")
                                .font(Font.mada(.bold, size: 24))
                                .foregroundColor(Clr.black2)
                                .multilineTextAlignment(.center)
                                .padding()
                            Button {

                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Clr.darkWhite)
                                    HStack {
                                        Text("Lifetime Plus")
                                            .foregroundColor(Clr.darkgreen)
                                            .font(Font.mada(.semiBold, size: 20))
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.05)
                                            .multilineTextAlignment(.leading)
                                            .padding(15)
                                        Spacer()
                                        VStack(spacing: -4){
                                            Text("$49.99")
                                                .foregroundColor(Clr.darkgreen)
                                                .font(Font.mada(.semiBold, size: 24))
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.05)
                                            Text("$0.00/mo")
                                                .foregroundColor(Color.black)
                                                .font(Font.mada(.regular, size: 14))
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.05)
                                        }.padding(.trailing)
                                    }
                                }
                            }.buttonStyle(NeumorphicPress())
                                .frame(width: width * 0.8, height: height * 0.08)


                            Section() {
                                VStack(alignment: .trailing, spacing: 0){
                                        ForEach(items, id: \.0){ item in
                                            HStack() {
                                                Text("\(item.0)")
                                                    .foregroundColor(Clr.darkgreen)
                                                    .font(Font.mada(.semiBold, size: 16))
                                                    .frame(width: width * 0.25, alignment: .leading)
                                                    .lineLimit(2)
                                                    .minimumScaleFactor(0.05)
                                                    .multilineTextAlignment(.leading)
                                                Divider()
                                                if item.1 == "lock" {
                                                    Image(systemName: "lock.fill")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .padding(20)
                                                        .frame(width: width * 0.175)
                                                } else {
                                                    Text("\(item.1)")
                                                        .font(Font.mada(.regular, size: item.1 == "😔" ? 32 : 18))
                                                        .frame(width: width * 0.175)
                                                }

                                                Divider()
                                                if item.2 == "Infinite" {
                                                    Image(systemName: "infinity")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .padding()
                                                        .frame(width: width * 0.175)
                                                } else if item.2 == "check" {
                                                    Image(systemName: "checkmark.square.fill")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .padding(20)
                                                        .frame(width: width * 0.175)
                                                        .foregroundColor(.green)
                                                } else {
                                                    Text("\(item.2)")
                                                        .font(Font.mada(.regular, size: item.2 == "🤩" ? 32 : 18))
                                                        .frame(width: width * 0.175)
                                                }

                                                // etc
                                            }
                                            Divider()
                                        }
                                    }
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 14)
                                                    .fill(Clr.darkWhite)
                                                    .frame(width: width * 0.8, height: height * 0.55)
                                                    .neoShadow())
                                }.frame(width: width * 0.8, height: height * 0.6)
                        }

                        Button {
                            Analytics.shared.log(event: .onboarding_tapped_sign_in)
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        } label: {
                            Capsule()
                                .fill(Clr.darkgreen)
                                .overlay(
                                    Text("Try free and subscribe")
                                        .foregroundColor(.white)
                                        .font(Font.mada(.bold, size: 18))
                                )
                        }.frame(width: width * 0.825, height: 50)
                            .padding([.horizontal])
                            .buttonStyle(NeumorphicPress())
                        Spacer()
                    }
                }
            }
    }
}

struct PricingView_Previews: PreviewProvider {
    static var previews: some View {
        PricingView()
    }
}
