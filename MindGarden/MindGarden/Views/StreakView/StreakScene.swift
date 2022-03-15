//
//  ContentView.swift
//
//
//  Created by Vishal Davara on 28/02/22.
//

import SwiftUI


struct StreakScene: View {
    @Environment(\.presentationMode) var presentationMode
    
    var title : String {
        return "\(currentDay) Day Streak"
    }
    
    var subTitle : String {
        return "Great Work! Let's make it \(currentDay+1) \ntomorrow!"
    }
    
    @Binding var currentDay: Int
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                LottieAnimationView(filename: "fire", loopMode: .playOnce, isPlaying: .constant(true))
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
                    .frame(width: 500, height: 500, alignment: .center)
                Spacer()
                Text(title)
                    .streakTitleStyle()
                Text(subTitle)
                    .streakBodyStyle()
                    .frame(height: 100)
                DaysProgressBar(currentDay: $currentDay)
                Spacer()
                Button {
                    //TODO: implement continue tap event
                } label: {
                    Capsule()
                        .fill(Clr.gardenRed)
                        .frame(width: UIScreen.main.bounds.width * 0.8 , height: 58)
                        .overlay(
                            Text("Continue")
                                .font(Font.mada(.bold, size: 24))
                                .foregroundColor(.white)
                        )
                }
                .buttonStyle(NeumorphicPress())
                .shadow(color: Clr.shadow.opacity(0.3), radius: 5, x: 5, y: 5)
                .padding(.top, 50)
            }
            .offset(y: -145)
        }
    }
}

struct StreakScene_Previews: PreviewProvider {
    static var previews: some View {
        StreakScene(currentDay: .constant(3))
    }
}
