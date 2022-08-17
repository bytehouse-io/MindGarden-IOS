//
//  MindGardenWidget.swift
//  MindGardenWidget
//
//  Created by Dante Kim on 12/26/21.
//

import WidgetKit
import SwiftUI
import Intents
import Amplitude


struct Provider: IntentTimelineProvider {
    let gridd = [String: [String:[String:[String:Any]]]]()
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = [] 
        let userDefaults = UserDefaults(suiteName: "group.io.bytehouse.mindgarden.widget")

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let grid = userDefaults?.value(forKey: "grid") as? [String: [String:[String:[String:Any]]]]
        let streakNumber = userDefaults?.integer(forKey: "streakNumber")
        let isPro = userDefaults?.bool(forKey: "isPro")
        
        let lastLogDate = userDefaults?.value(forKey: "lastJournel") as? String ?? Date().toString(withFormat: "MMM dd, yyyy")
        let lastLogMood = userDefaults?.value(forKey: "logMood") as? String ?? "okay"
        
        let meditation = userDefaults?.value(forKey: "featuredMeditation") as? Int
        let breathwork = userDefaults?.value(forKey: "featuredBreathwork") as? Int
        
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, grid: grid ?? [String: [String:[String:[String:Any]]]](), streakNumber: streakNumber ?? 1, isPro: isPro ?? false,lastLogDate: lastLogDate, lastLogMood: lastLogMood, configuration: configuration, meditationId:meditation ?? 2, breathWorkId: breathwork ?? -1)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date = Date()
    var grid = [String: [String:[String:[String:Any]]]]()
    var streakNumber: Int = 0
    var isPro: Bool = false
    var lastLogDate: String = Date().toString(withFormat: "MMM dd, yyyy")
    var lastLogMood: String = "okay"
    let configuration: ConfigurationIntent
    var meditationId: Int = 1
    var breathWorkId: Int = -1
}

