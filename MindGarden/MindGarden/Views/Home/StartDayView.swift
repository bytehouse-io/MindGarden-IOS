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
}

struct DailyMoodItem : Identifiable {
    var id = UUID()
    var title: String
    var dailyMood: Image
}
struct StartDayView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    @Binding var activeSheet: Sheet?
    @State private var isDailyMood = true
    
    @State var streakList:[StreakItem] = [StreakItem(title: "S", streak: false),
                                          StreakItem(title: "M", streak: false),
                                          StreakItem(title: "T", streak: false),
                                          StreakItem(title: "W", streak: true),
                                          StreakItem(title: "T", streak: true),
                                          StreakItem(title: "F", streak: false),
                                          StreakItem(title: "S", streak: false)]
    
    @State var dailyMoodList:[DailyMoodItem] = [DailyMoodItem(title: "S", dailyMood: Img.emptyMood),
                                             DailyMoodItem(title: "M", dailyMood: Img.emptyMood),
                                             DailyMoodItem(title: "T", dailyMood: Img.emptyMood),
                                             DailyMoodItem(title: "W", dailyMood: Mood.getMoodImage(mood: .veryBad)),
                                                DailyMoodItem(title: "T", dailyMood: Mood.getMoodImage(mood: .veryGood)),
                                             DailyMoodItem(title: "F", dailyMood: Img.emptyMood),
                                             DailyMoodItem(title: "S", dailyMood: Img.emptyMood)]
    var body: some View {
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
                        .fill(Clr.brightGreen)
                        .frame(width:24,height: 24)
                        .addBorder(Color.black.opacity(0.2), width: 1.5, cornerRadius: 14)
                    DottedLine()
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [10]))
                        .opacity(0.5)
                        .frame(width:2)
                    Circle()
                        .fill(.white)
                        .frame(width:24,height: 24)
                        .addBorder(Color.black.opacity(0.2), width: 1.5, cornerRadius: 16)
                    DottedLine()
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [10]))
                        .opacity(0.5)
                        .frame(width:2)
                    Circle()
                        .fill(.white)
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
                    
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        withAnimation {
                            viewRouter.currentPage = .journal
                        }
                    } label: {
                        ZStack {
                            Rectangle().fill(Clr.yellow)
                            VStack {
                                HStack(spacing:0) {
                                    Spacer()
                                    Text("Answer today’s Journal Prompt")
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
                                                Button {
                                                } label: {
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
                    }.buttonStyle(ScalePress() )
                  
                    ZStack {
                        Rectangle().fill(Clr.yellow)
                            .frame(height:150)
                            .addBorder(Color.black, width: 1.5, cornerRadius: 14)
                    }.frame(width: UIScreen.screenWidth * 0.775)
                }
            }
        }
        .padding(.horizontal, 26)
        .onAppear() {
            if let moods = gardenModel.grid[Date().get(.year)]?[Date().get(.month)]?[Date().get(.day)]?["moods"]  as? [[String: String]] {
                if let mood = moods[moods.count - 1]["mood"], !mood.isEmpty {
                    isDailyMood = false
                    getMoods()
                }
            }
        }
    }
    private func getMoods() {
        let weekDays = getAllDaysOfTheCurrentWeek()
        for i in 0..<weekDays.count {
            let day = weekDays[i]
            if let moods = gardenModel.grid[day.get(.year)]?[day.get(.month)]?[day.get(.day)]?["moods"]  as? [[String: String]] {
                let mood = Mood.getMood(str: moods[moods.count - 1]["mood"] ?? "okay")
                dailyMoodList[i].dailyMood = Mood.getMoodImage(mood: mood)
            }
        }
    }
    
    private func getAllDaysOfTheCurrentWeek() -> [Date] {
        var dates: [Date] = []
        guard let dateInterval = Calendar.current.dateInterval(of: .weekOfYear,
                                                               for: Date()) else {
            return dates
        }
        
        Calendar.current.enumerateDates(startingAfter: dateInterval.start,
                                        matching: DateComponents(hour:0),
                                        matchingPolicy: .nextTime) { date, _, stop in
                guard let date = date else {
                    return
                }
                if date <= dateInterval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
        }
        
        return dates
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
                }
                .padding(10)
                .padding(.vertical, 10)
            }.background(Clr.darkWhite.addBorder(Color.black, width: 1.5, cornerRadius: 8))
        }
    }
}
