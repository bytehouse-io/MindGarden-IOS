//
//  MoodCheck.swift
//  MindGarden
//
//  Created by Dante Kim on 6/29/21.
//

import SwiftUI
import Amplitude


enum Mood: String, CaseIterable {
    var options: [String] {
    switch self {
        case .veryGood: return ["😃 Excited", "😊 happy", "🎨 Inspired",  "💪 Confident", "🌱 Hopeful", "💚 Loved", "👏 Proud", "🙏 Grateful",  "☀️ Joyful"]
        case .good: return ["🌱 Hopeful", "😌 Calm",  "🙂 Good",  "🏃 Busy", "😃 Excited", "✊ Fulfilled", "🙏 Grateful", "😊 happy", "🎨 Inspired"]
        case .okay: return ["😐 Fine", "🥱 Bored", "🙃 Unsure", "🏃 Busy", "😌 Calm", "🤨 Confused", "😠 Frustrated", "😴 Tired", "✈️ Distant"]
        case .bad: return ["😰 anxious", "😩 stressed", "🏎️ Impatient", "😤 Frustrated", "😒 annoyed", "😴 Tired", "😟 Nervous", "😨 Scared", "😓 Insecure", "🥲 Sad", "🥱 Bored", "😞 Disappointed"]
        case .veryBad: return ["😰 anxious", "😩 stressed", "😡 Angry",  "😨 Scared", "😢 Depressed", "😓 Judged", "😖 Disrespected", "😞 Disappointed", "💔 Hurt", "🤢 Sick", "😭 Grief"]
        default: return [""]
        }
    }
    
    static func allMoodCases() -> [Mood] {
        return [veryBad, bad, okay, good,veryGood]
    }

    case happy
    case okay
    case sad
    case angry
    case stressed
    case veryGood
    case good
    case bad
    case veryBad
    case none

    var id: String { return self.rawValue }
    
    var title: String {
        switch self {
        case .happy: return "happy"
        case .okay: return "okay"
        case .sad: return "sad"
        case .angry: return "angry"
        case .stressed: return "stressed"
        case .veryGood: return "very good"
        case .good: return "good"
        case .bad: return "bad"
        case .veryBad: return "very bad"
        case .none: return "none"
        }
    }

