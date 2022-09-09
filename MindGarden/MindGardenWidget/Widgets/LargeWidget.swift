//
//  LargeWidget.swift
//  MindGardenWidgetExtension
//
//  Created by Vishal Davara on 30/07/22.
//

import SwiftUI

struct LargeWidget: View {
    @EnvironmentObject var gardenModel: GardenViewModel
    var grid = [String: [String:[String:[String:Any]]]]()
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    let showTileDate = true
    var body: some View {
        GeometryReader { gp in
            let width = gp.size.width*0.15
            ZStack {
                HStack {
                    Spacer()
                LazyVGrid(columns: columns, spacing: 0) {
                    let totalRow = Date.needsExtraRow(month: gardenModel.selectedMonth, year: gardenModel.selectedYear) ? 6 : 5
                    let total =  totalRow * 7
                    ForEach(1...total, id: \.self) { index in
                        ZStack {
                            let c = gardenModel.placeHolders
                            let row    = Int(index/7)
                            let col = index % 7
                            let currentDate = col + (row * 7) - c
                            let maxDate = Date().getNumberOfDays(month: String(gardenModel.selectedMonth),year:String(gardenModel.selectedYear))
                            if index <= c {
                                Rectangle()
                                    .fill(Clr.calenderSquare)
                                    .border(.white, width: 1)
                            } else {
                            
                                let plant = gardenModel.monthTiles[row]?[currentDate]?.0
                                let mood = gardenModel.monthTiles[row]?[currentDate]?.1
                                
                                let dateOnTiles = Text(currentDate <= maxDate ? "\(currentDate)" : "").offset(x: 5, y: 15)
                                    .font(Font.fredoka(.semiBold, size: 10))
                                    .foregroundColor(Color.black)
                                    .padding(.leading)
                                    .opacity(showTileDate ? 1.0 : 0)
                                
                                if  plant != nil && mood != nil {
                                     //mood & plant both exist
                                     //first tile in onboarding
                                    let plantHead = gardenModel.monthTiles[row]?[currentDate]?.0?.head
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .padding(3)
                                    ZStack {
                                        Rectangle()
                                            .fill(gardenModel.monthTiles[row]?[currentDate]?.1?.color ?? Clr.calenderSquare)
                                            .border(.white, width: 1)
                                        plantHead
                                            
                                        dateOnTiles
                                    }
                                } else if mood == nil { // only mood is nil
                                    ZStack {
                                        let plant = gardenModel.monthTiles[row]?[currentDate]?.0
                                        let plantHead = gardenModel.monthTiles[row]?[currentDate]?.0?.head
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .padding(3)
                                        Rectangle()
                                            .fill(plant?.title == "Ice Flower" ? Clr.freezeBlue : Clr.calenderSquare)
                                            .border(.white, width: 1)
                                        plantHead
                                            
                                        dateOnTiles
                                    }
                                } else if plant == nil { // only plant is nil
                                    ZStack {
                                        Rectangle()
                                            .fill(gardenModel.monthTiles[row]?[currentDate]?.1?.color ?? Clr.calenderSquare)
                                            .border(.white, width: 1)
                                        dateOnTiles
                                    }
                                } else { //both are nil
                                    ZStack {
                                        Rectangle()
                                            .fill(Clr.calenderSquare)
                                            .border(.white, width: 1)
                                        dateOnTiles
                                    }
                                }
                            }
                        }
                        .frame(width: width, height: width)
                    }
                }
                Spacer()
                }
            }.padding()
                .onAppear() {
                    gardenModel.grid = grid
                    gardenModel.populateMonth()
            }
        }
    }
}





