//
//  LargeWidget.swift
//  MindGardenWidgetExtension
//
//  Created by Vishal Davara on 30/07/22.
//

import SwiftUI

struct LargeWidget: View {
    var body: some View {
        Text("🛠 We're working hard on creating a brand new large widget! Thank you for your patience. \n-MindGarden Team")
            .font(Font.fredoka(.semiBold, size: 24))
            .foregroundColor(Color("darkgreen"))
            .frame(width: 300)
        //                    ZStack {
        //                        if entry.is Pro {
        //                        VStack(spacing: 5) {
        //                            MediumWidget(width: width, height: height * 0.425, moods: $moods, gratitudes: $gratitudes, streak: $streak)
        //                            HStack {
        //                                ZStack {
        //                                    Rectangle()
        //                                        .fill(Color("darkWhite"))
        //                                        .cornerRadius(14)
        //                                        .neoShadow()
        //                                        HStack {
        //                                            Image(systemName: "clock")
        //                                                .resizable()
        //                                                .aspectRatio(contentMode: .fit)
        //                                                .foregroundColor(Color("darkgreen"))
        //                                                .frame(width: 25)
        //                                            Text("Total\nTime")
        //                                                .foregroundColor(Color("black2"))
        //                                                .font(Font.fredoka(.regular, size: 12))
        //                                            Text("\(totalTime/60 == 0 && totalTime != 0 ? "0.5" : "\(totalTime/60)") mins")
        //                                                .foregroundColor(Color("darkgreen"))
        //                                                .font(Font.fredoka(.bold, size: 14))
        //                                        }
        //                                }.frame(width: width * 0.435, height: height * 0.15)
        //                                ZStack {
        //                                        Rectangle()
        //                                            .fill(Color("darkWhite"))
        //                                            .cornerRadius(14)
        //                                            .neoShadow()
        //                                        HStack {
        //                                            Image(systemName: "number")
        //                                                .resizable()
        //                                                .aspectRatio(contentMode: .fit)
        //                                                .frame(width: 25)
        //                                                .foregroundColor(Color("darkgreen"))
        //                                            Text("Total\nSess")
        //                                                .foregroundColor(Color("black2"))
        //                                                .font(Font.fredoka(.regular, size: 12))
        //                                            Text("\(totalSess) sess")
        //                                                .foregroundColor(Color("darkgreen"))
        //                                                .font(Font.fredoka(.bold, size: 14))
        //                                        }
        //                                    }.frame(width: width * 0.435, height: height * 0.15)
        //                            }
        //
        //                            ZStack {
        //                                Link(destination: URL(string: "garden://io.bytehouse.mindgarden")!)  {
        //                                    Rectangle()
        //                                        .fill(Color("yellow"))
        //                                        .cornerRadius(14)
        //                                        .frame(width: width * 0.875)
        //                                        .opacity(0.8)
        //                                        .neoShadow()
        //                                    VStack(alignment: .center) {
        //                                        Spacer()
        //                                        ZStack {
        //                                            if !plants.isEmpty {
        //                                                HStack {
        //                                                    //                                        Text(plants[0].title)
        //                                                    //                                            .font(Font.fredoka(.bold, size: 40))
        //                                                    ForEach(0..<min(plants.count, 5)) { idx in
        ////                                                        let xPos = Int.random(in: -25...25)
        //                                                        Image(plants[idx].title)
        //                                                            .resizable()
        //                                                            .aspectRatio(contentMode: .fit)
        //                                                            .frame(width: 40, height: height * 0.35)
        //                                                    }
        //                                                }.frame(width: width * 0.80, height: height)
        //                                                    .padding()
        //                                            }
        //                                        }
        //                                    }.frame(width: width, height: height * 0.2)
        //
        //                                }.frame(width: width * 0.85, height: height * 0.25)
        //                                    .padding(.vertical)
        //                            }
        //                            Text("🧘 Your last 5 sessions")
        //                                .foregroundColor(Color("black2"))
        //                                .font(Font.fredoka(.regular, size: 10))
        //                                .offset(x: 90, y: -15)
        //                        }
        //                        } else {
        //                            GoProPage
        //                        }
        //                    }
    }
}





