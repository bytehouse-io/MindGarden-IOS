//
//  JourneyScene.swift
//  MindGarden
//
//  Created by Vishal Davara on 01/06/22.
//

import SwiftUI

struct JourneyScene: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var model: MeditationViewModel
    @State var userModel: UserViewModel
    
    let width = UIScreen.screenWidth
    let height = UIScreen.screenHeight - 100
    
    var body: some View {
        //MARK: - New Meds
        if model.roadMaplevel == 6 {
            ( Text("🗺 Roadmap ")
                .foregroundColor(Clr.black2)
              + Text("Final Level")
                .foregroundColor(Clr.darkgreen))
                .font(Font.mada(.semiBold, size: 28))
                .padding(.top, 30)
                .frame(width: abs(width * 0.825), alignment: .leading)
        } else {
            ( Text("🗺 Roadmap Level: ")
                .foregroundColor(Clr.black2)
              + Text("\(model.roadMaplevel)")
                .foregroundColor(Clr.darkgreen))
                .font(Font.mada(.semiBold, size: 28))
                .padding(.top, 30)
                .frame(width: abs(width * 0.825), alignment: .leading)
        }
        
        VStack {
            ForEach(model.roadMapArr, id: \.self) {  item in
                HStack {
                    let index = model.roadMapArr.firstIndex(of: item)
                    let isPlayed = model.completedMeditation.contains(where: { $0 == item })
                    VStack(spacing:5) {
                        DottedLine()
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [10]))
                            .opacity((index == 0) ? 0 : 0.5)
                            .frame(width:2)
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(isPlayed ? Clr.darkgreen : Clr.lightGray)
                        DottedLine()
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [10]))
                            .opacity((index == model.roadMapArr.count - 1) ? 0 : 0.5)
                            .frame(width:2)
                    }
                    JourneyRow(width: width * 0.9, meditation: Meditation.allMeditations.first { $0.id == item } ?? Meditation.allMeditations[0], meditationModel: model, viewRouter: viewRouter)
                        .padding([.horizontal, .bottom])
                }.frame(width: width * 0.9, alignment: .trailing)
            }
            let isAward = Set(model.roadMapArr).isSubset(of: Set(model.completedMeditation))
            Text("Level Completion Award")
                .foregroundColor(Clr.black2)
                .font(Font.mada(.medium, size: 12))
            Button {
                if model.roadMaplevel < 6 && isAward {
                    userModel.updateCoins(plusCoins: 100)
                    model.getUserMap()
                    MGAudio.sharedInstance.stopSound()
                    MGAudio.sharedInstance.playSound(soundFileName: "plantUnlock.mp3")
                }
            } label: {
                HStack {
                    Img.tripleCoins
                        .resizable()
                        .foregroundColor(Color.black)
                        .font(.system(size: 28, weight: .bold))
                        .aspectRatio(contentMode: .fill)
                        .frame(width:30)
                    Text("100")
                        .foregroundColor(Clr.black2)
                        .font(Font.mada(.bold, size: 22))
                        .padding(5)
                }
                .padding()
                .background(Clr.yellow)
            }.opacity(isAward ? 1.0 : 0.4)
                .frame(height: 44, alignment: .center)
                .buttonStyle(BonusPress())
                .cornerRadius(15)
                .neoShadow()
        }.frame(width: width)
            .onAppear(){
                model.getUserMap()
        }
    }
}


struct DottedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        return path
    }
}
