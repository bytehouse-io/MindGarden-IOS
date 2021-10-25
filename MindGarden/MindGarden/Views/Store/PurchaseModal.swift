//
//  PurchaseModal.swift
//  MindGarden
//
//  Created by Dante Kim on 6/14/21.
//

import SwiftUI

struct PurchaseModal: View {
    @Binding var shown: Bool
    @Binding var showConfirm: Bool
    @EnvironmentObject var userModel: UserViewModel
//    var img: Img = Image()

    var body: some View {
        GeometryReader { g in
            VStack {
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .center) {
                        HStack {
                            Button {
                                withAnimation {
                                    shown = false
                                }
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(.gray.opacity(0.5))
                                    .font(.title)
                                    .padding()
                            }
                            Spacer()
                            Text(userModel.willBuyPlant?.title ?? "")
                                .font(Font.mada(.bold, size: 30))
                                .lineLimit(2)
                                .minimumScaleFactor(0.05)
                                .foregroundColor(Clr.black1)
                                .padding()
                            Spacer()
                            Image(systemName: "xmark")
                                .font(.title)
                                .padding()
                                .opacity(0)
                        }
                        userModel.willBuyPlant?.packetImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: g.size.width * 0.325, height: g.size.height * 0.225, alignment: .center)
                        HStack(spacing: 5) {
                            Text(" \(userModel.willBuyPlant?.description ?? "")")
                                .font(Font.mada(.semiBold, size: 20))
                                .foregroundColor(Clr.black1)
                        }.padding(.horizontal, 40)
                        .minimumScaleFactor(0.05)
                        .lineLimit(5)
                        HStack(spacing: 10){
//                            userModel.willBuyPlant?.title == "Aloe" || userModel.willBuyPlant?.title == "Monstera" ?
//                            Img.pot
//                            :
                            Img.seed
                            Image(systemName: "arrow.right")
                            userModel.willBuyPlant?.one
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: g.size.width * 0.16)
                            Image(systemName: "arrow.right")
                            userModel.willBuyPlant?.two
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: g.size.width * 0.18)
                            Image(systemName: "arrow.right")
                            userModel.willBuyPlant?.coverImage
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: g.size.width * 0.2)
                        }.padding(.horizontal, 10)
                        Button {
                            Analytics.shared.log(event: .store_tapped_purchase_modal_buy)
                            if userCoins >= userModel.willBuyPlant?.price ?? 0 {
                                withAnimation {
                                    showConfirm = true
                                }
                            }
                        } label: {
                            Capsule()
                                .fill(Clr.darkWhite)
                                .frame(width: g.size.width * 0.25, height: g.size.height * 0.045)
                                .neoShadow()
                                .padding()
                                .overlay(HStack{
                                    Img.coin
                                        .renderingMode(.original)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: g.size.width * 0.05, height: g.size.width * 0.05)
                                    Text("\(userModel.willBuyPlant?.price ?? 0)")
                                        .font(Font.mada(.bold, size: 20))
                                        .foregroundColor(Clr.black1)
                                })
                        }
                    }.frame(width: g.size.width * 0.85, height: g.size.height * 0.70, alignment: .center)
                    .background(Clr.darkWhite)
                    .padding(.bottom)
                    .cornerRadius(12)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct PurchaseModal_Previews: PreviewProvider {
    static var previews: some View {
        PreviewDisparateDevices {
            PurchaseModal(shown: .constant(true), showConfirm: .constant(false))
        }
    }
}
