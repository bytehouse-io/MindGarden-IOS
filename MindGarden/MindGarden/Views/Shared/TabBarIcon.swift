//
//  TabBarIcon.swift
//  MindGarden
//
//  Created by Dante Kim on 6/6/21.
//

import SwiftUI

struct TabBarIcon: View {
    @ObservedObject var viewRouter: ViewRouter
    let assignedPage: Page
    let width, height: CGFloat
    let tabName: String
    let img: Image

    var body: some View {
        VStack {
            img
                .renderingMode(.template)
                .foregroundColor(.white)
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
                .padding(.top, 10)
            //            Rectangle().frame(width: width/2, height: height/8).foregroundColor(.white)
            //                .padding(.top, 5)
            Spacer()
        }.padding(.horizontal, -5)
        .onTapGesture {
            viewRouter.currentPage = assignedPage
        }
    }
}
struct TabBarIcon_Previews: PreviewProvider {
    static var previews: some View {
        TabBarIcon(viewRouter: ViewRouter(), assignedPage: .garden, width: 0, height: 0, tabName: "bing", img: Img.shopIcon).environmentObject(ViewRouter())
    }
}
