//
//  SingleDay.swift
//  MindGarden
//
//  Created by Dante Kim on 6/19/21.
//

import SwiftUI
//TODO - fix iphone 8 bug, selectedplant bug.
struct SingleDay: View {
    @EnvironmentObject var gardenModel: GardenViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var meditationModel: MeditationViewModel
    @Binding var showSingleModal: Bool
    @Binding var day: Int
    var month: Int
    var year: Int
    @State var moods: [String]?
    @State var gratitudes: [String]?
    @State var sessions: [[String: String]]?
    @State var totalTime: Int = 0
    @State var totalSessions: Int = 0
    @State var minutesMeditated: Int = 0
    @State var plant: Plant?
    @State var sessionCounter: Int = 0
    @State var isOnboarding = false
    @State var showOnboardingModal = true
    
    init(showSingleModal: Binding<Bool>, day: Binding<Int>, month: Int, year: Int) {
        self._showSingleModal = showSingleModal
        self._day = day
        self.month = month 
        self.year = year
    }

    var body: some View {
        NavigationView {
            GeometryReader { g in
                ZStack {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all)
                    VStack(alignment: .leading) {
                        ZStack {
                            Img.greenBlob
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: g.size
                                        .width/1, height: g.size.height/1.6)
                                .offset(x: g.size.width/6, y: -g.size.height/4)
                            if plant != nil && totalSessions > 1 {
                                HStack {
                                    if sessionCounter - 1 >= 0 {
                                        Button {
                                            Analytics.shared.log(event: .garden_tapped_single_previous_session)
                                            withAnimation {
                                                if sessionCounter > 0 {
                                                    sessionCounter -= 1
                                                    updateSession()
                                                }
                                            }
                                        } label: {
                                            Image(systemName: "chevron.left")
                                                .resizable()
                                                .renderingMode(.template)
                                                .aspectRatio(contentMode: .fit)
                                                .font(Font.title.weight(.bold))
                                                .frame(width: 30)
                                                .foregroundColor(Clr.darkWhite)
                                                .padding()
                                                .offset(y: -25)
                                        }.buttonStyle(NeumorphicPress())
                                    }
                                    Spacer()
                                    plant?.coverImage
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: g.size.width/2.2, height: g.size.height/2)
                                        .offset(y: -35)
                                    Spacer()
                                    if sessionCounter + 1 < totalSessions {
                                        Button {
                                            Analytics.shared.log(event: .garden_tapped_single_next_session)
                                            withAnimation {
                                                if sessionCounter < totalSessions - 1 {
                                                    sessionCounter += 1
                                                    updateSession()
                                                }
                                            }
                                        } label: {
                                            Image(systemName: "chevron.right")
                                                .resizable()
                                                .renderingMode(.template)
                                                .aspectRatio(contentMode: .fit)
                                                .font(Font.title.weight(.bold))
                                                .frame(width: 30)
                                                .foregroundColor(.white)
                                                .padding()
                                                .offset(y: -25)
                                                .shadow(radius: 10)
                                        }
                                    }
                                }
                            } else if plant != nil {
                                plant?.coverImage
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: g.size.width/2.2, height: g.size.height/2)
                                    .offset(y: -35)
                            } else {
                                Text("No sessions for \nthis day :(")
                                    .foregroundColor(Clr.black2)
                                    .font(Font.mada(.bold, size: 30))
                                    .offset(y: -65)
                                    .multilineTextAlignment(.center)
                            }
                        }.padding(.bottom, -95)
                        Text("Stats For the Day: ")
                            .foregroundColor(Clr.black2)
                            .font(Font.mada(.semiBold, size: 26))
                            .padding(.leading, g.size.width * 0.1)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        HStack(spacing: 15) {
                            VStack(spacing: 25) {
                                StatBox(label: "Total Mins", img: Img.iconTotalTime, value: totalTime/60 == 0 && totalTime != 0 ? "0.5" : "\(totalTime/60)")
                                StatBox(label: "Total Sessions", img: Img.iconSessions, value: "\(totalSessions)")
                                ZStack {
                                    Rectangle()
                                        .fill(Clr.darkWhite)
                                        .cornerRadius(15)
                                        .neoShadow()
                                    VStack(spacing: -5) {
                                        Text("Moods:")
                                            .foregroundColor(Clr.black2)
                                            .font(Font.mada(.regular, size: 16))
                                            .padding(5)
                                        HStack(spacing: 0) {
                                            ForEach(self.moods ?? ["none"], id: \.self) { mood in
                                                if mood != "none" {
                                                    Mood.getMoodImage(mood: Mood.getMood(str: mood))
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .padding(5)
                                                }
                                            }
                                        }.frame(height: g.size.height * 0.07)
                                    }.padding(3)
                                }
                                .padding(.trailing, 10)
                            }
                            .frame(maxWidth: g.size.width * 0.38)
                            ZStack {
                                Rectangle()
                                    .fill(Clr.darkWhite)
                                    .cornerRadius(15)
                                    .neoShadow()
                                VStack(spacing: 5){
                                    Text("Gratitude: ")
                                        .foregroundColor(Clr.black2)
                                        .font(Font.mada(.semiBold, size: 16))
                                    ScrollView(showsIndicators: false) {
                                        ForEach(self.gratitudes ?? ["No gratitude written this day"], id: \.self) { gratitude in
                                            Text(gratitude)
                                                .fixedSize(horizontal: false, vertical: true)
                                                .foregroundColor(Clr.black2)
                                                .font(Font.mada(.regular, size: 14))
                                                .padding(10)
                                            Divider()
                                        }
                                    }
                                }.padding(5)
                            }
                        }.frame(maxHeight: g.size.height * 0.40)
                        .padding(.horizontal, g.size.width * 0.1)
                        Spacer()
                    }
                }.navigationBarItems(leading: xButton,
                                     trailing: title)
                if showOnboardingModal {
                    Color.black
                        .opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                    Spacer()
                }
