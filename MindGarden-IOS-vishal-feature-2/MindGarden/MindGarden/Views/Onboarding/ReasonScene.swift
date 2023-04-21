//
//  ExperienceScene.swift
//  MindGarden
//
//  Created by Dante Kim on 9/5/21.
//

import Amplitude
import OneSignal
import SwiftUI

var arr = [String]()
// TODO: fix navigation bar items not appearing in ios 15 phones
struct ReasonScene: View {
    var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: 5), count: 2)

    @State var selected: [ReasonItem] = []
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var meditationModel: MeditationViewModel
    @EnvironmentObject var gardenModel: GardenViewModel

    init() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }

    var body: some View {
        VStack {
            GeometryReader { g in
                let width = g.size.width
                let height = g.size.height
                ZStack {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all)
                    VStack {
                        // TOP LEAVES
                        LeavesView()
                        // TITLE
                        Text("What brings you to MindGarden? (up to 3)")
                            .font(Font.fredoka(.bold, size: 28))
                            .foregroundColor(Clr.darkgreen)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 20)
                            .padding(.horizontal)
                            .frame(height: 50)
                            .padding(.bottom, 15)
                        // OPTIONS
                        LazyVGrid(columns: gridItemLayout) {
                            ForEach(reasonList, id: \.self) { reason in
                                SelectionRow(width: width, height: height, reason: reason, selected: $selected)
                            } //: ForEach
                        } //: LazyVGrid
                        .frame(width: width * 0.9)
                        // CONTINUE BUTTON
                        Button {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                MGAudio.sharedInstance.stopSound()
                                MGAudio.sharedInstance.playSound(soundFileName: "waterdrops.mp3")
                            }
                            Analytics.shared.log(event: .reason_tapped_continue)
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            selected.forEach { item in
                                arr.append(item.title)
                                Analytics.shared.log(event: item.event)
                            }
                            let stringRepresentation = arr.joined(separator: " | ")
                            let identify = AMPIdentify()
                                .set("reasons", value: NSString(utf8String: stringRepresentation))
                            Amplitude.instance().identify(identify ?? AMPIdentify())

                            if selected.count > 0 {
                                for reason in selected {
                                    if reason.title == "Sleep better" {
                                        if let oldSegs = UserDefaults.standard.array(forKey: "oldSegments") as? [String] {
                                            var segs = oldSegs
                                            segs.append("sleep 1")
                                            UserDefaults.standard.setValue(segs, forKey: "oldSegments")
                                        }
                                    }
                                }

                                withAnimation(.easeOut(duration: 0.5)) {
                                    DispatchQueue.main.async {
                                        viewRouter.progressValue += 0.1
                                        viewRouter.currentPage = .meditationGoal
                                    }
                                }
                            }
                        } label: {
                            Rectangle()
                                .fill(selected.count > 0 ? Clr.yellow : Clr.yellow.opacity(0.3))
                                .overlay(
                                    Text("Continue 👉")
                                        .foregroundColor(selected.count > 0 ? Clr.darkgreen : Clr.darkgreen.opacity(0.3))
                                        .font(Font.fredoka(.bold, size: 20))
                                )
                                .addBorder(selected.count > 0 ? Color.black : .black.opacity(0.3), width: 1.5, cornerRadius: 24)
                        } //: Button
                        .frame(height: 50)
                        .padding(.top, 30)
                        .padding(.horizontal)
                        .buttonStyle(NeumorphicPress())
                        .disabled(selected.isEmpty)
                    } //: VStack
                    .frame(width: width * 0.9)
                } //: ZStack
            } //: GeometryReader
        } //: VStack
        .onDisappear {
            meditationModel.getFeaturedMeditation()
        }
        .onAppearAnalytics(event: .screen_load_reason)
        .transition(.move(edge: .trailing))
    }

    struct SelectionRow: View {
        var width, height: CGFloat
        @State var reason: ReasonItem
        @Binding var selected: [ReasonItem]
        @Environment(\.colorScheme) var colorScheme

        var body: some View {
            Button {
                if !UserDefaults.standard.bool(forKey: "firstTap") {
//                    switch reason.title {
//                    case "Sleep better", "Get more focused", "Improve your focus", "Improve your mood", "Be more present":
//                        PaywallService.setUser(reasons: "📈 " + reason.title)
//                    case "Managing Stress & Anxiety":
//                        PaywallService.setUser(reasons: "📉 Reduce your stress & anxiety")
//                    default:
//                        PaywallService.setUser(reasons: "📈 Become more mindful in")
//                    }
                    UserDefaults.standard.setValue(reason.title, forKey: "reason1")
                    UserDefaults.standard.setValue(true, forKey: "firstTap")
                }
                MGAudio.sharedInstance.playBubbleSound()
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                withAnimation {
                    if selected.contains(where: { $0.id == reason.id }) {
                        selected.removeAll(where: { $0.id == reason.id })
                        if reason.title == "Sleep better" {
                            if selected.count == 1 {
                                UserDefaults.standard.setValue("Sleep better", forKey: "reason")
                            }
                        } else if reason.title == "Just trying it out" {
                            if selected.count == 1 {
                                UserDefaults.standard.setValue("Just trying it out", forKey: "reason")
                            }
                        }
                        selected = Array(Set(selected))
                        return
                    }

                    if selected.count >= 3 {
                        selected.removeFirst()
                    }

                    selected = Array(Set(selected))
                    selected.append(reason)

                    if reason.title == "Sleep better" {
                        if selected.count == 1 {
                            UserDefaults.standard.setValue("Sleep better", forKey: "reason")
                        }
                    } else if reason.title == "Just trying it out" {
                        if selected.count == 1 {
                            UserDefaults.standard.setValue("Just trying it out", forKey: "reason")
                        }
                    } else {
                        UserDefaults.standard.setValue(reason.title, forKey: "reason")
                    }
                }
            } label: {
                ZStack {
                    // BACKGROUND COLOR
                    Rectangle()
                        .fill(selected.contains(where: { $0.id == reason.id }) ? Clr.brightGreen : Clr.darkWhite)
                    VStack(spacing: -10) {
                        // TITLE
                        Text(reason.title)
                            .font(Font.fredoka(.semiBold, size: K.isSmall() ? 16 : 20))
                            .foregroundColor(selected.contains(where: { $0.id == reason.id }) ? .white : Clr.black2)
                            .padding(.horizontal)
                            .frame(width: width * 0.375, height: height * 0.085, alignment: .top)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                        // IMAGE
                        reason.img
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: width * 0.18, alignment: .top)
                    } //: VStack
                    .padding()
                } //: ZStack
                .frame(width: width * 0.4, height: height * (K.isSmall() ? 0.18 : 0.185))
                .cornerRadius(20)
                .addBorder(.black, width: 1.5, cornerRadius: 20)
                .padding(.horizontal)
                .padding(.vertical, 8)
            } //: Button
            .buttonStyle(NeumorphicPress())
        }
    }
}

enum Reason {
    case morePresent, focus, reduceStress, tryingItOut, improveMood, sleep

    var title: String {
        switch self {
        case .morePresent: return "Be more present"
        case .improveMood: return "Improve your mood"
        case .focus: return "Improve your focus"
        case .reduceStress: return "Reduce stress & anxiety"
        case .sleep: return "Sleep better"
        case .tryingItOut: return "Just trying it out"
        }
    }
}

#if DEBUG
struct ReasonScene_Previews: PreviewProvider {
    static var previews: some View {
        ExperienceScene()
    }
}
#endif