struct MindGardenWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    @State var moods: [Mood: Int]
    @State var gratitudes: Int
    @State var streak: Int
    @State var plants: [Plnt]
    @State var dayTime: Bool
    @State var totalTime: Int
    @State var totalSess: Int

    @ViewBuilder
    var body: some View {
        ZStack {
            Color("darkWhite")
                .neoShadow()
            switch family {
            case .systemSmall:
                SmallWidget(streak: entry.streakNumber)
            case .systemMedium:
                NewMediumWidget(mediumEntry: MediumEntry(lastDate: entry.lastLogDate, lastMood: entry.lastLogMood, meditationId: entry.meditationId, breathworkId: entry.breathWorkId))
            case .systemLarge:
                LargeWidget()
            default:
                Text("Some other WidgetFamily in the future.")
            }
        }.onAppear {
            let hour = Calendar.current.component( .hour, from:Date() )
            if hour <= 17 {
                dayTime = true
            } else {
                dayTime = false
            }
//            extractData()
            Timer.scheduledTimer(withTimeInterval: 3600.0, repeats: true) { timer in
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }

    var GoProPage: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Text("This is a pro only feature")
                    .font(Font.fredoka(.bold, size: 18))
                    .foregroundColor(Color("superBlack"))
                Link(destination: URL(string: "pro://io.bytehouse.mindgarden")!)  {
                    Capsule()
                        .fill(Color("darkgreen"))
                        .overlay(Text("👨‍🌾 Go Pro!")
                                    .foregroundColor(.white)
                                    .font(Font.fredoka(.bold, size: 14)))
                        .frame(width: 125, height: 35)
                        .padding(.top, 5)
                        .neoShadow()
                }
                Spacer()
                }
                Spacer()
            }
    }

    struct MediumWidget: View {
        let width: CGFloat
        let height: CGFloat
        @Binding var moods: [Mood: Int]
        @Binding var gratitudes: Int
        @Binding var streak: Int


        var body: some View {
            HStack(alignment: .center, spacing: 15 ) {
                VStack(spacing: 15) {
                    Link(destination: URL(string: "mood://io.bytehouse.mindgarden")!)  {
                        MenuChoice(title: "Mood", img: Image(systemName: "face.smiling"), width: width)
                            .frame(height: 30)
                            .neoShadow()
                    }
                    Link(destination: URL(string: "gratitude://io.bytehouse.mindgarden")!)  {
                        MenuChoice(title: "Gratitude", img: Image(systemName: "square.and.pencil"), width: width)
                            .frame(height: 30)
                            .neoShadow()
                    }
                    Link(destination: URL(string: "meditate://io.bytehouse.mindgarden")!)  {
                        MenuChoice(title: "Meditate", img: Image(systemName: "play"), width: width)
                            .frame(height: 30)
                            .neoShadow()
                    }
                }.padding(10)
                    .frame(width: width * 0.4, height: height, alignment: .center)
                ZStack {
                    Rectangle()
                        .fill(Color("brightGreen"))
                        .cornerRadius(14)
                        .shadow(radius: 5)
                    VStack {
                        Text("\(Date().getMonthName(month: Date().get(.month)))")
                            .font(Font.fredoka(.bold, size: 14))
                            .foregroundColor(Color.white)
                            .offset(y: 5)
                        HStack(spacing: 5) {
//                             Image("streak")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: width * 0.05)
                            Text("Streak:")
                                .font(Font.fredoka(.regular, size: 14))
                                .foregroundColor(Color.white)
                            Spacer()
                            Text("\(streak)")
                                .font(Font.fredoka(.bold, size: 16))
                                .foregroundColor(Color.white)
                        }.frame(width: width * 0.39, alignment: .leading)
                        HStack(spacing: 5) {
//                            Image("hands")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: width * 0.05)
                            Text("Gratitudes:")
                                .font(Font.fredoka(.regular, size: 14))
                                .foregroundColor(Color.white)
                            Spacer()
                            Text("\(gratitudes)")
                                .font(Font.fredoka(.bold, size: 16))
                                .foregroundColor(Color.white)
                        }.frame(width: width * 0.39, alignment: .leading)
                        HStack(spacing: 10) {
                            Image("pots")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            
//                            SingleMood(mood: .happy, count: moods[.happy] ?? 0)
//                            SingleMood(mood: .okay, count: moods[.okay] ?? 0)
//                            SingleMood(mood: .stressed, count: moods[.stressed] ?? 0)
//                            SingleMood(mood: .angry, count: moods[.angry] ?? 0)
//                            SingleMood(mood: .sad, count: moods[.sad] ?? 0)
                        }.frame(height: height * 0.25)
                        .padding(.horizontal, 8)
                        .offset(y: -2)
                    }
                }.frame(width: width * 0.45, height: height * 0.8, alignment: .center)
                    .padding([.vertical])
            }
        }

    }


    func extractData() {
//       var monthTiles = [Int: [Int: (String?, Mood?)]]()
       var totalMoods = [Mood:Int]()
       var startsOnSunday = false
       var placeHolders = 0
       let strMonth = Date().get(.month)
       var favoritePlants = [String: Int]()
       let numOfDays = Date().getNumberOfDays(month: strMonth, year: Date().get(.year))
       let intWeek = Date().weekDayToInt(weekDay: Date.dayOfWeek(day: "1", month: strMonth, year: Date().get(.year)))
      streak = entry.streakNumber
       if intWeek != 0 {
           placeHolders = intWeek
       } else { //it starts on a sunday
           startsOnSunday = true
       }
       var allPlants = [String]()
       var weekNumber = 0
       for day in 1...numOfDays {
           var plant: String? = nil
           var mood: Mood? = nil
           let weekday = Date.dayOfWeek(day: String(day), month: strMonth, year: Date().get(.year))
           let weekInt = Date().weekDayToInt(weekDay: weekday)

           if weekInt == 0 && !startsOnSunday {
               weekNumber += 1
           } else if startsOnSunday {
               startsOnSunday = false
           }

           if let sessions = entry.grid[String(Date().get(.year))]?[strMonth]?[String(day)]?[KK.defaults.sessions] as? [[String: String]] {
               for session in sessions {
                   self.totalSess += 1
                   self.totalTime += Int(Double(session[K.defaults.duration] ?? "0.0") ?? 0.0)
                   let plant = session[KK.defaults.plantSelected] ?? ""
                   allPlants.append(plant)
               }
           }

           if let moods = entry.grid[String(Date().get(.year))]?[strMonth]?[String(day)]?[KK.defaults.moods] as? [String] {
               mood = Mood.getMood(str: moods[moods.count - 1])
               for forMood in moods {
                   let singleMood = Mood.getMood(str: forMood)
                   if var count = totalMoods[singleMood] {
                       count += 1
                       totalMoods[singleMood] = count
                   } else {
                       totalMoods[singleMood] = 1
                   }
               }
           }

           if let gratitudez = entry.grid[Date().get(.year)]?[strMonth]?[String(day)]?[KK.defaults.gratitudes] as? [String] {
               gratitudes += gratitudez.count
           }
   }
        var plantz = [Plnt]()
        for plant in allPlants {
//            if  plant != "Bonsai Tree"  {
                if let img = KK.plantImages[plant]{
                    let plnt = Plnt(title: img, id: plant)
                    plantz.append(plnt)
                }
//            }
        }
        plantz = plantz.reversed()
        plants = plantz
        moods = totalMoods
    }


    struct SingleMood: View {
        let mood: Mood
        let count: Int

        var body: some View {
            VStack(spacing: 2) {
                KK.getMoodImage(mood: mood)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text("\(count)")
                    .font(Font.fredoka(.bold, size: 12))
                    .foregroundColor(Color.white)
            }

        }
    }

    struct MenuChoice: View {
        let title: String
        let img: Image
        let width: CGFloat

        var body: some View {
            ZStack {
                Capsule()
                    .fill(Color("darkWhite"))
                HStack(spacing: -5) {
                    Text(title)
                        .font(Font.fredoka(.medium, size: 16))
                        .minimumScaleFactor(0.5)
                        .foregroundColor(Color("darkgreen"))
                        .frame(width: width * 0.3, alignment: .leading)
                        .padding(.leading, 5)
                        .offset(x: 10)
                    img
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color("darkgreen"))
                        .padding(3)
                        .frame(width: width * 0.07)
                }.frame(width: width * 0.4, alignment: .leading)
            }
        }
    }
}

struct Plnt: Identifiable {
    let title,id:String
}

@main
struct MindGardenWidget: Widget {
    let kind: String = "MindGardenWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MindGardenWidgetEntryView(entry: entry, moods: [Mood: Int](), gratitudes: 0, streak: 1, plants: [Plnt](), dayTime: true, totalTime: 0, totalSess: 0)
        }
        .configurationDisplayName("MindGarden Widget")
        .description("⚙️ This is the first version of our MindGarden widget. If you would like new features or layouts or experience a bug please fill out the feedback form in the settings page of the app :) We're a small team of 3 so all this feedback will be taken very seriously.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct MindGardenWidget_Previews: PreviewProvider {
    static var previews: some View {
        MindGardenWidgetEntryView(entry: SimpleEntry(configuration: ConfigurationIntent()), moods: [Mood: Int](), gratitudes: 0, streak: 1, plants: [Plnt](), dayTime: true, totalTime: 0, totalSess: 0)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
