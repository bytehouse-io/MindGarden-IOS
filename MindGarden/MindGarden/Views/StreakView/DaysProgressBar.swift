//
//  DaysProgressBar.swift
//
//
//  Created by Vishal Davara on 11/03/22.
//

import MindGardenWidgetExtension
import SwiftUI

struct DayItem: Identifiable {
    var id = UUID()
    var title: String
    var plant: Plant?
    var mood: Mood?
}

struct DaysProgressBar: View {
    @EnvironmentObject var gardenModel: GardenViewModel

    @State var progress: CGFloat = 0.0
    @State var circleProgress: CGFloat = 0.0
    
    var body: some View {
        
        HStack {
            Spacer()
            ForEach(0 ..< gardenModel.lastFive.count) { index in
                let first = getFirstRegularLoggedDayInLastFive() + index
                let totalCount = gardenModel.lastFive.count - 1
                VStack {
                    Text("\(dayNumber(with: index))")
                        .foregroundColor(first ==
                                         totalCount ? Clr.redGradientBottom : Clr.black2)
                        .font(Font.fredoka(first == totalCount ? .bold : .medium, size: 15))
                        .lineLimit(1)
                        .fixedSize()
                    ZStack {
                        Rectangle()
                            .fill(getLineColor(index: first))
                            .frame(width: index == totalCount ? 0 : first == totalCount ? (50 * progress) : 50, height: 15, alignment: .leading)
                            .neoShadow()
                            .offset(x: 25)
                        Circle()
                            .fill(getColor(index: first))
                            .frame(width: first == totalCount ? (50 * circleProgress) : 50, height: 50)
                            .rightShadow()
                        if let plant = gardenModel.lastFive.getSafeIndex(first)?.1 {
                            plant.head
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 35, height: 35)
                        }
                    }
                }
                .zIndex(Double(index))
                Spacer()
            } //: ForEach
        } //: HStack
        .frame(width: UIScreen.main.bounds.width * 0.9, alignment: .center)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.easeInOut) {
                    progress = 1.0
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut) {
                    circleProgress = 1.0
                }
            }
        }
    }
    
    private func getColor(index: Int) -> Color {
        if let mood = gardenModel.lastFive.getSafeIndex(index)?.2 {
            return mood.color
        } else if let plant = gardenModel.lastFive.getSafeIndex(index)?.1 {
            if plant.title == "Ice Flower" {
                return Clr.freezeBlue
            } else {
                return Clr.orange
            }
        } else if index == gardenModel.lastFive.count - 1 {
            return Clr.orange
        }
        return Clr.darkWhite
    }

    private func getLineColor(index: Int) -> Color {
        if gardenModel.lastFive.getSafeIndex(index+1)?.2 != nil || gardenModel.lastFive.getSafeIndex(index+1)?.1 != nil {
            if let mood = gardenModel.lastFive.getSafeIndex(index)?.2 {
                return mood.color
            } else if let plant = gardenModel.lastFive.getSafeIndex(index)?.1 {
                if plant.title == "Ice Flower" {
                    return Clr.freezeBlue
                } else {
                    return Clr.orange
                }
            } else if index == gardenModel.lastFive.count - 1 {
                return Clr.orange
            }
        }
        
        return Clr.darkWhite
    }
    
    func getFirstRegularLoggedDayInLastFive() -> Int {
        let qwe = gardenModel.lastFive.enumerated().filter { $0.element.1 != nil }
        print(qwe)
        var offset = 0
        var mainOffset = 0
        for i in 0 ..< qwe.count {
            if i == 0 {
                offset = qwe[i].offset
                mainOffset = qwe[i].offset
            } else {
                if offset + 1 == qwe[i].offset {
                    offset += 1
                } else {
                    mainOffset = qwe[i].offset
                    offset = qwe[i].offset
                }
            }
            
        }
        print("main offset", mainOffset)
        return mainOffset
    }
    
    func dayNumber(with index: Int) -> String {
        var previousDay = 1
        
        let lastIndex = getFirstRegularLoggedDayInLastFive()
        
        if let previousNumber = gardenModel.lastFive.getSafeIndex(lastIndex)?.0 {
            previousDay = (Int(previousNumber) ?? 1) + index
        }
        return "Day \(previousDay)"
    }
}

struct DaysProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        DaysProgressBar()
    }
}

extension Array {
    func getSafeIndex(_ index: Int) -> Element? {
        if self.indices.contains(index) {
            return self[index]
        } else {
            return nil
        }
    }
}
