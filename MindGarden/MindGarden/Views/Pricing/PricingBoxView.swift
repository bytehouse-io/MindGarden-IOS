//
//  PricingBoxview.swift
//  MindGarden
//
//  Created by apple on 04/04/23.
//

import SwiftUI

struct PricingBoxView: View {
    let title: String
    let price: Double
    @Binding var selected: String
    @Binding var trialLength: Int

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(selected == title ? Clr.darkgreen : Clr.darkWhite)
//                    .border(Clr.yellow, width: selected == title ? 4 : 0)
            HStack {
                VStack(alignment: .leading, spacing: -2) {
                    Text("\(title)")
                        .foregroundColor(selected == title ? .white : Clr.darkgreen)
                        .font(Font.fredoka(.semiBold, size: 20))
                        .lineLimit(1)
                        .minimumScaleFactor(0.05)
                        .multilineTextAlignment(.leading)
                    HStack(spacing: 2) {
                        if title == "Yearly" {
                            (Text(Locale.current.currencySymbol ?? "$") + Text("\(price * 2 + 0.01, specifier: "%.2f")"))
                                .strikethrough(color: Color("lightGray"))
                                .foregroundColor(Color("lightGray"))
                                .font(Font.fredoka(.regular, size: 16))
                                .lineLimit(1)
                                .minimumScaleFactor(0.05)
                                .multilineTextAlignment(.leading)
                        }
                        (Text(Locale.current.currencySymbol ?? "$") + Text("\(price, specifier: "%.2f")"))
                            .foregroundColor(selected == title ? .white : Clr.darkgreen)
                            .font(Font.fredoka(.regular, size: 16))
                            .lineLimit(1)
                            .minimumScaleFactor(0.05)
                            .multilineTextAlignment(.leading)
                    }.frame(width: 100, alignment: .leading)

                }.padding(.leading, 20)
                    .frame(width: 110)
                if title == "Lifetime" || title == "Yearly" {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Clr.yellow)
                        .overlay(
                            Text(title == "Yearly" ? "\((trialLength == 7 || trialLength == 1) ? "7 day\nfree trial" : (trialLength == 14 || trialLength == 2) ? "14 day\nfree trial" : trialLength == 0 ? "50%\nOFF" : "14 day\nfree trial")" : "day\nfree trial")
                                .foregroundColor(Color.black.opacity(0.8))
                                .font(Font.fredoka(.bold, size: 12))
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.05)
                                .lineLimit(2)
                                .padding(.horizontal, 1)
                        )
                        .frame(width: 60, height: 35, alignment: .leading)
                }
                Spacer()

                (Text(Locale.current.currencySymbol ?? "($") + Text(title == "Yearly" ? "\((round(100 * (price / 12)) / 100) - 0.01, specifier: "%.2f")" : title == "Monthly" ? "\(price, specifier: "%.2f")" : "0.00") + Text(title == "Monthly" ? "/mo" : "/mo")
                )
                .foregroundColor(selected == title ? .white : Clr.black2)
                .font(Font.fredoka(.bold, size: 20))
                .lineLimit(1)
                .minimumScaleFactor(0.05)
            }.padding(.trailing)
        }
    }
}

//struct PricingBoxView_Previews: PreviewProvider {
//    static var previews: some View {
//        PricingBoxView(title: "", price: 2, selected: <#Binding<String>#>, trialLength: <#Binding<Int>#>)
//    }
//}
