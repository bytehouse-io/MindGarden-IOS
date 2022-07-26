//
//  Garden.swift
//  MindGarden
//
//  Created by Dante Kim on 6/19/21.
//

import SwiftUI


var gardenSettings = false

struct Garden: View {
    @EnvironmentObject var gardenModel: GardenViewModel
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var isMonth: Bool = true
    @State private var showSingleModal = false
    @State private var day: Int = 0
    @State private var topThreePlants: [FavoritePlant] = [FavoritePlant]()
    @State private var isOnboarding = false
    @State private var tileOpacity = 1.0
    @State private var gotItOpacity = 1.0
    @State private var forceRefresh = false
    @State private var color = Clr.yellow
    @Environment(\.sizeCategory) var sizeCategory
    @State var activeSheet: Sheet?
    
    @EnvironmentObject var bonusModel: BonusViewModel
    @Environment(\.colorScheme) var colorScheme
    var currentStreak : String {
        return "\(bonusModel.streakNumber)"
    }
    
    var longestStreak : Int {
        (UserDefaults.standard.value(forKey: "longestStreak")) as? Int ?? 1
    }
    @State private var playEntryAnimation = false
    private let animation = Animation.interpolatingSpring(stiffness: 50, damping: 26)
    
    var body: some View {
        GeometryReader { gp in
            ScrollView(showsIndicators: false) {
                ZStack {
                    VStack(alignment: .center, spacing: 20) {
                        //Version 2
                        //                    HStack(spacing: 40) {
                        //                        Button {
                        //                            isMonth = true
                        //                        } label: {
                        //                            MenuButton(title: "Month", isMonth: isMonth)
                        //                        }
                        //                        Button {
                        //                            isMonth = false
                        //                        } label: {
                        //                            MenuButton(title: "Year", isMonth: !isMonth)
                        //                        }
                        //                    }
                        HStack {
                            Text("👨‍🌾 Your MindGarden")
                                .font(Font.fredoka(.semiBold, size: 22))
                                .foregroundColor(Clr.brightGreen)
                                .padding()
                                .lineLimit(1)
                                .minimumScaleFactor(0.05)
                            Spacer()
                            HStack {
                                Button {
                                    Analytics.shared.log(event: .garden_tapped_plant_select)
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
//                                    showPlant = true
                                    activeSheet = .plant
                                } label: {
                                    HStack {
                                        userModel.selectedPlant?.head
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    }
                                    .frame(height: 25)
                                }
                                Image(systemName: "gearshape.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(Clr.brightGreen)
                                    .frame(height: 25)
                                    .onTapGesture {
                                        Analytics.shared.log(event: .garden_tapped_settings)
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        gardenSettings = true
                                        activeSheet = .profile
                                    }
                            }
                        }.frame(width: gp.size.width * 0.85)
                        .padding(.bottom, -10)
                        .offset(x: -10)
                        

                        Text("Calendar/Garden")
                            .foregroundColor(Clr.black2)
                            .font(Font.fredoka(.semiBold, size: forceRefresh ? 20 : 20.1))
                            .offset(x: UIScreen.screenWidth * -0.25 + 10, y: playEntryAnimation ? 10 : 400)
                            .animation(animation.delay(0.4), value: playEntryAnimation)
                        ZStack(alignment: .center) {
                            Rectangle()
                                .fill(Clr.darkWhite)
//                                .addBorder(Clr.brightGreen, width: 1.5, cornerRadius: 20)
                            VStack(spacing:0) {
                                GridStack(rows: Date.needsExtraRow(month: gardenModel.selectedMonth, year: gardenModel.selectedYear) ? 6 : 5, columns: 7) { row, col in
                                    ZStack {
                                        let c = gardenModel.placeHolders
                                        let currentDate = col + (row * 7) + 1 - c
                                        let maxDate = Date().getNumberOfDays(month: String(gardenModel.selectedMonth),year:String(gardenModel.selectedYear))
                                        if col < c && row == 0 {
                                            Rectangle()
                                                .fill(Clr.calenderSquare)
                                                .frame(width: gp.size.width * 0.12, height: gp.size.width * 0.12)
                                                .border(.white, width: 1)
                                                .opacity(isOnboarding ? UserDefaults.standard.string(forKey: K.defaults.onboarding) == "stats" ? 0.5 : 1 : 1)
                                        } else {
                                            if gardenModel.monthTiles[row]?[currentDate]?.0 != nil && gardenModel.monthTiles[row]?[currentDate]?.1 != nil {
                                                // mood & plant both exist
                                                // first tile in onboarding
                                                let plantHead = gardenModel.monthTiles[row]?[currentDate]?.0?.head.resizable().aspectRatio(contentMode: .fit)
                                                ZStack {
                                                    Rectangle()
                                                        .fill(gardenModel.monthTiles[row]?[currentDate]?.1?.color ?? Clr.calenderSquare)
                                                        .border(.white, width: 1)
                                                        .opacity(isOnboarding ? tileOpacity : 1)
                                                        .animation(Animation.easeInOut(duration:0.5).repeatForever(autoreverses:true), value: tileOpacity)
                                                    plantHead
//                                                        .resizable()
//                                                        .aspectRatio(contentMode: .fit)
                                                        .padding(3)
                                                        .overlay(
                                                            ZStack {
                                                                if UserDefaults.standard.bool(forKey: "tileDates") {
                                                                    Text(currentDate <= maxDate ? "\(currentDate)" : "").offset(x: 6, y: 15)
                                                                        .font(Font.fredoka(.semiBold, size: 10))
                                                                        .foregroundColor(Color.black)
                                                                        .padding(.leading)
                                                                }
                                                            }
                                                        )
                                                        .opacity(isOnboarding ? tileOpacity : 1)
                                                        .animation(Animation.easeInOut(duration:0.5).repeatForever(autoreverses:true), value: tileOpacity)
                                                }.frame(width: gp.size.width * 0.12, height: gp.size.width * 0.12)
                                            } else if gardenModel.monthTiles[row]?[currentDate]?.0 != nil { // only mood is nil
                                                ZStack {
                                                    let plant = gardenModel.monthTiles[row]?[currentDate]?.0
                                                    let plantHead = gardenModel.monthTiles[row]?[currentDate]?.0?.head
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                    Rectangle()
                                                        .fill(plant?.title == "Ice Flower" ? Clr.freezeBlue : Clr.calenderSquare)
                                                        .border(.white, width: 1)
                                                        .opacity(isOnboarding ? tileOpacity : 1)
                                                        .animation(Animation.easeInOut(duration:0.5).repeatForever(autoreverses:true), value: tileOpacity)
                                                    plantHead
//                                                        .resizable()
//                                                        .aspectRatio(contentMode: .fit)
                                                        .padding(3)
                                                        .overlay(
                                                            ZStack {
                                                                if UserDefaults.standard.bool(forKey: "tileDates") {
                                                                    Text(currentDate <= maxDate ? "\(currentDate)" : "").offset(x: 6, y: 15)
                                                                        .font(Font.fredoka(.semiBold, size: 10))
                                                                        .foregroundColor(Color.black)
                                                                        .padding(.leading)
                                                                }
                                                            }
                                                        )
                                                        .opacity(isOnboarding ? tileOpacity : 1)
                                                        .animation(Animation.easeInOut(duration:0.5).repeatForever(autoreverses:true), value: tileOpacity)
                                                }.frame(width: gp.size.width * 0.12, height: gp.size.width * 0.12)
                                            } else if gardenModel.monthTiles[row]?[currentDate]?.1 != nil { // only plant is nil
                                                Rectangle()
                                                    .fill(gardenModel.monthTiles[row]?[currentDate]?.1?.color ?? Clr.calenderSquare)
                                                    .frame(width:  gp.size.width * 0.12, height:  gp.size.width * 0.12)
                                                    .border(.white, width: 1)
                                                    .overlay(
                                                        ZStack {
                                                            if UserDefaults.standard.bool(forKey: "tileDates") {
                                                                Text(currentDate <= maxDate ? "\(currentDate)" : "").offset(x: 6, y: 15)
                                                                    .font(Font.fredoka(.semiBold, size: 10))
                                                                    .foregroundColor(Color.black)
                                                                    .padding(.leading)
                                                            }
                                                        }
                                                    )
                                            } else { //both are nil
                                                ZStack {
                                                    Rectangle()
                                                        .fill(Clr.calenderSquare)
                                                        .frame(width: gp.size.width * 0.12, height: gp.size.width * 0.12)
                                                        .border(.white, width: 1)
                                                        .opacity(isOnboarding ? UserDefaults.standard.string(forKey: K.defaults.onboarding) == "stats" ? 0.5 : 1 : 1)
                                                        .overlay(
                                                            ZStack {
                                                                if UserDefaults.standard.bool(forKey: "tileDates") {
                                                                    Text(currentDate <= maxDate ? "\(currentDate)" : "").offset(x: 6, y: 15)
                                                                        .font(Font.fredoka(.semiBold, size: 10))
                                                                        .foregroundColor(Color.black)
                                                                        .padding(.leading)
                                                                }
                                                            }
                                                        )
                                                }
                                            }
                                        }
                                    }
                                    .onTapGesture {
                                        Analytics.shared.log(event: .garden_tapped_single_day)
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        day = col + (row * 7) + 1  - gardenModel.placeHolders
                                        if gardenModel.monthTiles[row]?[col + (row * 7) + 1 - gardenModel.placeHolders]?.0?.title != "Ice Flower" {
                                            if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "stats" {
                                                if (gardenModel.monthTiles[row]?[col + (row * 7) + 1 - gardenModel.placeHolders]?.0 != nil || gardenModel.monthTiles[row]?[col + (row * 7) + 1 - gardenModel.placeHolders]?.1 != nil)  {
                                                    Analytics.shared.log(event: .onboarding_finished_single)
                                                    showSingleModal = true
                                                    isOnboarding = false
                                                    UserDefaults.standard.setValue("single", forKey: K.defaults.onboarding)
                                                }
                                            } else {
                                                if day <= 31 && day >= 1 {
                                                    if !isOnboarding {
                                                        showSingleModal = true
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(3)
                                .opacity(isOnboarding ? (UserDefaults.standard.string(forKey: K.defaults.onboarding) == "meditate" ||  UserDefaults.standard.string(forKey: K.defaults.onboarding) == "stats") ? 1 : 0.1 : 1)
                                .zIndex(-1000)
                                
                                HStack {
                                    Text("\(Date().getMonthName(month: String(gardenModel.selectedMonth))) \(String(gardenModel.selectedYear).withReplacedCharacters(",", by: ""))")
                                        .font(Font.fredoka(.regular, size: 20))
                                        .foregroundColor(Clr.black2)
                                        .padding(.leading)
                                    Spacer()
                                    Button {
                                        withAnimation {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            Analytics.shared.log(event: .garden_previous_month)
                                            if gardenModel.selectedMonth == 1 {
                                                gardenModel.selectedMonth = 12
                                                gardenModel.selectedYear -= 1
                                            } else {
                                                gardenModel.selectedMonth -= 1
                                            }
                                            gardenModel.populateMonth()
                                            getFavoritePlants()
                                        }
                                    } label: {
                                        OperatorButton(imgName: "lessthan")
                                            .neoShadow()
                                    }
                                    Button {
                                        withAnimation {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            Analytics.shared.log(event: .garden_next_month)
                                            if gardenModel.selectedMonth == 12 {
                                                gardenModel.selectedMonth = 1
                                                gardenModel.selectedYear += 1
                                            } else {
                                                gardenModel.selectedMonth += 1
                                            }
                                            gardenModel.populateMonth()
                                            getFavoritePlants()
                                        }
                                    } label: {
                                        OperatorButton(imgName: "greaterthan")
                                            .neoShadow()
                                    }
                                }
                                .padding(10)
                                .opacity(isOnboarding ? UserDefaults.standard.string(forKey: K.defaults.onboarding) == "meditate" ? 1 : 0.1 : 1)
                                .padding(.bottom)
                            }.frame(width:UIScreen.screenWidth*0.85, alignment: .center)
                        }
                        .background(Clr.darkWhite)
                        .cornerRadius(16)
                        .addBorder(.black, width: 1.5, cornerRadius: 16)
                        .neoShadow()
                        .offset(y: playEntryAnimation ? 0 : 200)
                        .animation(animation.delay(0.1), value: playEntryAnimation)
                            .padding(5)
                        
                        Text("Monthly Stats")
                            .foregroundColor(Clr.black2)
                            .font(Font.fredoka(.semiBold, size: forceRefresh ? 20 : 20.1))
                            .offset(x: playEntryAnimation ? UIScreen.screenWidth * -0.25 - 5 : -400, y: 25)
                            .animation(animation.delay(0.4), value: playEntryAnimation)
                        HStack(spacing: 15) {
                            HStack(spacing: 10) {
                                VStack {
                                    HStack {
                                        StatBox(label: "Gratitudes", img: Img.hands, value: "\(gardenModel.gratitudes)")
                                        StatBox(label: "Sessions", img: Img.iconSessions, value: "\(gardenModel.totalSessions)")
                                        StatBox(label: "Minutes", img: Img.iconTotalTime, value: "\(Helper.minuteandhours(min: Double(gardenModel.totalMins/60), isNewLine: true))")
                                    }
                                    .frame(height:60)
                                    ZStack {
                                        Rectangle()
                                            .fill(Clr.darkWhite)
                                            .addBorder(.black, width: 1.5, cornerRadius: 16)
                                            .neoShadow()
                                        HStack {
                                            Img.streak
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .padding()
                                                .padding(.trailing,0)
                                                .frame(width: 100)
                                                .offset(x: 5)
                                            VStack(spacing: 20) {
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(.black, lineWidth: 1.5)
                                                    .background(Clr.yellow.cornerRadius(8))
                                                    .overlay(
                                                        VStack {
                                                            Text("Current Streak")
                                                                .foregroundColor(colorScheme == .dark ? .black : Clr.black2)
                                                                .font(Font.fredoka(.regular, size: 12))
                                                            Text(currentStreak)
                                                                .foregroundColor(colorScheme == .dark ? .black : Clr.black2)
                                                                .font(Font.fredoka(.bold, size: 20))
                                                        }
                                                    )
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(.black, lineWidth: 1.5)
                                                    .background(Clr.yellow.cornerRadius(8))
                                                    .overlay(
                                                        VStack {
                                                            Text("Longest Streak")
                                                                .foregroundColor(colorScheme == .dark ? .black : Clr.black2)
                                                                .font(Font.fredoka(.regular, size: 12))
                                                            Text("\(UserDefaults.standard.integer(forKey: "longestStreak"))")
                                                                .foregroundColor(colorScheme == .dark ? .black : Clr.black2)
                                                                .font(Font.fredoka(.bold, size: 20))
                                                        }
                                                    )
                                            }
                                            .padding(.vertical)
                                            .padding(.trailing)
                                        }
                                    }.frame(height:150)
                                        .padding(.top,5)
                                }
                                .padding(.vertical)
                                .padding(.trailing,5)
                                .offset(x: playEntryAnimation ? 0 : -400)
                                .animation(animation.delay(0.4), value: playEntryAnimation)
                                ZStack {
                                    Rectangle()
                                        .fill(Clr.darkWhite)
                                        .addBorder(.black, width: 1.5, cornerRadius: 16)
                                        .neoShadow()
                                    VStack(spacing:5) {
                                        Text("Moods")
                                            .foregroundColor(Clr.black2)
                                            .font(Font.fredoka(.semiBold, size: 12))
                                            .offset(y: -10)
                                        MoodImage(mood: .veryGood, value: gardenModel.totalMoods[.veryGood] ?? 0)
                                        MoodImage(mood: .good, value: gardenModel.totalMoods[.good] ?? 0)
                                        MoodImage(mood: .okay, value: gardenModel.totalMoods[.okay] ?? 0)
                                        MoodImage(mood: .bad, value: gardenModel.totalMoods[.bad] ?? 0)
                                        MoodImage(mood: .veryBad, value: gardenModel.totalMoods[.veryBad] ?? 0)
                                    }
                                    .padding(15)
                                }
                                .padding()
                                .neoShadow()
                                .frame(width:UIScreen.screenWidth * 0.165, height: UIScreen.screenHeight * (K.isSmall () ? 0.17 : 0.15))
                                .offset(x: playEntryAnimation ? 0 : 400)
                                .animation(animation.delay(0.2), value: playEntryAnimation)
                            }
                        }.frame(width:UIScreen.screenWidth*0.85)
                            .opacity(isOnboarding ? UserDefaults.standard.string(forKey: K.defaults.onboarding) == "calendar" ? 1 : 0.1 : 1)
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Favorite Plants")
                                .foregroundColor(Clr.black2)
                                .font(Font.fredoka(.semiBold, size: forceRefresh ? 20 : 20.1))
                                .padding(.leading, gp.size.width * 0.075 - 25)
                            ZStack {
                                Rectangle()
                                    .fill(Clr.darkWhite)
                                    .addBorder(.black, width: 1.5, cornerRadius: 16)
                                    .neoShadow()
                                    .frame(maxWidth: gp.size.width * 0.85)
                                HStack(spacing: 20){
                                    Spacer()
                                    if topThreePlants.isEmpty {
                                        Text("You have no favorite plants")
                                            .foregroundColor(Clr.black2)
                                            .font(Font.fredoka(.regular, size: 20))
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.05)
                                            .padding()
                                    } else {
                                        if !topThreePlants.isEmpty, let favPlant1 = topThreePlants[0] {
                                            favPlant1
                                        }
                                        if topThreePlants.count > 1, let favPlant2 = topThreePlants[1] {
                                            favPlant2
                                        }
                                        if topThreePlants.indices.contains(2), let favPlant3 = topThreePlants[2] {
                                            favPlant3
                                        }
                                    }
                                    Spacer()
                                }
                            }.frame(maxWidth: gp.size.width * (sizeCategory > .large ? 1 : 0.85), maxHeight: 150)
                        }.padding(.top, 15)
                            .opacity(isOnboarding ? UserDefaults.standard.string(forKey: K.defaults.onboarding) == "calendar" ? 1 : 0.1 : 1)
                            .offset(y: playEntryAnimation ? 0 : 400)
                            .animation(animation.delay(0.4), value: playEntryAnimation)
                    }.padding(.horizontal, 25)
                        .padding(.vertical, 15)
                        .padding(.top, 30)
                    if isOnboarding && (UserDefaults.standard.string(forKey: K.defaults.onboarding) == "meditate" || UserDefaults.standard.string(forKey: K.defaults.onboarding) == "calendar" ){
                        VStack(spacing: 0) {
                            if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "meditate" {
                                Triangle()
                                    .fill(Clr.yellow)
                                    .frame(width: 40, height: 20)
                            }
                            Rectangle()
                                .fill(Clr.yellow)
                                .frame(width: 250, height: 140)
                                .overlay(
                                    VStack {
                                        Text(UserDefaults.standard.string(forKey: K.defaults.onboarding) == "meditate"  ? "📅 This is your calendar view of the month (color of the tile = your mood)" : "📊 These are your monthly statistics")
                                            .font(Font.fredoka(.semiBold, size: 18))
                                            .lineLimit(3)
                                            .minimumScaleFactor(0.05)
                                            .multilineTextAlignment(.center)
                                            .padding(.bottom, 5)
                                            .foregroundColor(Color.black)
                                        Text("Got it")
                                            .foregroundColor(Color.white)
                                            .colorMultiply(self.color)
                                            .font(Font.fredoka(.bold, size: 18))
                                            .onAppear {
                                                withAnimation {
                                                    self.color = Clr.darkgreen
                                                }
                                            }
                                            .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses:true), value: self.color)
                                            .onTapGesture {
                                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                                withAnimation {
                                                    if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "meditate" {
                                                        Analytics.shared.log(event: .onboarding_finished_calendar)
                                                        UserDefaults.standard.setValue("calendar", forKey: K.defaults.onboarding)
                                                        
                                                    } else if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "calendar" {
                                                        UserDefaults.standard.setValue("stats", forKey: K.defaults.onboarding)
                                                        tileOpacity = 0.2
                                                        Analytics.shared.log(event: .onboarding_finished_stats)
                                                    }
                                                    forceRefresh.toggle()
                                                }
                                            }
                                    }.padding()
                                )
                                .cornerRadius(16)
                            
                            if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "calendar" {
                                Triangle()
                                    .fill(Clr.yellow)
                                    .frame(width: 40, height: 20)
                                    .rotationEffect(.radians(.pi))
                                
                            }
                        }.offset(y: UserDefaults.standard.string(forKey: K.defaults.onboarding) == "meditate" ? -125 : -75)
                    }
                    if UserDefaults.standard.integer(forKey: "numMeds") > 0 {
                        switch UserDefaults.standard.string(forKey: K.defaults.onboarding) {
                        case "meditate":
                            Img.calendarRacoon
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 125)
                                .position(x: gp.size.width/2, y: gp.size.height/1.25)
                        case "calendar":
                            Img.statRacoon
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 125)
                                .position(x: gp.size.width/2, y: gp.size.height/3)
                        case "stats":
                            Img.calendarRacoon
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 125)
                                .position(x: gp.size.width - 100, y:  gp.size.height/1.75)
                        default: EmptyView()
                        }
                    }
                    // TODO  fix day4 being set to true on launch
                }.padding(.bottom ,50)
                Spacer().frame(height:80)
            }.fullScreenCover(isPresented: $userModel.triggerAnimation) {
                PlantGrowing()
            }
            .popover(isPresented: $showSingleModal) {
                SingleDay(showSingleModal: $showSingleModal, day: $day, month: gardenModel.selectedMonth, year: gardenModel.selectedYear)
                    .environmentObject(gardenModel)
                    .navigationViewStyle(StackNavigationViewStyle())
            }.onAppear {
                DispatchQueue.main.async {
                    withAnimation {
                        playEntryAnimation = true
                    }
                    getFavoritePlants()
                    if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "meditate" {
                        if UserDefaults.standard.integer(forKey: "numMeds") > 0 {
                            isOnboarding = true
                        }
                        if let onboardingNotif = UserDefaults.standard.value(forKey: "onboardingNotif") as? String {
                            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [onboardingNotif])
                        }
                    }
                }
            }
            .sheet(item: $activeSheet) { item in
                switch item {
                case .profile:
                    ProfileScene(profileModel: profileModel)
                        .environmentObject(userModel)
                        .environmentObject(gardenModel)
                        .environmentObject(viewRouter)
                case .plant:
                    Store(isShop: false)
                case .search:
                    EmptyView()
                case .streak:
                    EmptyView()
                case .mood:
                    EmptyView()
                }
            }
            .onAppearAnalytics(event: .screen_load_garden)
        }
    }
    private func getFavoritePlants() {
        topThreePlants = [FavoritePlant]()
        let topThreeStrings = gardenModel.favoritePlants.sorted { $0.value > $1.value }.prefix(3)
        for str in topThreeStrings {
            if let plnt = Plant.allPlants.first(where: { plt in
                plt.title == str.key
            }) {
                topThreePlants.append(FavoritePlant(title: str.key, count: str.value,
                                                    img: plnt.coverImage))
            }
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}


//MARK: - preview
struct Garden_Previews: PreviewProvider {
    static var previews: some View {
        Garden().environmentObject(GardenViewModel())
    }
}

//MARK: - components
struct MoodImage: View {
    let mood: Mood
    let value: Int
    @Environment(\.sizeCategory) var sizeCategory
    var isStressed: Bool {
        return mood == .stressed
    }
    
    var body: some View {
        HStack(spacing: 5) {
            Mood.getMoodImage(mood: mood)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24)
                .padding(.leading, 2)
            Text(String(value))
                .font(Font.fredoka(.semiBold, size: 16))
                .foregroundColor(Clr.black2)
                .lineLimit(1)
                .frame(width: 15)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }.frame(height:30)
    }
}

