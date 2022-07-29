//
//  StartDayView.swift
//  MindGarden
//
//  Created by Vishal Davara on 04/07/22.
//

import SwiftUI

struct StreakItem : Identifiable {
    var id = UUID()
    var title: String
    var streak: Bool
    var gratitude: String = ""
    var question: String = ""
}

struct DailyMoodItem : Identifiable {
    var id = UUID()
    var title: String
    var dailyMood: Image
}
struct StartDayView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var medModel: MeditationViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    @State private var isDailyMood = true
    @State private var isGratitudeDone = false
    @State private var playEntryAnimation = false
    @State private var isWeekStreakDone = false
    @State var streakList:[StreakItem] = [StreakItem(title: "S", streak: false),
                                          StreakItem(title: "M", streak: false),
                                          StreakItem(title: "T", streak: false),
                                          StreakItem(title: "W", streak: false),
                                          StreakItem(title: "T", streak: false),
                                          StreakItem(title: "F", streak: false),
                                          StreakItem(title: "S", streak: false)]
    
    @State var dailyMoodList:[DailyMoodItem] = [DailyMoodItem(title: "S", dailyMood: Img.emptyMood),
                                             DailyMoodItem(title: "M", dailyMood: Img.emptyMood),
                                             DailyMoodItem(title: "T", dailyMood: Img.emptyMood),
                                             DailyMoodItem(title: "W", dailyMood: Img.emptyMood),
                                                DailyMoodItem(title: "T", dailyMood: Img.emptyMood),
                                             DailyMoodItem(title: "F", dailyMood: Img.emptyMood),
                                             DailyMoodItem(title: "S", dailyMood: Img.emptyMood)]
    var body: some View {
        let width = UIScreen.screenWidth
        let height = UIScreen.screenHeight
        VStack {
            HStack {
                Text("Start your day")
                    .foregroundColor(Clr.brightGreen)
                    .font(Font.fredoka(.semiBold, size: 20))
                    .padding(.top,5)
                Spacer()
            }
            
            HStack {
                VStack {
                    Circle()
                        .fill(isDailyMood ? .clear : Clr.brightGreen)
                        .frame(width:24,height: 24)
                        .addBorder(Color.black.opacity(0.2), width: 1.5, cornerRadius: 14)
                    DottedLine()
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [10]))
                        .fill(isDailyMood ? Clr.black2 : Clr.brightGreen)
                        .opacity(0.5)
                        .frame(width:2)
                    Circle()
                        .fill(isGratitudeDone ? Clr.brightGreen : .clear )
                        .frame(width:24,height: 24)
                        .addBorder(Color.black.opacity(0.2), width: 1.5, cornerRadius: 16)
                    DottedLine()
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [10]))
                        .fill(isGratitudeDone ? Clr.brightGreen : Clr.black2 )
                        .opacity(0.5)
                        .frame(width:2)
                    Circle()
                        .fill(updatedStreak ? Clr.brightGreen : .clear )
                        .frame(width:24,height: 24)
                        .addBorder(Color.black.opacity(0.2), width: 1.5, cornerRadius: 16)
                }.padding(.vertical,50)
                VStack(spacing:30) {
                    ZStack {
                        Img.whiteClouds
                            .resizable()
                            .frame(height:170)
                            .aspectRatio(contentMode: .fill)
                            .opacity(0.95)
                        if isDailyMood {
                            SelectMood
                        } else {
                            DailyMood
                        }
                    }
                    .frame(width: UIScreen.screenWidth * 0.775)
                    .addBorder(Color.black, width: 1.5, cornerRadius: 16)
                    .padding(.horizontal, 12)
                    .shadow(color: .black.opacity(0.25), radius: 1, x:  3 , y: 3)
                    .opacity(isDailyMood ? 1 : 0.5)
                    .offset(y: playEntryAnimation ? 0 : 100)
                    .opacity(playEntryAnimation ? 1 : 0)
                    .animation(.spring().delay(0.3), value: playEntryAnimation)
                 
                    
                    Button {

                    } label: {
                        ZStack {
                            Rectangle().fill(Clr.yellow)
                            VStack {
                                HStack(spacing:0) {
                                    Spacer()
                                    Text(isWeekStreakDone ? "Wow! Perfect this week!" : "Answer today’s Journal Prompt")
                                        .foregroundColor(Clr.black2)
                                        .font(Font.fredoka(.semiBold, size: 20))
                                        .padding([.leading, .top],16)
                                    Spacer()
                                    Img.streakViewPencil
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxHeight: 45)
                                        .offset(x: 3, y: -15)
                                    Img.streakViewPencil1
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxHeight: 70)
                                }
                                Spacer()
                                VStack {
                                    HStack(alignment:.top) {
                                        ForEach(streakList, id: \.id) { item in
                                            VStack(spacing:5) {
                                                Text(item.title)
                                                    .foregroundColor(Clr.black2)
                                                    .font(Font.fredoka(.semiBold, size: 12))
                                                VStack(spacing:0) {
                                                    if item.streak {
                                                        Img.streakPencil
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(height: 35)
                                                    } else {
                                                        Img.streakPencilUnselected
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(height: 35)
                                                    }
                                                }
                                            
                                            }
                                            .padding(.horizontal,3)
                                            .frame(maxWidth:.infinity)
                                        }
                                    }
                                    .padding(10)
                                }
                                .frame(height: 85)
                                .background(Clr.darkWhite.addBorder(Color.black, width: 1.5, cornerRadius: 16))
                            }
                            HStack {
                                Img.streakCutPencil
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxHeight:70)
                                Spacer()
                            }
                            .offset(y:-15)
                        }.frame(width: UIScreen.screenWidth * 0.775, height: 175)
                            .addBorder(Color.black, width: 1.5, cornerRadius: 16)
                            .padding(.horizontal, 12)
                            .offset(y: playEntryAnimation ? 0 : 100)
                            .opacity(playEntryAnimation ? 1 : 0)
                            .animation(.spring().delay(0.275), value: playEntryAnimation)
                            .onTapGesture {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                                    viewRouter.currentPage = .journal
                                }
                            }
                    }.buttonStyle(ScalePress() )
                  
                    ZStack {
                        VStack(spacing:5) {
                            HStack(spacing: 15) {
                                Button {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    withAnimation {
                                        medModel.selectedBreath = medModel.featuredBreathwork
                                        viewRouter.currentPage = .breathMiddle
                                    }
                                } label: {
                                    HomeSquare(width: width - 50, height: height * 0.7, meditation: Meditation.allMeditations.first(where: { $0.id == 67 }) ?? Meditation.allMeditations[0], breathwork: medModel.featuredBreathwork)
                                        .offset(y: playEntryAnimation ? 0 : 100)
                                        .opacity(playEntryAnimation ? 1 : 0)
                                        .animation(.spring().delay(0.3), value: playEntryAnimation)
                                }.buttonStyle(ScalePress())
                                    Button {
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        Analytics.shared.log(event: .home_tapped_featured)
                                        withAnimation {
                                            medModel.selectedMeditation = medModel.featuredMeditation
                                            if medModel.featuredMeditation?.type == .course {
                                                viewRouter.currentPage = .middle
                                            } else {
                                                viewRouter.currentPage = .play
                                            }
                                        }
                                    } label: {
                                        HomeSquare(width: width - 50, height: height * 0.7, meditation: medModel.featuredMeditation ?? Meditation.allMeditations[0], breathwork: nil)
                                            .offset(y: playEntryAnimation ? 0 : 100)
                                            .opacity(playEntryAnimation ? 1 : 0)
                                            .animation(.spring().delay(0.3), value: playEntryAnimation)
                                    }.buttonStyle(ScalePress())
                                
//                                Button {
//                                } label: {
//                                    Clr.yellow.addBorder(Color.black, width: 1.5, cornerRadius: 20)
//                                }
//                                .padding(.vertical,5)
//                                .buttonStyle(BonusPress())
//                                .frame(width:30)
//                                .overlay(
//                                    HStack {
//                                        Text("Discover")
//                                            .foregroundColor(Clr.black2)
//                                            .font(Font.fredoka(.semiBold, size: 16))
//                                            .lineLimit(1)
//                                            .frame(width:75)
//                                        Image(systemName: "arrow.up")
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fit)
//                                            .frame(width:12)
//                                    }
//                                        .rotationEffect(Angle(degrees: 90))
//                                )
                            }
                            HStack {
                                Spacer()
                                Text("Breathwork")
                                    .foregroundColor(Clr.black2)
                                    .font(Font.fredoka(.regular, size: 16))
                                Spacer()
                                Text("OR")
                                    .foregroundColor(Clr.black2)
                                    .font(Font.fredoka(.medium, size: 16))
                                Spacer()
                                Text("Meditation")
                                    .foregroundColor(Clr.black2)
                                    .font(Font.fredoka(.regular, size: 16))
                                Spacer()
                            }.offset(x: -5)
                            .padding(.top, 10)
                        }
                    }
                    .frame(width: UIScreen.screenWidth * 0.775)
                    .offset(y: playEntryAnimation ? 0 : 100)
                    .opacity(playEntryAnimation ? 1 : 0)
                    .animation(.spring().delay(0.3), value: playEntryAnimation)
                }
            }
        }
        .padding(.horizontal, 26)
        .onAppear() {
      
            
            DispatchQueue.main.async {
                let weekDays = getAllDaysOfTheCurrentWeek()
                getAllGratitude(weekDays:weekDays)
                if let moods = gardenModel.grid[Date().get(.year)]?[Date().get(.month)]?[Date().get(.day)]?["moods"]  as? [[String: String]] {
                    if let mood = moods[moods.count - 1]["mood"], !mood.isEmpty {
                        isDailyMood = false
                        getMoods(weekDays:weekDays)
                    }
                }
                
                if let gratitudes = gardenModel.grid[Date().get(.year)]?[Date().get(.month)]?[Date().get(.day)]?[K.defaults.journals]  as? [[String: String]] {
                    if let gratitude = gratitudes[gratitudes.count-1]["gratitude"], !gratitude.isEmpty  {
                        isGratitudeDone = true
                    }
                }
                withAnimation {
                    playEntryAnimation = true
                }
            }
        }
    }
    
    private func getAllGratitude(weekDays:[Date]) {
        for i in 0..<weekDays.count {
            let day = weekDays[i]
            if let gratitudes = gardenModel.grid[day.get(.year)]?[day.get(.month)]?[day.get(.day)]?[K.defaults.journals]  as? [[String: String]] {
                if let gratitude = gratitudes[gratitudes.count-1]["gratitude"] {
                    streakList[i].gratitude = gratitude
                    if gratitude.count > 0 {
                        streakList[i].streak = true
                    }
                }
                if let question = gratitudes[gratitudes.count-1]["question"] {
                    streakList[i].question = question
                }
            }
        }
        isWeekStreakDone = streakList.filter { !$0.streak }.count == 7
    }
    
    private func getMoods(weekDays:[Date]) {
        for i in 0..<weekDays.count {
            let day = weekDays[i]
            if let moods = gardenModel.grid[day.get(.year)]?[day.get(.month)]?[day.get(.day)]?["moods"]  as? [[String: String]] {
                let mood = Mood.getMood(str: moods[moods.count - 1]["mood"] ?? "okay")
                dailyMoodList[i].dailyMood = Mood.getMoodImage(mood: mood)
            }
        }
    }
    
    private func getAllDaysOfTheCurrentWeek() -> [Date] {
        var calendar = Calendar.autoupdatingCurrent
        calendar.firstWeekday = 1
        let today = calendar.startOfDay(for: Date())
        var week = [Date]()
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) {
            for i in 0...6 {
                if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    week += [day]
                }
            }
        }
        return week
    }
    
    var SelectMood: some View {
        VStack {
            Spacer()
            VStack {
                Text("How are you feeling?")
                    .foregroundColor(Clr.brightGreen)
                    .font(Font.fredoka(.semiBold, size: 16))
                    .offset(y: 8)
                HStack(alignment:.top) {
                    ForEach(Mood.allMoodCases(), id: \.id) { item in
                        Button {
                            withAnimation {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                userModel.selectedMood = item
                                viewRouter.currentPage = .mood
                            }
                        } label: {
                            VStack(spacing:0) {
                                Mood.getMoodImage(mood: item)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 70)
                                    .padding(.horizontal, 4)
                                    .padding(.bottom, 8)
                            }
                        }
                    }
                }.padding(10)
            }.background(Clr.darkWhite.addBorder(Color.black, width: 1.5, cornerRadius: 8))
        }
    }
    
    var DailyMood: some View {
        VStack {
            Spacer()
            VStack {
//                Text("👍 Daily Mood Log Complete")
//                    .foregroundColor(Clr.brightGreen)
//                    .font(Font.fredoka(.semiBold, size: 16))
//                    .offset(y: 8)
                HStack(alignment:.top) {
                    ForEach(dailyMoodList, id: \.id) { item in
                        VStack(spacing:5) {
                            Text(item.title)
                                .foregroundColor(Clr.black2)
                                .font(Font.fredoka(.semiBold, size: 12))
                                .padding(.bottom, 4)
                            VStack(spacing:0) {
                                item.dailyMood
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                        .padding(.horizontal,2)
                        .frame(maxWidth:.infinity)
                    }
                }.padding(10)
                .padding(.vertical, 10)
            }.background(Clr.darkWhite.addBorder(Color.black, width: 1.5, cornerRadius: 8))
   
        }
    }
}


struct HomeMeditationRow: View {
    
    @State var title:String
    
    var body: some View {
        ZStack(alignment:.top) {
            Rectangle()
                .fill(Clr.darkWhite)
                .padding(.vertical,10)
                .addBorder(Color.black, width: 1.5, cornerRadius: 14)
                .background(Clr.darkWhite.cornerRadius(14).neoShadow())
                
            VStack(spacing:0) {
                HStack {
                    Text(title)
                        .font(Font.fredoka(.medium, size: 16))
                        .foregroundColor(Clr.black2)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                
                HStack(spacing:0) {
                    VStack(alignment:.leading,spacing:3) {
                        HStack {
                            Image(systemName: "speaker.wave.3.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height:8)
                                .padding(.vertical,0)
                            Text("Meditation")
                                .font(
                                    .fredoka(.medium, size: 10))
                                .foregroundColor(Clr.black2.opacity(0.5))
                                .padding(.vertical,0)
                        }.padding(.vertical,0)
                        HStack {
                            Image(systemName: "timer")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height:8)
                                .padding(.vertical,0)
                            Text("10 mins")
                                .font(Font.fredoka(.medium, size: 10))
                                .foregroundColor(Clr.black2.opacity(0.5))
                                .padding(.vertical,0)
                        }.padding(.vertical,0)
                        HStack {
                            Image(systemName: "person.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height:8)
                                .padding(.vertical,0)
                            Text("Bijan")
                                .font(Font.fredoka(.medium, size: 10))
                                .foregroundColor(Clr.black2.opacity(0.5))
                                .padding(.vertical,0)
                        }.padding(.vertical,0)
                    }
                    Img.happySunflower
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 50)
                }
                
            }
            .padding(10)
        }
    }
}
