//
//  FlowerPop.swift
//  demo
//
//  Created by Vishal Davara on 04/04/22.
//

import SwiftUI

struct FlowerPop: View {
    @EnvironmentObject var userModel: UserViewModel
    @State private var scale = 0.0
    let title = "New!\n Red Tulips"
    @State private var isEquipped = false
    @State private var euipeButtonTitle = "Equip?"
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            LottieAnimationView(filename: "background", loopMode: .loop, isPlaying: .constant(true))
                .frame(width: UIScreen.screenWidth * 1.35 , height: UIScreen.screenHeight, alignment: .center)
            userModel.willBuyPlant?.coverImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.screenWidth/2, height: UIScreen.screenHeight/3)
                .scaleEffect(CGSize(width: scale, height: scale), anchor: .bottom)
                .animation(Animation
                            .spring(response: 0.3, dampingFraction: 3.0), value: scale)
            VStack {
                Spacer()
                    .frame(height: 100, alignment: .center)
                Text("New!\n\(userModel.willBuyPlant?.title ?? "Red Tulips")")
                    .font(.mada(.bold, size: 40))
                    .foregroundColor(Clr.black1)
                    .multilineTextAlignment(.center)
                Spacer()
                HStack {
                    Button { } label: {
                        HStack {
                            Text("Continue")
                                .foregroundColor(.black)
                                .font(Font.mada(.bold, size: 24))
                        }.frame(width: UIScreen.screenWidth * 0.85, height: 60)
                            .background(Clr.yellow)
                            .cornerRadius(25)
                            .onTapGesture {
                                withAnimation {
                                    Analytics.shared.log(event: .store_animation_continue)
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                    userModel.triggerAnimation = false
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                    }.buttonStyle(NeumorphicPress())
//                    Img.share
//                        .padding()
//                    LightButton(type:.darkGreen, title: $euipeButtonTitle) {
//                        isEquipped.toggle()
//                        euipeButtonTitle = isEquipped ? "Equipped" :"Equip?"
//                    }
//                    LightButton(title:.constant("Done"), showNextArrow: true) {
//                        presentationMode.wrappedValue.dismiss()
//                    }
                }
                .padding(.bottom,100)
            }
        }
        .onAppear() {
            DispatchQueue.main.async {
                MGAudio.sharedInstance.stopSound()
                MGAudio.sharedInstance.playSound(soundFileName: "plantUnlock.mp3")
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