struct MenuButton: View {
    var title: String
    var isMonth: Bool
    
    var body: some View {
        ZStack {
            Capsule()
                .fill(isMonth ? Clr.gardenGreen : Clr.darkWhite)
                .frame(width: 100, height: 35)
                .neoShadow()
            Text(title)
                .font(Font.fredoka(.regular, size: 16))
                .foregroundColor(isMonth ? .white : Clr.black1)
        }
    }
}

struct OperatorButton: View {
    let imgName: String
        
    var body: some View {
            ZStack {
                Rectangle()
                    .fill(Clr.darkWhite)
                    .cornerRadius(8)
                    .frame(width: 36, height: 36)
                Image(systemName: imgName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Clr.darkgreen)
                    .frame(height: 15)
                    .font(Font.title.weight(.bold))
            }
    }
}

struct FavoritePlant: View {
    let title: String
    let count: Int
    let img: Image
    
    var body: some View {
        VStack(spacing: 0) {
            img
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(8)
                .overlay(RoundedRectangle(cornerRadius: 14)
                    .stroke(Clr.darkgreen))
            HStack {
                Text("\(title)")
                    .font(Font.fredoka(.regular, size: 12))
                    .lineLimit(2)
                    .minimumScaleFactor(0.05)
                Text("\(count)").bold()
                    .font(Font.fredoka(.bold, size: 16))
            }.padding(.top, 8)
        }.frame(width: 70, height: 120)
            .padding(10)
    }
}
