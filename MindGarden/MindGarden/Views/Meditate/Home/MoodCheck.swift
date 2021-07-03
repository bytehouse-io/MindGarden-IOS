//
//  MoodCheck.swift
//  MindGarden
//
//  Created by Dante Kim on 6/29/21.
//

import SwiftUI

enum Mood: String {
    case happy
    case okay
    case sad
    case angry
    case none

    var title: String {
        switch self {
        case .happy: return "happy"
        case .okay: return "okay"
        case .sad: return "sad"
        case .angry: return "angry"
        case .none: return "none"
        }
    }
}
struct MoodCheck: View {
    @Binding var shown: Bool
    @State var moodSelected: Mood = .none

    var body: some View {
        GeometryReader { g in
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .center, spacing: 10) {
                    Spacer()
                    Text("How are we feeling today?")
                        .font(Font.mada(.bold, size: 24))
                        .foregroundColor(Clr.black1)
                    ZStack(alignment: .center) {
                        Rectangle()
                            .fill(Clr.darkWhite)
                            .cornerRadius(12)
                            .neoShadow()
                        HStack {
                            SingleMood(moodSelected: $moodSelected, mood: .happy)
                            SingleMood(moodSelected: $moodSelected, mood: .okay)
                            SingleMood(moodSelected: $moodSelected, mood: .sad)
                            SingleMood(moodSelected: $moodSelected, mood: .angry)
                        }
                    }.frame(width: g.size.width * 0.85, height: g.size.height/3, alignment: .center)
                        HStack {
                            Button {
                                withAnimation {
                                    shown = false
                                }
                            } label: {
                                Text("Done")
                                    .foregroundColor(.white)
                                    .font(Font.mada(.semiBold, size: 22))
                            }
                            .frame(width:  g.size.width * 0.3, height: g.size.height/6)
                            .background(Clr.brightGreen)
                            .cornerRadius(12)
                            .neoShadow()
                            .padding()
                            Button {
                                withAnimation {
                                    shown = false
                                }
                            } label: {
                                Text("Cancel")
                                    .foregroundColor(.white)
                                    .font(Font.mada(.semiBold, size: 22))
                            }
                            .frame(width:  g.size.width * 0.3, height: g.size.height/6)
                            .background(Color.gray)
                            .cornerRadius(12)
                            .neoShadow()
                            .padding()
                        }.padding(.bottom)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct MoodCheck_Previews: PreviewProvider {
    static var previews: some View {
        MoodCheck(shown: .constant(true))
            .frame(width: UIScreen.main.bounds.width, height: 250)
            .background(Clr.darkWhite)
            .cornerRadius(12)
    }
}

struct SingleMood: View {
    @Binding var moodSelected: Mood
    var mood: Mood

    var body: some View {
        ZStack {
            K.getMoodImage(mood: mood)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(5)
                .onTapGesture {
                    if moodSelected == mood {
                        moodSelected = .none
                    } else {
                        moodSelected = mood
                    }
                }
                .opacity(moodSelected == mood ? 0.3 : 1)
            if moodSelected == mood {
                Image(systemName: "checkmark")
                    .font(Font.title.weight(.bold))
            }
        }
    }
}
