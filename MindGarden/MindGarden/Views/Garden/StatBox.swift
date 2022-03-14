//
//  StatsBox.swift
//  MindGarden
//
//  Created by Dante Kim on 6/19/21.
//

import SwiftUI

struct StatBox: View {
    let label: String
    let img: Image
    let value: String

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(Clr.darkWhite)
                .cornerRadius(15)
                .neoShadow()
            HStack(spacing: 0){
                img
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(8)
                    .frame(width: 65)
                if label == "Total Minutes"  {
                    Spacer()
                }
                    VStack(alignment: .center, spacing: 0) {
                        Text(label)
                            .font(Font.mada(.regular, size: 12))
                            .minimumScaleFactor(0.05)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                        Text(value)
                            .font(Font.mada(.bold, size: 22))
                            .minimumScaleFactor(0.05)
                            .multilineTextAlignment(.center)
                    }.padding(5)
                    .offset(x: label == "Total Minutes" ? 0 : -3)
                if label == "Total Minutes"  {
                    Spacer()
                }
            }.frame(height:60)
        }
    }
}

struct StatsBox_Previews: PreviewProvider {
    static var previews: some View {
        StatBox(label: "Total Mins", img: Img.iconTotalTime, value: "255")
    }
}
