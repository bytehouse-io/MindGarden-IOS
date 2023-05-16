//
//  LeavesView.swift
//  MindGarden
//
//  Created by apple on 01/04/23.
//

import SwiftUI

struct LeavesView: View {
    var body: some View {
        if !K.isSmall() && K.hasNotch() {
            HStack {
                Img.topBranch
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.screenWidth * 0.6)
                    .padding(.leading, -20)
                    .offset(x: -20, y: -15)
                Spacer()
            } //: HStack
        } else {
            Spacer()
        }
    }
}

struct LeavesView_Previews: PreviewProvider {
    static var previews: some View {
        LeavesView()
    }
}
