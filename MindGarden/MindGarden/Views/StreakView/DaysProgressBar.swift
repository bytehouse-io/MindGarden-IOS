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
            HStack(alignment:.center) {
                Spacer()
                ForEach(0..<gardenModel.lastFive.count) { index in
                    if index == gardenModel.lastFive.count - 1 {
                        Text("\(gardenModel.lastFive[index].0)")
                            .currentDayStyle()
                    } else {
                        Text("\(gardenModel.lastFive[index].0)")
                            .daysProgressTitleStyle()
                    }
                    Spacer()
                }
            }
            
            ZStack(alignment:.center) {
                HStack {
                    Spacer()
                    ForEach(0..<gardenModel.lastFive.count) { index in
                        ZStack {
                            if index != 0 {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Clr.darkgreen)
                                    .frame(width: 40, height: 12, alignment: .leading)
                                    .offset(x: -40)
                            }
                            if let mood = gardenModel.lastFive[index].2 {
                                Circle()
                                    .fill(mood.color)
                                    .frame(width: 50, height: 50)
//                                    .progressShadow()
                            } else {
                                Circle()
                                    .fill(Clr.darkWhite)
                                    .frame(width: 50, height: 50)
                            }
                            if let plant = gardenModel.lastFive[index].1 {
                                plant.head
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 35, height: 35)
                            }
                     
                        }.padding(10)
                    }
                }.frame(width: UIScreen.main.bounds.width * 0.8, alignment: .center)
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
