//
//  RegularVsProView.swift
//  MindGarden
//
//  Created by apple on 04/04/23.
//

import SwiftUI

struct RegularVsProView: View {
    
    var width: CGFloat
    var height: CGFloat
    
    let items = [("Regular vs\n Pro", "😔", "🤩"), ("Meditations per month", "20", "Infinite"), ("Journals per month", "20", "Infinite"), ("Mood Checks per month", "20", "Infinite"), ("2x coin booster", "🔒", "✅"), ("Unlock all Meditations", "🔒", "✅"), ("Unlock all Breathworks", "🔒", "✅")]
    
    var body: some View {
        Section {
            VStack(alignment: .trailing, spacing: 0) {
                ForEach(items, id: \.0) { item in
                    HStack {
                        if item.1 == "😔" {
                            Text("\(item.0)")
                                .foregroundColor(Clr.black2)
                                .font(Font.fredoka(.bold, size: 16))
                                .frame(width: width * 0.3, alignment: .center)
                                .lineLimit(2)
                                .minimumScaleFactor(0.05)
                                .multilineTextAlignment(.center)
                                .padding(.top)
                        } else {
                            Text("\(item.0)")
                                .foregroundColor(Clr.darkgreen)
                                .font(Font.fredoka(.semiBold, size: 16))
                                .frame(width: width * 0.25, alignment: .leading)
                                .lineLimit(2)
                                .minimumScaleFactor(0.05)
                                .multilineTextAlignment(.leading)
                        }
                        Divider()
                        Text("\(item.1)")
                            .font(Font.fredoka(.regular, size: item.1 == "😔" || item.1 == "🔒" ? 32 : 18))
                            .frame(width: width * 0.175)
                        Divider()
                        if item.2 == "Infinite" {
                            Text("∞")
                                .font(Font.fredoka(.regular, size: 36))
                                .frame(width: width * 0.175)
                        } else {
                            Text("\(item.2)")
                                .font(Font.fredoka(.regular, size: item.2 == "🤩" ? 32 : 32))
                                .frame(width: width * 0.175)
                        }
                    }
                    Divider()
                }
            } //: VStack
            .padding()
            .background(RoundedRectangle(cornerRadius: 14)
                .fill(Clr.darkWhite)
                .frame(width: width * 0.8, height: height * 0.55)
                .neoShadow())
        } //: Section
    }
}

struct RegularVsProView_Previews: PreviewProvider {
    static var previews: some View {
        RegularVsProView(width: 300, height: 300)
    }
}