    static func getMood(str: String) -> Mood {
        switch str {
        case "happy": return .happy
        case "okay": return .okay
        case "sad":  return .sad
        case "angry": return .angry
        case "stressed":  return .stressed
        case "very good": return .veryGood
        case "good": return .good
        case "bad": return .bad
        case "very bad": return .veryBad
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
        case .veryGood: return Clr.veryGood
        case .good: return Clr.good
        case .bad: return Clr.bad
        case .veryBad: return Clr.veryBad
        case .none: return Clr.dirtBrown
        }
    }
    static func getMoodImage(mood: Mood) -> Image {
        switch mood {
        case .happy:
            return Image("happyPot")
        case .sad:
            return Image("sadPot")
        case .angry:
            return Image("angryPot")
        case .okay:
            return Image("okay")
        case .stressed:
            return Image("stressedPot")
        case .bad: return Image("bad")
        case .veryBad: return Image("veryBad")
        case .good: return Image("good")
        case .veryGood: return Image("veryGood")
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
    @EnvironmentObject var userModel: UserViewModel

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
                        HStack {
                            Text("\(Date().toString(withFormat: "EEEE, MMM dd"))")
                                .font(Font.fredoka(.medium, size: 20))
                                .foregroundColor(Clr.black2)
                                .padding(.top, 35)
                            Spacer()
                            Image(systemName: "xmark")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(Clr.black1)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 12, height:12)
                                .background(
                                    Rectangle()
                                        .fill(Clr.darkWhite)
                                        .frame(width:30,height:30)
                                        .cornerRadius(17)
                                        .neoShadow()
                                ).onTapGesture {
                                    withAnimation { shown.toggle() }
                                }.offset(x: -5, y: 5)
                        }.frame(width: g.size.width * 0.85, alignment: .leading)
     
                        Text("How are you feeling right now?")
                            .font(Font.fredoka(.semiBold, size: K.isPad() ? 40 : 28))
                            .foregroundColor(Clr.brightGreen)
                            .frame(width: g.size.width * 0.85, alignment: .leading)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .padding(.bottom, 15)
//                        if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "done" {
//                            HStack {
//                                Text("Recommendations ")
//                                        .font(Font.fredoka(.semiBold, size: K.isPad() ? 36 : 20))
//                                        .foregroundColor(Clr.black1)
//                                        .lineLimit(1)
//                                        .minimumScaleFactor(0.5)
//                                Toggle("", isOn: $notifOn)
//                                    .onChange(of: notifOn) { val in
//                                        UserDefaults.standard.setValue(val, forKey: "moodRecsToggle")
//                                        if val {
//                                            Analytics.shared.log(event: .mood_toggle_recs_on)
//                                        } else { //turned off
//                                            Analytics.shared.log(event: .mood_toggle_recs_off)
//                                        }
//                                    }.toggleStyle(SwitchToggleStyle(tint: Clr.gardenGreen))
//                                    .frame(width: g.size.width * 0.08, height: 10)
//                            } .frame(width: g.size.width * 0.8, alignment: .center)
//                        }
                    
                    ZStack(alignment: .center) {
                        Rectangle()
                            .fill(Clr.yellow)
                            .addBorder(Color.black, width: 1.5, cornerRadius: 14)
                            .neoShadow()
                        HStack {
                            SingleMood(moodSelected: $moodSelected, mood: .veryBad, save: save)
                            SingleMood(moodSelected: $moodSelected, mood: .bad, save: save)
                            SingleMood(moodSelected: $moodSelected, mood: .okay, save: save)
                            SingleMood(moodSelected: $moodSelected, mood: .good, save: save)
                            SingleMood(moodSelected: $moodSelected, mood: .veryGood, save: save)
                        }.padding(.horizontal, 10)
                    }.frame(width: g.size.width * 0.9, height: g.size.height/(K.isPad() ? 3.5 : 3.5), alignment: .center)
                        Spacer()
                        if K.isPad() {
                            Spacer()
                        }
                    }
                    Spacer()
                    Spacer()
                }
        }.onAppear {
            notifOn = UserDefaults.standard.bool(forKey: "moodRecsToggle")
        }
    }

    ///Ashvin : Show popup with animation method
    func save() {
        var num = UserDefaults.standard.integer(forKey: "numMoods")
        num += 1
        UserDefaults.standard.setValue(num, forKey: "numMoods")
        let identify = AMPIdentify()
            .set("num_moods", value: NSNumber(value: num))
        Amplitude.instance().identify(identify ?? AMPIdentify())
        if moodSelected != .none {
            Analytics.shared.log(event: .mood_tapped_done)
            if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "signedUp" {
                UserDefaults.standard.setValue("mood", forKey: K.defaults.onboarding)
                showPopupWithAnimation {}
            }
            var moodSession = [String: String]()
            moodSession["timeStamp"] = Date.getTime()
            moodSession["mood"] = moodSelected.title
            
            gardenModel.save(key: "moods", saveValue: moodSession, coins: userModel.coins)
        }
        withAnimation {
            shown = false
        }
    }

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
    var save: () -> ()

    var body: some View {
        ZStack {
            VStack(spacing: 2) {
                Button {
                    print("jermain")
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    switch mood {
                    case .angry: Analytics.shared.log(event: .mood_tapped_angry)
                    case .sad: Analytics.shared.log(event: .mood_tapped_sad)
                    case .stressed: Analytics.shared.log(event: .mood_tapped_stress)
                    case .okay: Analytics.shared.log(event: .mood_tapped_okay)
                    case .happy: Analytics.shared.log(event: .mood_tapped_happy)
                    case .bad: Analytics.shared.log(event: .mood_tapped_bad)
                    case .veryBad: Analytics.shared.log(event: .mood_tapped_veryBad)
                    case .good: Analytics.shared.log(event: .mood_tapped_good)
                    case .veryGood: Analytics.shared.log(event: .mood_tapped_veryGood)
                    case .none: Analytics.shared.log(event: .mood_tapped_cancel)
                    }
                    if moodSelected == mood {
                        moodSelected = .none
                    } else {
                        moodSelected = mood
                    }
                    save()
                    moodSelected = .none
                } label: {
                    Mood.getMoodImage(mood: mood)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(5)
                        .opacity(moodSelected == mood ? 0.3 : 1)
                }
//                Text(mood.title)
//                    .font(Font.fredoka(.semiBold, size: 14))
//                    .foregroundColor(.gray)
//                    .minimumScaleFactor(0.05)
//                    .lineLimit(1)
            }
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
    @Binding var showRecs: Bool

    var body: some View {
        HStack {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                if moodSelected != Mood.none {
                    save()
                    withAnimation {
//                        selectedMood = moodSelected ?? Mood.none
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        showPrompt = false
                        shown = false
                    }
                }
            } label: {
                Text("Done")
                    .foregroundColor(.white)
                    .font(Font.fredoka(.semiBold, size: 20))
            }
            .frame(width:  width * 0.3, height: min(height/6, 40))
            .background(Clr.brightGreen)
            .cornerRadius(12)
            .neoShadow()
            .padding()
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "done" {
                    withAnimation {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        showPrompt = false
                        shown = false
                    }
                }
            } label: {
                Text("Cancel")
                    .foregroundColor(.white)
                    .font(Font.fredoka(.semiBold, size: 20))
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

