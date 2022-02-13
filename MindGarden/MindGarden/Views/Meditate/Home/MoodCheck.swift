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
    case stressed
    case none

    var title: String {
        switch self {
        case .happy: return "happy"
        case .okay: return "okay"
        case .sad: return "sad"
        case .angry: return "angry"
        case .stressed: return "stressed"
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
        case "stressed":
            return .stressed
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
        case .stressed: return Clr.purple
        case .none: return Clr.dirtBrown
        }
    }
    static func getMoodImage(mood: Mood) -> Image {
        switch mood {
        case .happy:
            return Image("happy")
        case .sad:
            return Image("sad")
        case .angry:
            return Image("angry")
        case .okay:
            return Image("okay")
        case .stressed:
            return Image("stressed")
        default:
            return Image("okay")
        }
    }
}
struct MoodCheck: View {
    @Binding var shown: Bool
    @Binding var showPopUp: Bool
    @State var moodSelected: Mood = .none
    @EnvironmentObject var gardenModel: GardenViewModel

    ///Ashvin : Binding variable for pass animation flag
    @Binding var PopUpIn: Bool
    @Binding var showPopUpOption: Bool
    @Binding var showItems: Bool
    @Binding var showRecs: Bool
    @State private var notifOn: Bool = false

    var body: some View {
        GeometryReader { g in
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .center, spacing: 10) {
                    Spacer()
                    Text("How are we feeling today?")
                            .font(Font.mada(.bold, size: K.isPad() ? 40 : 24))
                        .foregroundColor(Clr.black1)
                        .frame(width: g.size.width * 0.8, alignment: .center)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        HStack {
                            Text("Recommendations ")
                                    .font(Font.mada(.semiBold, size: K.isPad() ? 36 : 20))
                                    .foregroundColor(Clr.black1)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                            Toggle("", isOn: $notifOn)
                                .onChange(of: notifOn) { val in
                                    UserDefaults.standard.setValue(val, forKey: "moodRecsToggle")
                                    if val {
                                        Analytics.shared.log(event: .mood_toggle_recs_on)
                                    } else { //turned off
                                        Analytics.shared.log(event: .mood_toggle_recs_off)
                                    }
                                }.toggleStyle(SwitchToggleStyle(tint: Clr.gardenGreen))
                                .frame(width: g.size.width * 0.08, height: 10)
                        } .frame(width: g.size.width * 0.8, alignment: .center)
                    ZStack(alignment: .center) {
                        Rectangle()
                            .fill(Clr.darkWhite)
                            .cornerRadius(12)
                            .neoShadow()
                        HStack {
                            SingleMood(moodSelected: $moodSelected, mood: .happy)
                            SingleMood(moodSelected: $moodSelected, mood: .okay)
                            SingleMood(moodSelected: $moodSelected, mood: .angry)
                            SingleMood(moodSelected: $moodSelected, mood: .stressed)
                            SingleMood(moodSelected: $moodSelected, mood: .sad)
                        }.padding(.horizontal, 10)
                    }.frame(width: g.size.width * 0.9, height: g.size.height/(K.isPad() ? 3.5 : 3), alignment: .center)
                        DoneCancel(showPrompt: .constant(false),shown: $shown, width: g.size.width, height: g.size.height, mood: true, save: {
                            var num = UserDefaults.standard.integer(forKey: "numMoods")
                            num += 1
                            UserDefaults.standard.setValue(num, forKey: "numMoods")
                            if moodSelected != .none {
                                if notifOn {
                                    showRecs = UserDefaults.standard.string(forKey: K.defaults.onboarding) ?? "" == "signedUp" ? false : true
                                } else {
                                    showRecs = false
                                }
                                Analytics.shared.log(event: .mood_tapped_done)
                                if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "signedUp" {
                                    UserDefaults.standard.setValue("mood", forKey: K.defaults.onboarding)
                                    showPopupWithAnimation {}
                                }
                                gardenModel.save(key: "moods", saveValue: moodSelected.title)
                            }
                        }, moodSelected: moodSelected,showRecs: $showRecs).padding(.bottom)
    
                        Spacer()
                        if K.isPad() {
                            Spacer()
                        }
                    }
                    Spacer()
                }
        }.onAppear {
            notifOn = UserDefaults.standard.bool(forKey: "moodRecsToggle")
        }
    }

    ///Ashvin : Show popup with animation method

        private func showPopupWithAnimation(completion: @escaping () -> ()) {
            withAnimation(.easeIn(duration:0.14)){
                showPopUp = true
            }
            withAnimation(.easeIn(duration: 0.08).delay(0.14)) {
                PopUpIn = true
            }
            withAnimation(.easeIn(duration: 0.14).delay(0.22)) {
                showPopUpOption = true
            }
            withAnimation(.easeIn(duration: 0.4).delay(0.36)) {
                showItems = true
                completion()
            }
        }
}

struct MoodCheck_Previews: PreviewProvider {
    static var previews: some View {
        MoodCheck(shown: .constant(true), showPopUp: .constant(false), PopUpIn: .constant(false), showPopUpOption: .constant(false), showItems: .constant(false), showRecs: .constant(false))
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
            Mood.getMoodImage(mood: mood)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(5)
                .onTapGesture {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    switch mood {
                    case .angry: Analytics.shared.log(event: .mood_tapped_angry)
                    case .sad: Analytics.shared.log(event: .mood_tapped_sad)
                    case .stressed: Analytics.shared.log(event: .mood_tapped_stress)
                    case .okay: Analytics.shared.log(event: .mood_tapped_okay)
                    case .happy: Analytics.shared.log(event: .mood_tapped_happy)
                    case .none: Analytics.shared.log(event: .mood_tapped_cancel)
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

var selectedMood = Mood.none
struct DoneCancel: View {
    @Binding var showPrompt: Bool
    @Binding var shown: Bool
    var width, height: CGFloat
    var mood: Bool
    var save: () -> ()
    var moodSelected: Mood?
    @Binding var showRecs: Bool

    var body: some View {
        HStack {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                if moodSelected != Mood.none {
                    save()
                    withAnimation {
                        selectedMood = moodSelected ?? Mood.none
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
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
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
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            .frame(width: width * 0.3, height: min(height/6, 40))
            .background(Color.gray)
            .cornerRadius(12)
            .neoShadow()
            .padding()
        }
    }
}

