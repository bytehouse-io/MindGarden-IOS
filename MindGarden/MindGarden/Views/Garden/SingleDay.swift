//
//  SingleDay.swift
//  MindGarden
//
//  Created by Dante Kim on 6/19/21.
//

import SwiftUI

struct SingleDay: View {
    @Binding var showSingleModal: Bool

    var date : String {
        let formatter = DateFormatter()
        return "January 1, 2020"
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { g in
                VStack {
                    HStack(alignment: .top){
                        Spacer()
                        Img.greenBlob
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: g.size
                                    .width/1.15)
                            .position(x: UIScreen.main.bounds.maxX - g.size
                                        .width/2.2, y: 0)
                    }.padding()

                    Spacer()
                }.navigationBarItems(leading: xButton,
                                      trailing: title)

            }

        }

    }
    var xButton: some View {
        Button {
            showSingleModal = false
        } label: {
            Image(systemName: "xmark").font(.title)
                .foregroundColor(Clr.black1)
        }
    }
    var title: some View {
        VStack(alignment: .trailing){
            Text(date)
                .font(Font.mada(.semiBold, size: 26))
            Text("Blueberry Plant")
                .font(Font.mada(.bold, size: 38))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("Total Sessions")
                .font(Font.mada(.semiBold, size: 18))
        }.padding(.top, 60)
        .foregroundColor(.white)
    }
}

struct SingleDay_Previews: PreviewProvider {
    static var previews: some View {
        SingleDay(showSingleModal: .constant(true))
            .navigationViewStyle(StackNavigationViewStyle())
    }
}

