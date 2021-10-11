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

    static func getMood(str: String) -> Mood {
        switch str {
        case "happy":
            return .happy
        case "okay":
            return .okay
        case "sad":
            return .sad
        case "angry":
            return .angry
        case "none":
            return .none
        default:
            return .none
        }
    }

    var color: Color {
        switch self {
        case .happy: return Clr.gardenGreen
        case .okay: return Clr.gardenGray
        case .sad: return Clr.gardenBlue
        case .angry: return Clr.gardenRed
        case .none: return Clr.dirtBrown
        }
    }
}
struct MoodCheck: View {
    @Binding var shown: Bool
    @Binding var showPopUp: Bool
    @State var moodSelected: Mood = .none
    @EnvironmentObject var gardenModel: GardenViewModel

    var body: some View {
        GeometryReader { g in
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .center, spacing: 10) {
                    Spacer()
                    Text("How are we feeling today?")
                            .font(Font.mada(.bold, size: K.isPad() ? 40 : 24))
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
                    }.frame(width: g.size.width * 0.85, height: g.size.height/(K.isPad() ? 3.5 : 3), alignment: .center)
                        DoneCancel(showPrompt: .constant(false),shown: $shown, width: g.size.width, height: g.size.height, mood: true, save: {
                            if moodSelected != .none {
                                Analytics.shared.log(event: .mood_tapped_done)
                                if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "signedUp" {
                                    UserDefaults.standard.setValue("mood", forKey: K.defaults.onboarding)
                                    showPopUp = true
                                }
                                gardenModel.save(key: "moods", saveValue: moodSelected.title)
                            }
                        }, moodSelected: moodSelected).padding(.bottom)
                        Spacer()
                        if K.isPad() {
                            Spacer()
                        }
                    }
                    Spacer()
                }
        }
    }
}

struct MoodCheck_Previews: PreviewProvider {
    static var previews: some View {
        MoodCheck(shown: .constant(true), showPopUp: .constant(false))
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
                    switch mood {
                    case .angry: Analytics.shared.log(event: .mood_tapped_angry)
                    case .sad: Analytics.shared.log(event: .mood_tapped_sad)
                    case .okay: Analytics.shared.log(event: .mood_tapped_okay)
                    case .happy: Analytics.shared.log(event: .mood_tapped_happy)
                    }
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

struct DoneCancel: View {
    @Binding var showPrompt: Bool
    @Binding var shown: Bool
    var width, height: CGFloat
    var mood: Bool
    var save: () -> ()
    var moodSelected: Mood?

    var body: some View {
        HStack {
            Button {
                if moodSelected != Mood.none {
                    save()
                    withAnimation {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        showPrompt = false
                        shown = false
                    }
                }
            } label: {
                Text("Done")
                    .foregroundColor(.white)
                    .font(Font.mada(.semiBold, size: 22))
            }
            .frame(width:  width * 0.3, height: min(height/6, 40))
            .background(Clr.brightGreen)
            .cornerRadius(12)
            .neoShadow()
            .padding()
            Button {
                if UserDefaults.standard.string(forKey: K.defaults.onboarding) != "signedUp" {
                    withAnimation {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        showPrompt = false
                        shown = false
                    }
                }
            } label: {
                Text("Cancel")
                    .foregroundColor(.white)
                    .font(Font.mada(.semiBold, size: 22))
            }
            .frame(width: width * 0.3, height: min(height/6, 40))
            .background(Color.gray)
            .cornerRadius(12)
            .neoShadow()
            .padding()
        }
    }
}

