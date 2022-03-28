//
//  DaysProgressBar.swift
//
//
//  Created by Vishal Davara on 11/03/22.
//

import SwiftUI
import MindGardenWidgetExtension

struct DayItem: Identifiable {
    var id = UUID()
    var title: String
    var plant: Plant?
    var mood: Mood?
}

struct DaysProgressBar: View {
    @EnvironmentObject var gardenModel: GardenViewModel
//    var days = [DayItem(title: "M", plant: nil, mood: nil),
//                DayItem(title: "T", plant: nil, mood: nil),
//                DayItem(title: "W", plant: nil, mood: nil),
//                DayItem(title: "Th", plant: nil, mood: nil),
//                DayItem(title: "F", plant: nil, mood: nil)]
    
    var progress: CGFloat {
        return 0.3
    }
    
    
    var body: some View {
        VStack {
            ZStack(alignment:.center) {
                HStack {
                    Spacer()
                        ForEach(0..<gardenModel.lastFive.count) { index in
                            VStack {
                                Text("\(gardenModel.lastFive[index].0)")
                                    .foregroundColor(index == gardenModel.lastFive.count - 1 ? Clr.redGradientBottom : Clr.black2)
                                    .frame(width:44)
                                    .font(Font.mada(index == gardenModel.lastFive.count - 1 ? .bold : .medium, size: 20))
                                ZStack {
                                    if index != 0 {
                                        Rectangle()
                                            .fill(Clr.darkgreen)
                                            .frame(width: 40, height: 15, alignment: .leading)
                                            .neoShadow()
                                    }
                                    if let mood = gardenModel.lastFive[index].2 {
                                        Circle()
                                            .fill(mood.color)
                                            .frame(width: 50, height: 50)
                                            .neoShadow()
                                    } else {
                                        Circle()
                                            .fill(Clr.darkWhite)
                                            .frame(width: 50, height: 50)
                                            .neoShadow()
                                    }
                                    if let plant = gardenModel.lastFive[index].1 {
                                        plant.head
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 35, height: 35)
                                    }
                                }
                        }
                        Spacer()
                    }
                }.frame(width: UIScreen.main.bounds.width * 0.9, alignment: .center)
            }
        }.onAppear {
        }
    }
}

struct DaysProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        DaysProgressBar()
    }
}
