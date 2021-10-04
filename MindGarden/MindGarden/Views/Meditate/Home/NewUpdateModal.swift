//
//  NewUpdateModal.swift
//  MindGarden
//
//  Created by Dante Kim on 10/4/21.
//

import SwiftUI

struct NewUpdateModal: View {
    var body: some View {
        GeometryReader { g in
            VStack(spacing: 10) {
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .center, spacing: 0) {
                        HStack {
                            Spacer()
                            Text("Welcome to MindGarden!")
                                .font(Font.mada(.bold, size: 30))
                                .foregroundColor(Clr.black1)
                            Spacer()
                        }.padding()
                    }
                    .frame(width: g.size.width * 0.85, height: g.size.height * (K.hasNotch() ? 0.55 : 0.6), alignment: .center)
                    Spacer()
                }
            }
        }
    }
}

struct NewUpdateModal_Previews: PreviewProvider {
    static var previews: some View {
        NewUpdateModal()
    }
}
