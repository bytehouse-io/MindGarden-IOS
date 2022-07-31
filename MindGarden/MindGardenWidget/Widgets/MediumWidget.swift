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
    
    var subTitle: String {
        switch self {
        case .journel:
            return "Last: Mar 23, 2022"
        case .meditate:
            return "Presence & Gratitude"
        case .logmood:
            return "Last Check:"
        case .breathwork:
            return "Unwind"
        }
    }
}

struct NewMediumWidget: View {
    var body: some View {
        VStack(spacing:0) {
            HStack(spacing:0) {
                MediumWidgetRow(type: .journel)
                MediumWidgetRow(type: .meditate)
            }
            HStack(spacing:0) {
                MediumWidgetRow(type: .logmood)
                MediumWidgetRow(type: .breathwork)
            }

        }
        .padding(5)
    }
}


struct MediumWidgetRow: View {
    
    @State var type:MediumType
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("darkWhite"))
                .addBorder(Color.black, width: 1.5, cornerRadius: 20)
            HStack {
                Group {
                    switch type {
                    case .journel:
                        Image("mediumWidgetJournel")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .meditate:
                        Image("mediumWidgetTurtle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .logmood:
                        Image("mediumWidgetMood")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .breathwork:
                        Image("mediumWidgetBreathwork")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
                .frame(width:35)
                VStack(alignment:.leading) {
                    Text(type.title)
                        .font(Font.fredoka(.bold, size: 16))
                        .foregroundColor(Color("black2"))
                        .padding(.bottom,1)
                    HStack {
                        Text(type.subTitle)
                            .lineLimit(1)
                            .font(Font.fredoka(.regular, size: 10))
                            .foregroundColor(Color("black2"))
                            .frame(maxWidth:.infinity,alignment: .leading)
                            .overlay(
                                HStack {
                                    if type == .logmood {
                                        HStack(spacing:0){
                                            Text(type.subTitle)
                                                .lineLimit(1)
                                                .font(Font.fredoka(.regular, size: 12))
                                                .opacity(0)
                                            Image("veryGood")
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
}
