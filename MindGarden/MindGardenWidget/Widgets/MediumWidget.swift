//
//  MediumWidget.swift
//  MindGardenWidgetExtension
//
//  Created by Vishal Davara on 30/07/22.
//

import SwiftUI

struct MediumEntry {
    let lastDate:String
    let lastMood:String
    let meditationId:Int?
    let breathworkId:Int?
    
    var moodImage:Image {
        return Mood.getMoodImage(mood: Mood.getMood(str: lastMood))
    }
    
    var meditation:Meditation {
        return Meditation.allMeditations.first(where: { $0.id == meditationId } ) ?? Meditation.allMeditations.first!
    }
    
    var breathWork:Breathwork {
        return Breathwork.breathworks.first(where: { $0.id == breathworkId } ) ?? Breathwork.breathworks.first!
    }
    
    func getImage(type:MediumType) -> Any? {
        switch type {
        case .journel:
            return Image("mediumWidgetJournel")
        case .meditate:
            return Image("meditatingTurtle")
//            if meditation.imgURL != "" {
//                return Image("meditatingTurtle")
//            } else {
//                return meditation.img
//            }
        case .logmood:
            return Image("mediumWidgetMood")
        case .breathwork:
            return Image("mediumWidgetBreathwork")
        }
    }
    
    func getSubtile(type:MediumType) -> String{
        switch type {
        case .journel:
            return "Last: \(lastDate)"
        case .meditate:
            return meditation.title
        case .logmood:
            return "Last Check:"
        case .breathwork:
            return breathWork.title
        }
    }
}

enum MediumType {
    case journel, meditate, logmood, breathwork
    var title: String {
        switch self {
        case .journel:
            return "Journal"
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
    
   let mediumEntry:MediumEntry
    
    var body: some View {
        VStack(spacing:0) {
            HStack(spacing:0) {
                MediumWidgetRow(mediumEntry:mediumEntry, type: .journel)
                MediumWidgetRow(mediumEntry:mediumEntry, type: .meditate)
            }
            HStack(spacing:0) {
                MediumWidgetRow(mediumEntry:mediumEntry, type: .logmood)
                MediumWidgetRow(mediumEntry:mediumEntry, type: .breathwork)
            }

        }
        .padding(5)
    }
}


struct MediumWidgetRow: View {
    
    let mediumEntry:MediumEntry
    @State var type:MediumType
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("darkWhite"))
                .addBorder(Color.black, width: 1.5, cornerRadius: 20)
            Link(destination: URL(string: "\(type.title)://io.bytehouse.mindgarden")!)  {
            HStack {
                if let img = mediumEntry.getImage(type: type) as? Image {
                    img
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:35)
                }
//                } else {
//                    AsyncImage(url: URL(string: mediumEntry.meditation.imgURL)!,
//                                      placeholder: { Text("...") },
//                                      image: { Image(uiImage: $0).resizable() })
//                              .frame(idealHeight: UIScreen.main.bounds.width / 2 * 3)
//                }
                VStack(alignment:.leading) {
                    Text(type.title)
                        .font(Font.fredoka(.bold, size: 16))
                        .foregroundColor(Color("black2"))
                        .padding(.bottom,1)
                    HStack {
                        Text(mediumEntry.getSubtile(type: type))
                            .lineLimit(1)
                            .font(Font.fredoka(.regular, size: 10))
                            .foregroundColor(Color("black2"))
                            .frame(maxWidth:.infinity,alignment: .leading)
                            .overlay(
                                HStack {
                                    if type == .logmood {
                                        HStack(spacing:0){
                                            Text(mediumEntry.getSubtile(type: type))
                                                .lineLimit(1)
                                                .font(Font.fredoka(.regular, size: 12))
                                                .opacity(0)
                                                .padding(.horizontal,0)
                                            mediumEntry.moodImage
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
        }
        .background(Color("darkWhite").cornerRadius(20).neoShadow())
        .padding(5)
        .frame(maxWidth:.infinity, maxHeight: .infinity)
    }
}
