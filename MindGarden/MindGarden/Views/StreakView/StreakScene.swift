//
//  ContentView.swift
//
//
//  Created by Vishal Davara on 28/02/22.
//

import SwiftUI


struct StreakScene: View {
    
    var title : String {
        return "\(currentDay) Day Streak"
    }
    
    var subTitle : String {
        return "Great Work! Let's make it \(currentDay+1) \ntomorrow!"
    }
    
    @Binding var currentDay: Int
    var body: some View {
        ZStack {
            VStack {
                Img.fire
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200, alignment: .center)
                Text(title)
                    .streakTitleStyle()
                Text(subTitle)
                    .streakBodyStyle()
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
                Spacer()
            }
        }
    }
}

struct StreakScene_Previews: PreviewProvider {
    static var previews: some View {
        StreakScene(currentDay: .constant(3))
    }
}
