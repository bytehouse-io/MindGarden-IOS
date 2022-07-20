//
//  ProfilePage.swift
//  MindGarden
//
//  Created by Dante Kim on 7/11/22.
//

import SwiftUI
import Firebase
import WidgetKit

struct ProfilePage: View {
    @EnvironmentObject var gardenModel: GardenViewModel
    
    var profileModel: ProfileViewModel
    var width: CGFloat
    var height: CGFloat
    var totalSessions: Int
    var totalMins: Int
    @State private var text = ""
    @State private var response = ""
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter
    }
    let currentYear = Calendar.current.component(.year, from: Date())
    
    var body: some View {
        ZStack {
            Clr.darkWhite.edgesIgnoringSafeArea(.all)
            ScrollView(showsIndicators: false) {
                
                VStack {
                    VStack(alignment: .center, spacing: 10) {
                        Text("Your Mindfulness Journey")
                            .font(Font.fredoka(.medium, size: 24))
                            .foregroundColor(Clr.black2)
                            .frame(width: UIScreen.screenWidth * 0.8, alignment: .leading)
                        Text("7 Mindful Days")
                            .font(Font.fredoka(.regular, size: 20))
                            .foregroundColor(Clr.black2)
                            .frame(width: UIScreen.screenWidth * 0.8, alignment: .leading)
                        HStack(alignment: .center, spacing: 5) {
                            ProfileBox(img: Img.veryGoodPot, count: 3)
                            ProfileBox(img: Img.meditateTurtle, count: 4)
                            ProfileBox(img: Img.streak, count: UserDefaults.standard.integer(forKey: "longestStreak"))
                        }.padding(.top)
                        HStack(alignment: .center, spacing: 5) {
                            ProfileBox(img: Img.veryGoodPot, count: 72)
                            ProfileBox(img: Img.breathIcon, count: 22)
                            ProfileBox(img: Img.flowers, count: 14)
                        }
                    }.frame(width: width * 0.8, height: 160)
                        .padding(50)
                    ForEach(gardenModel.entireHistory, id: \.0) { day in
                        let date = day.0
                        let dateComponents = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, year: date[2], month: date[1], day: date[0])
                        // Create date from components
                        let someDateTime = Calendar.current.date(from: dateComponents)
                        let weekDay = dateFormatter.string(from: someDateTime ?? Date())
                        let daysData = sortData(dataArr: day.1) // sort by time
                        Rectangle()
                            .fill(Clr.darkWhite)
                            .cornerRadius(14)
                            .addBorder(.black,width:1.5, cornerRadius: 14)
                            .neoShadow()
                            .overlay(
                                VStack {
                                    Text("\(Date().intToMonth(num: date[1])) \(date[0]), \(currentYear == (date[2]) ? "" : String(date[2])) \(weekDay)")
                                        .font(Font.fredoka(.medium, size: 20))
                                        .foregroundColor(Clr.brightGreen)
                                        .frame(width: width * 0.725, alignment: .leading)
                                    ForEach(daysData, id: \.self) { data in // sessions, mood, journals for that day
                                        VStack(spacing: 0) {
                                            DataRow(data: data)
                                        }
                                    }
                                }.padding(15)
                            ).frame(width: width * 0.85, height: CGFloat(daysData.count) * 70 + 60)
                            .padding(16)
                    }
                    
                    Text(response)
                        .foregroundColor(Clr.darkgreen)
                        .font(Font.fredoka(.semiBold, size: 16))
                        .frame(width: width * 0.75, alignment: .center)
                    HStack {
                        TextField("Enter promo code", text: $text)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .background(Clr.darkWhite)
                            .frame(width: width * 0.5, height: 40)
                            .oldShadow()
                        Button {
                            if text == "FTXTNL7E3AA6" {
                                UserDefaults.standard.setValue(true, forKey: "promoCode")
                                UserDefaults(suiteName: "group.io.bytehouse.mindgarden.widget")?.setValue(true, forKey: "isPro")
                                WidgetCenter.shared.reloadAllTimelines()
                                UserDefaults.standard.setValue(true, forKey: "isPro")
                                UserDefaults.standard.setValue(true, forKey: "bonsai")
                                if let email = Auth.auth().currentUser?.email {
                                    Firestore.firestore().collection(K.userPreferences).document(email).updateData([
                                        "isPro": true,
                                    ]) { (error) in
                                        if let e = error {
                                            print("There was a issue saving data to firestore \(e) ")
                                        } else {
                                            print("Succesfully saved pro")
                                        }
                                    }
                                }
                                response = "✅ Success your a pro user now!"
                            } else {
                                response = "Invalid code"
                            }
                        } label: {
                            ZStack {
                                Rectangle()
                                    .fill(Clr.yellow)
                                    .cornerRadius(12)
                                Text("Submit")
                                    .font(Font.fredoka(.semiBold, size: 16))
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                            }
                        }.buttonStyle(NeumorphicPress( ))
                    }.frame(width: width * 0.75, height: 35)
                        .keyboardResponsive()
                }
            }
        }.onAppear {
            //            fetchHistory()
        }
    }
    
    struct DataRow: View {
        @State var type: String = ""
        @State var timeStamp: String = ""
        @State var med: Meditation = Meditation.allMeditations.first!
        @State var mood: Image = Img.veryGood
        @State var elaboration: String = ""
        let width = UIScreen.screenWidth
        var data: [String: String]
        
        var body: some View {
            HStack(alignment: .center, spacing: 0) {
                Group {
                    VStack {
                        if type == "gratitude" {
                            Img.pencil
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: width * 0.08)
                        } else if type == "meditation" {
                            if med.imgURL != "" {
                                UrlImageView(urlString: med.imgURL)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: width * 0.1)
                                    .padding(.trailing, -5)
                            } else {
                                med.img
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: width * 0.08)
                            }
                        } else {
                            mood
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: width * 0.08)
                        }
                    }
                }.padding(.trailing)
                if type == "journal" || type == "meditation" {
                    VStack(alignment: .leading) {
                        Text("\(med.duration/60 == 0 && med.duration != 0 ? "0.5" : "\(Int(med.duration/60))") mins  |  \(med.instructor)")
                            .font(Font.fredoka(.regular, size: 14))
                            .foregroundColor(Clr.darkGray)
                        Text(med.title)
                            .font(Font.fredoka(.medium, size: 14))
                            .foregroundColor(Clr.black2)
                    }
                } else {
                    if elaboration != "" {
                        Text(elaboration)
                            .font(Font.fredoka(.medium, size: 14))
                            .foregroundColor(Clr.black2)
                            .padding(.horizontal, 25)
                            .padding(.vertical, 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.black, lineWidth: 1.5)
                            )
                            .frame(minWidth: width * 0.175)
                    }
                }
                
                Spacer()
                Text(timeStamp)
                    .font(Font.fredoka(.regular, size: 14))
                    .foregroundColor(Clr.black2)
            }.frame(width: width * 0.75, height: type == "mood" ? 50 : 60, alignment: .leading)
                .onAppear {
                    if let medId = data["meditationId"] {
                        type = "meditation"
                        med = Meditation.allMeditations.first(where: { $0.id == Int(medId) }) ?? Meditation.allMeditations[0]
                    } else if let fbMood = data["mood"] {
                        type = "mood"
                        mood = Mood.getMoodImage(mood: Mood.getMood(str: fbMood))
                        if let elab = data["elaboration"] {
                            elaboration = elab
                        }
                    } else if let journal = data["entry"] {
                        type = "journal"
                    }
                    
                    // legacy data
                    
                    if let theTime = data["timeStamp"] {
                        timeStamp = theTime
                    }
                }
        }
    }
    
    func sortData(dataArr: [[String: String]]) ->  [[String: String]] {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        timeFormatter.amSymbol = "AM"
        timeFormatter.pmSymbol = "PM"
        let convertedArray = dataArr
            .map { return ($0, timeFormatter.date(from: $0["timeStamp"] ?? "12:00 AM")!) }
            .sorted { $0.1 < $1.1 }
            .map(\.0)
        return convertedArray
    }
    
    struct ProfileBox: View {
        let img: Image
        let count: Int
        
        var body: some View {
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(Clr.yellow)
                    .addBorder(.black, width: 1.5, cornerRadius: 14)
                VStack(alignment:.center){
                    HStack(spacing:5) {
                        img
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25)
                        (Text("\(count)")
                            .font(Font.fredoka(.bold, size: 28))
                         + (img == Img.streak ? img == Img.flowers ? Text(" plants") : Text(" days") : Text("x"))
                            .font(Font.fredoka(.regular, size: 16)))
                        .minimumScaleFactor(0.7)
                        .foregroundColor(Clr.black2)
                    }
                    .padding(.horizontal, 5)
                }
            }.frame(width: UIScreen.screenWidth * 0.265, height: 60, alignment: .center)
        }
    }
}

struct ProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePage(profileModel: ProfileViewModel(), width: UIScreen.screenWidth, height: UIScreen.screenHeight, totalSessions: 0, totalMins: 0)
    }
}