//                OnboardingModal(shown: $showOnboardingModal)
//                    .offset(y: showOnboardingModal ? 0 : g.size.height)
//                    .animation(.default, value: showOnboardingModal)
                BottomSheet(
                    isOpen: self.$showOnboardingModal,
                    maxHeight: g.size.height * (K.isSmall() ? 0.85 : 0.7),
                    minHeight: 0.1
                ) {
                    VStack {
                        Text("🥳")
                            .font(Font.mada(.bold, size: K.isSmall() ? 64 : 80))
                        Text("Tutorial Complete!")
                            .font(Font.mada(.bold, size: 32))
                            .foregroundColor(Clr.darkgreen)
                            .padding(.bottom, -5)
                        Text("Kick start your journey by taking our intro to meditation course")
                            .font(Font.mada(.medium, size: 20))
                            .foregroundColor(Clr.black2)
                            .multilineTextAlignment(.center)
                            .frame(height: 50)
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation {
                                showOnboardingModal = false
                                Analytics.shared.log(event: .onboarding_finished_single_course)
                                UserDefaults.standard.setValue(false, forKey: "introLink")
                                UserDefaults.standard.setValue("done", forKey: K.defaults.onboarding)
                                meditationModel.selectedMeditation = Meditation.allMeditations.first(where: { $0.id == 6 })
                                fromPage = "onboarding"
                                viewRouter.currentPage = .pricing
                            }
                        } label: {
                            Capsule()
                                .fill(Clr.darkgreen)
                                .overlay(
                                    Text("Start Day 1 of Course")
                                        .font(Font.mada(.bold, size: 18))
                                         .foregroundColor(.white)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                )
                                
                        }.buttonStyle(NeumorphicPress())
                         .frame(height: 45)
                         .padding(.top, 35)
                        Text("Not Now")
                            .font(Font.mada(.semiBold, size: 22))
                            .foregroundColor(Color.gray)
                            .underline()
                            .padding(.top, 5)
                            .onTapGesture {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                showOnboardingModal = false
                                fromPage = "profile"
                                viewRouter.currentPage = .pricing
                            }
                    }.frame(width: g.size.width * 0.85, alignment: .center)
                    .padding()
                }.offset(y: g.size.height * 0.1)
            }
        }.onAppear {
            if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "single" {
                isOnboarding = true
                showOnboardingModal = true
            }
            if let moods = gardenModel.grid[String(self.year)]?[String(self.month)]?[String(self.day)]?[K.defaults.moods] as? [String] {
                self.moods = moods
            }
            if let gratitudes = gardenModel.grid[String(self.year)]?[String(self.month)]?[String(self.day)]?[K.defaults.gratitudes] as? [String] {
                self.gratitudes = gratitudes
            }
            if let sessions = gardenModel.grid[String(self.year)]?[String(self.month)]?[String(self.day)]?[K.defaults.sessions] as? [[String: String]] {
                self.sessions = sessions
                self.totalSessions = sessions.count
                for session in sessions {
                    if let duration = session["duration"] {
                        self.totalTime += (Double(duration) ?? 0.0).toInt() ?? 0
                    }
                }
                if let selectedPlant = sessions[sessionCounter][K.defaults.plantSelected] {
                    self.plant = Plant.allPlants.first(where: {$0.title == selectedPlant})
                }
                if let duration = sessions[sessionCounter][K.defaults.duration] {
                    self.minutesMeditated = (Double(duration) ?? 0.0).toInt() ?? 0
                }
            }
        }
    }

    var xButton: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            showSingleModal = false
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 22))
                .foregroundColor(Clr.black1)
        }
    }

    var title: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(Date().getMonthName(month: String(month))) \(day), \(String(year))")
                    .font(Font.mada(.semiBold, size: 26))
                Text("\(plant?.title ?? "" )")
                    .font(Font.mada(.bold, size: 38))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text("Minutes Meditated: \(minutesMeditated/60 == 0 && minutesMeditated != 0 ? "0.5" : "\(minutesMeditated/60)")")
                    .font(Font.mada(.semiBold, size: 18))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            .foregroundColor(.white)
            .frame(height: 80)
            .padding(.top, 60)
        }
    }

    private func updateSession() {
        plant = Plant.allPlants.first(where: { plant in
            return plant.title == sessions?[sessionCounter][K.defaults.plantSelected]
        })
        if let duration = sessions?[sessionCounter][K.defaults.duration] {
            self.minutesMeditated = (Double(duration) ?? 0.0).toInt() ?? 0
        }
    }
}

struct SingleDay_Previews: PreviewProvider {
    static var previews: some View {
        SingleDay(showSingleModal: .constant(true), day: .constant(1), month: 8, year: 2021)
                .navigationViewStyle(StackNavigationViewStyle())
    }
}

