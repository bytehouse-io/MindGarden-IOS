//
//  ReminderView.swift
//  demo
//
//  Created by Vishal Davara on 29/04/22.
//

import SwiftUI

struct ReminderView: View {
    let reminderTitle = "SET A REMINDER"
    @State private var time = 0.0
    @State private var isToggle : Bool = false
    var body: some View {
        VStack {
            Text(reminderTitle)
                .font(Font.mada(.bold, size: 20))
                .foregroundColor(Clr.black2)
            ZStack {
                Rectangle()
                    .fill(Clr.darkWhite)
                    .cornerRadius(25)
                    .neoShadow()
                VStack {
                    Slider(value: $time, in: 0...86399)
                        .accentColor(.gray)
                        .padding(.top,20)
                        .padding(.horizontal)
                    HStack {
                        Image(systemName: "cloud.sun")
                            .resizable()
                            .foregroundColor(Clr.brightGreen)
                            .aspectRatio(contentMode: .fit)
                        Spacer()
                        Image(systemName: "sun.max.fill")
                            .resizable()
                            .foregroundColor(Clr.dirtBrown)
                            .aspectRatio(contentMode: .fit)
                        Spacer()
                        Image(systemName: "moon.stars.fill")
                            .resizable()
                            .foregroundColor(Clr.freezeBlue)
                            .aspectRatio(contentMode: .fit)
                    }
                    .frame(height: 20, alignment: .center)
                    .padding(.horizontal)
                    .padding(.bottom,40)
                    ZStack {
                        Rectangle()
                            .fill(Clr.lightGray)
                            .opacity(0.4)
                            .cornerRadius(25)
                        HStack {
                            if let timeInterval = TimeInterval(time) {
                                Text(timeInterval.secondsToHourMinFormat() ?? "")
                                    .font(Font.mada(.bold, size: 20))
                                    .foregroundColor(Clr.black2)
                                Toggle(isOn: $isToggle) {}
                            }
                        }.padding()
                    }
                }
            }
        }
    }
}
