//
//  NewUpdateModal.swift
//  MindGarden
//
//  Created by Dante Kim on 10/4/21.
//

import SwiftUI

struct NewUpdateModal: View {
    @Binding var shown: Bool

    var body: some View {
        GeometryReader { g in
            VStack(spacing: 10) {
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .center, spacing: 0) {
                        Spacer()
                        HStack {
                            Spacer()
                            Img.mainIcon
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: g.size.height * 0.12)
                            Text("Welcome to \nMindGarden! \nUpdate 1.0")
                                .font(Font.mada(.bold, size: 24))
                                .foregroundColor(Clr.black2)
                                .frame(height: g.size.height * 0.12)
                            Spacer()
                        }.padding(.horizontal)
                    Text("🌚 In this update we added dark mode and 2 new meditations for students taking their finals")
                            .frame(width: g.size.width * 0.85 * 0.8, alignment: .leading)
                            .padding(.bottom, 10)
                            .padding(.top)
                        Button {

                        } label: {
                            HStack {
                                Text("🗺 Check out our ") + Text("roadmap").bold().underline().foregroundColor(.blue) + Text(" to request any features")
                            }.multilineTextAlignment(.leading)

                        }
                        .foregroundColor(Clr.black2)
                        .frame(width: g.size.width * 0.85 * 0.8, alignment: .leading)
                        .padding(.bottom, 10)


                        Button {
                            guard let url = URL(string: "https://www.reddit.com/r/MindGarden/") else { return }
                            UIApplication.shared.open(url)
                        } label: {
                            HStack {
                                Text("👨‍🌾 Join the community to chat, request features, give feedback and stay updated!")
                                    .foregroundColor(Clr.black2)
                                +
                                Text(" Join Reddit")
                                    .bold()
                                    .foregroundColor(Clr.brightGreen)
                            } .multilineTextAlignment(.leading)
                        }
                        .frame(width: g.size.width * 0.85 * 0.8, alignment: .leading)
                        .padding(.bottom, 10)

                        Text("- 🥳 Dante (Founder of MindGarden)")
                            .frame(width: g.size.width * 0.85 * 0.8, alignment: .trailing)
                            .padding(.bottom, 10)
                            .padding(.top, 5)
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation {
                                shown = false
                                UserDefaults.standard.setValue(true, forKey: "1.0Update")
                            }
                        } label: {
                            Capsule()
                                .fill(Clr.brightGreen)
                                .overlay(
                                    Text("Got it!")
                                        .font(Font.mada(.bold, size: 18))
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                )
                                .frame(width: g.size.width * 0.7 * 0.5, height: g.size.height * 0.05)
                        }.buttonStyle(NeumorphicPress())
                        Spacer()
                    }
                    .font(Font.mada(.regular, size: 18))
                    .frame(width: g.size.width * 0.85, height: g.size.height * (K.hasNotch() ? 0.7 : 0.75), alignment: .center)
                    .minimumScaleFactor(0.05)
                    .background(Clr.darkWhite)
                    .neoShadow()
                    .cornerRadius(12)
                    .offset(y: -50)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct NewUpdateModal_Previews: PreviewProvider {
    static var previews: some View {
        NewUpdateModal(shown: .constant(true))
    }
}
