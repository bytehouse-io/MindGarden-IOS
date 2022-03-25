//
//  NewUpdateModal.swift
//  MindGarden
//
//  Created by Dante Kim on 10/4/21.
//

import SwiftUI
var fourteenDay = false

struct NewUpdateModal: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @Binding var shown: Bool
    @Binding var showSearch: Bool

    var body: some View {
        GeometryReader { g in
            VStack(spacing: 10) {
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .center, spacing: 0) {
                        HStack {
                            Spacer()
//                            Img.mainIcon
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(height: g.size.height * 0.1)
                            Text("💎 You've Earned a Free 14 Day Trial!")
                                .multilineTextAlignment(.center)
                                .font(Font.mada(.bold, size: 24))
                                .foregroundColor(Clr.black2)
                                .frame(height: g.size.height * 0.1)
                            Spacer()
                        }.padding([.horizontal, .top])
                            .frame(width: g.size.width * 0.85 * 0.9)
                    
                        Img.treasureChest
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(26)
                            .frame(width:  g.size.width * 0.85 * 0.6)
                            .padding()
                        HStack {
                            Text("Just for coming back, we're offering you a free 14-day free trial of Pro. This is one time offer!")
                        }.multilineTextAlignment(.center)
                        .font(Font.mada(.semiBold, size: 18))
                        .foregroundColor(Clr.black2)
                        .frame(width: g.size.width * 0.85 * 0.8)
                        .padding(.bottom, 10)
                        .padding(.top)
//                        Button {
//                            withAnimation {
//                                UserDefaults.standard.setValue(true, forKey: "1.1Update")
//                                viewRouter.currentPage = .profile
//                            }
//                        } label: {
//                            HStack {
//                                Text("💌 ") + Text("Refer a friend ").bold().underline().foregroundColor(.blue) + Text("or rate the app for ") + Text("two free weeks")
//                                    .foregroundColor(Clr.brightGreen)
//                                    .bold()
//                                + Text(" of pro!")
//                            }.multilineTextAlignment(.leading)
//                                .font(Font.mada(.regular, size: 20))
//                        }.padding(.top, 10)
//                        .foregroundColor(Clr.black2)
//                        .frame(width: g.size.width * 0.85 * 0.8, alignment: .leading)


//                        Button {
//                            guard let url = URL(string: "https://www.reddit.com/r/MindGarden/") else { return }
//                            UIApplication.shared.open(url)
//                        } label: {
//                            HStack {
//                                Text("👨‍🌾 Join the community to chat, request features, give feedback and stay updated!")
//                                    .foregroundColor(Clr.black2)
//                                +
//                                Text(" Join Reddit")
//                                    .bold()
//                                    .foregroundColor(Clr.brightGreen)
//                            } .multilineTextAlignment(.leading)
//                        }
//                        .frame(width: g.size.width * 0.85 * 0.8, alignment: .leading)
//                        .padding(.bottom, 10)

//                        Text("- 🥳 Dante (Founder of MindGarden)")
//                            .frame(width: g.size.width * 0.85 * 0.8, alignment: .trailing)
//                            .padding(.bottom, 10)
//                            .padding(.top, 5)
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation {
                                shown = false
                                UserDefaults.standard.setValue(true, forKey: "14DayModal")
                                fourteenDay = true
                                viewRouter.currentPage = .pricing
                            }
                        } label: {
                            Capsule()
                                .fill(Clr.darkgreen)
                                .overlay(
                                    Text("Claim my free trial")
                                        .font(Font.mada(.bold, size: 18))
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                )
                                .frame(width: g.size.width * 0.6, height: g.size.height * 0.065)
                        }.buttonStyle(NeumorphicPress())
                        .padding()
                        Button {
                            withAnimation {
                                UserDefaults.standard.setValue(true, forKey: "14DayModal")
                                shown = false
                            }
                        } label: {
                                Text("No Thanks")
                                    .foregroundColor(Color.gray)
                                    .font(Font.mada(.regular, size: 20))
                        }
                        .padding(.bottom, 20)
                    }
                    .font(Font.mada(.regular, size: 18))
                    .frame(width: g.size.width * 0.85, height: g.size.height * 0.66, alignment: .center)
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
        NewUpdateModal(shown: .constant(true), showSearch: .constant(false))
    }
}
