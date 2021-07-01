//
//  MoodCheck.swift
//  MindGarden
//
//  Created by Dante Kim on 6/29/21.
//

import SwiftUI

struct MoodCheck: View {
    @Binding var shown: Bool

    var body: some View {
        GeometryReader { g in
            VStack(spacing: 10) {
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .center, spacing: 0) {
                        Text("bouje")
                    }.frame(width: g.size.width, height: g.size.height * 0.35, alignment: .center)
                    .background(Clr.darkWhite)
                    .cornerRadius(12)
                    Spacer()
                }
            }.frame(width: g.size.width, height: g.size.height, alignment: .bottom)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct MoodCheck_Previews: PreviewProvider {
    static var previews: some View {
        MoodCheck(shown: .constant(true))
    }
}
