//
//  BreathMiddle.swift
//  MindGarden
//
//  Created by Dante Kim on 7/2/22.
//

import SwiftUI

struct BreathMiddle: View {
    var body: some View {
        ZStack {
            Clr.darkWhite
            GeometryReader { g in
                let width = g.size.width
                let height = g.size.height
                VStack(alignment: .center) {
                    Text("Hello, World!1")
                    HStack {
                        Spacer()
                        Rectangle()
                            .fill(Clr.calmPrimary)
                            .frame(width: width * 0.85, height: height * 0.2)
                            .addBorder(Color.black, width: 1.5, cornerRadius: 14)
                        Spacer()
                    }
                }
            }
        
        }
    }
}

struct BreathMiddle_Previews: PreviewProvider {
    static var previews: some View {
        BreathMiddle()
    }
}
