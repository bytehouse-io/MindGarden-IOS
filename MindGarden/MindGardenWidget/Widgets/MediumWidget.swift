//
//  MediumWidget.swift
//  MindGardenWidgetExtension
//
//  Created by Vishal Davara on 30/07/22.
//

import SwiftUI

enum MediumType {
    case journel, meditate, logmood, breathwork
    var title: String {
        switch self {
        case .journel:
            return "Journel"
        case .meditate:
            return "Meditate"
        case .logmood:
            return "Log Mood"
        case .breathwork:
            return "Breathwork"
        }
    }
}

struct NewMediumWidget: View {
    
    @State var lastDate:String
    @State var lastMood:String
    
    var body: some View {
        VStack(spacing:0) {
            HStack(spacing:0) {
                MediumWidgetRow(lastDate: lastDate, lastMood: lastMood, type: .journel)
                MediumWidgetRow(lastDate: lastDate, lastMood: lastMood, type: .meditate)
            }
            HStack(spacing:0) {
                MediumWidgetRow(lastDate: lastDate, lastMood: lastMood, type: .logmood)
                MediumWidgetRow(lastDate: lastDate, lastMood: lastMood, type: .breathwork)
            }

        }
        .padding(5)
    }
}


struct MediumWidgetRow: View {
    
    @State var lastDate:String
    @State var lastMood:String
    
    @State var type:MediumType
    let userDefaults = UserDefaults(suiteName: "group.io.bytehouse.mindgarden.widget")

    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("darkWhite"))
                .addBorder(Color.black, width: 1.5, cornerRadius: 20)
            HStack {
                getImage()
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:35)
                VStack(alignment:.leading) {
                    Text(type.title)
                        .font(Font.fredoka(.bold, size: 16))
                        .foregroundColor(Color("black2"))
                        .padding(.bottom,1)
                    HStack {
                        Text(getSubtile())
                            .lineLimit(1)
                            .font(Font.fredoka(.regular, size: 10))
                            .foregroundColor(Color("black2"))
                            .frame(maxWidth:.infinity,alignment: .leading)
                            .overlay(
                                HStack {
                                    if type == .logmood {
                                        HStack(spacing:0){
                                            Text(getSubtile())
                                                .lineLimit(1)
                                                .font(Font.fredoka(.regular, size: 12))
                                                .opacity(0)
                                                .padding(.horizontal,0)
                                            getMoodImage()
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height:15)
                                            Spacer()
                                        }
                                    } else {
                                        EmptyView()
                                    }
                                }
                            )
                        Spacer()
                    }
                }.frame(maxWidth:.infinity, maxHeight: .infinity)
            }.padding(10)
        }
        .background(Color("darkWhite").cornerRadius(20).neoShadow())
        .padding(5)
        .frame(maxWidth:.infinity, maxHeight: .infinity)
    }
    
    private func getMoodImage()->Image{
        return Mood.getMoodImage(mood: Mood.getMood(str: lastMood))
    }
    
    private func getImage() -> Image {
        switch type {
        case .journel:
            return Image("mediumWidgetJournel")
        case .meditate:
            return Image("mediumWidgetTurtle")
        case .logmood:
            return Image("mediumWidgetMood")
        case .breathwork:
            return Image("mediumWidgetBreathwork")
        }
    }
    
    
    
    private func getSubtile() -> String{
        switch type {
        case .journel:
            if let lastJournel = UserDefaults.standard.value(forKey: "lastJournel") as? String {
                return lastJournel
            }
            return "Last: \(lastDate)"
        case .meditate:
            return "Presence & Gratitude"
        case .logmood:
            return "Last Check:"
        case .breathwork:
            return "Unwind"
        }
    }
}
