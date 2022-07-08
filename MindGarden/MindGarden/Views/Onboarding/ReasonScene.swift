//
//  ExperienceScene.swift
//  MindGarden
//
//  Created by Dante Kim on 9/5/21.
//

import SwiftUI
import OneSignal
import Amplitude

var arr = [String]()
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
                                Img.topBranch
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: UIScreen.screenWidth * 0.6)
                                    .padding(.leading, -20)
                                    .offset(x: -20, y: -35)
                                Spacer()
                            }
                            Text("What brings you to MindGarden?")
                                .font(Font.fredoka(.bold, size: 28))
                                .foregroundColor(Clr.darkgreen)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.center)
                                .padding(.vertical, 20)
                                .padding(.horizontal)
                                .frame(height: 50)
                            ForEach(reasonList) { reason in
                                SelectionRow(width: width, height: height, reason: reason, selected: $selected)
                            }
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
                                            viewRouter.progressValue += 0.2
                                            viewRouter.currentPage = .name
                                        }
                                    }
                                } //TODO gray out button if not selected
                            } label: {
                                Rectangle()
                                    .fill(Clr.yellow)
                                    .overlay(
                                        Text("Continue 👉")
                                            .foregroundColor(Clr.darkgreen)
                                            .font(Font.fredoka(.bold, size: 20))
                                    ).addBorder(Color.black, width: 1.5, cornerRadius: 24)
                            }.frame( height: 50)
                                .padding(.top, 30)
                                .buttonStyle(NeumorphicPress())
                                .padding(.horizontal)
                        }.frame(width: width * 0.9)
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
                    Rectangle()
                        .fill(selected.contains(where: { $0.id == reason.id }) ? Clr.brightGreen : Clr.darkWhite)
                        .cornerRadius(20)
                        .frame(height: height * (K.isSmall() ? 0.11 : 0.125))
                        .addBorder(.black, width: 1.5, cornerRadius: 20)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    HStack(spacing: 50) {
                        Text(reason.title)
                            .font(Font.fredoka(.semiBold, size: K.isSmall() ? 18 : 20))
                            .foregroundColor(selected.contains(where: { $0.id == reason.id }) ? .white : Clr.black2)
                            .padding()
                            .frame(width: width * (K.isSmall() ? 0.6 : 0.5), alignment: .leading)
                            .lineLimit(2)
                            .minimumScaleFactor(0.05)
                        reason.img
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: width * 0.15)
                            .offset(x: -20)
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
