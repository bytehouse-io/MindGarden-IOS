//
//  FlowerPop.swift
//  demo
//
//  Created by Vishal Davara on 04/04/22.
//

import SwiftUI

struct FlowerPop: View {
    @State private var scale = 0.0
    let title = "New!\n Red Tulips"
    @State private var isEquipped = false
    @State private var euipeButtonTitle = "Equip?"
    var body: some View {
        ZStack {
            LottieAnimationView(filename: "background", loopMode: .loop, isPlaying: .constant(true))
                .frame(width: UIScreen.screenWidth * 1.35 , height: UIScreen.screenHeight, alignment: .center)
            Img.flower
                .scaleEffect(CGSize(width: scale, height: scale), anchor: .bottom)
                .animation(Animation
                            .spring(response: 0.3, dampingFraction: 3.0), value: scale)
            VStack {
                Spacer()
                    .frame(height: 100, alignment: .center)
                Text(title)
                    .font(.mada(.bold, size: 40))
                    .foregroundColor(Clr.superBlack)
                    .multilineTextAlignment(.center)
                Spacer()
                HStack {
                    Img.share
                        .padding()
                    LightButton(type:.darkGreen, title:$euipeButtonTitle) {
                        isEquipped.toggle()
                        euipeButtonTitle = isEquipped ? "Equipped" :"Equip?"
                    }
                    LightButton(title:.constant("Done"), showNextArrow: true) {
                        //TODO: implement done action
                        print("Done")
                    }
                }
                .padding(.bottom,100)
            }
        }
        .onAppear() {
            DispatchQueue.main.async {
                withAnimation(Animation.spring(response: 0.3, dampingFraction: 3.0)) {
                    scale = 1.0
                }
            }
        }
    }
}

struct FlowerPop_Previews: PreviewProvider {
    static var previews: some View {
        FlowerPop()
    }
}
