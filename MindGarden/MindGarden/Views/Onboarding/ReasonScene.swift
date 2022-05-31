//
//  ExperienceScene.swift
//  MindGarden
//
//  Created by Dante Kim on 9/5/21.
//

import SwiftUI
import OneSignal
import Amplitude

//TODO fix navigation bar items not appearing in ios 15 phones
struct ReasonScene: View {
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
                        Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                        VStack {
                            HStack {
                                Img.topBranch.padding(.leading, -20)
                                Spacer()
                            }
                            Text("What brings you to MindGarden?")
                                .font(Font.mada(.bold, size: 24))
                                .foregroundColor(Clr.darkgreen)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.center)
                                .padding(.top, 20)
                                .padding(.horizontal)
                                .frame(height: 50)
                                .padding(.bottom, 30)
                            ForEach(reasonList) { reason in
                                SelectionRow(width: width, height: height, reason: reason, selected: $selected)
                            }
                            Button {
                                Analytics.shared.log(event: .experience_tapped_continue)
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                var arr = [String]()
                                selected.forEach { item in
                                    arr.append(item.title)
                                    OneSignal.sendTag(item.tag, value: "true")
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
                                            viewRouter.currentPage = .name
                                        }
                                    }
                                } //TODO gray out button if not selected
                            } label: {
                                Capsule()
                                    .fill(Clr.darkWhite)
                                    .overlay(
                                        Text("Continue")
                                            .foregroundColor(Clr.darkgreen)
                                            .font(Font.mada(.bold, size: 20))
                                    )
                            }.frame(height: 50)
                                .padding()
                                .buttonStyle(NeumorphicPress())
                            Spacer()
                        }
                }
            }
        }.onDisappear {
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
                        return
                    }
                    
                    if selected.count >= 3 {
                        selected.removeFirst()
                    }
                    
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
                    Rectangle()
                        .fill(selected.contains(where: { $0.id == reason.id }) ? Clr.yellow : Clr.darkWhite)
                        .cornerRadius(15)
                        .frame(height: height * (K.isSmall() ? 0.11 : 0.125))
                        .overlay(RoundedRectangle(cornerRadius: 15)
                                    .stroke(Clr.darkgreen, lineWidth: selected.contains(where: { $0.id == reason.id }) ? 3 : 0))
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    HStack(spacing: 50) {
                        Text(reason.title)
                            .font(Font.mada(.bold, size: K.isSmall() ? 18 : 20))
                            .foregroundColor(selected.contains(where: { $0.id == reason.id }) ? (colorScheme == .dark ? Color.black : Clr.black1 ): Clr.black1)
                            .padding()
                            .frame(width: width * (K.isSmall() ? 0.6 : 0.5), alignment: .leading)
                            .lineLimit(2)
                            .minimumScaleFactor(0.05)
                        reason.img
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: width * 0.15)
                    }
                }
            }.buttonStyle(NeumorphicPress())
        }
    }
}

struct ReasonScene_Previews: PreviewProvider {
    static var previews: some View {
        ExperienceScene()
    }
}
