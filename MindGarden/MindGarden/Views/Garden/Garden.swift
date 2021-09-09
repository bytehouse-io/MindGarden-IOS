//
//  Garden.swift
//  MindGarden
//
//  Created by Dante Kim on 6/19/21.
//

import SwiftUI

struct Garden: View {
    @EnvironmentObject var gardenModel: GardenViewModel
    @State var isMonth: Bool = true
    @State var showSingleModal = false
    @State var day: Int = 0
    @State var topThreePlants: [FavoritePlant] = [FavoritePlant]()

    var body: some View {
        GeometryReader { gp in
            ScrollView(showsIndicators: false) {
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
                    Text("🪴 Your MindGarden")
                        .font(Font.mada(.semiBold, size: 22))
                        .foregroundColor(Clr.darkgreen)
                        .padding()
                    HStack {
                        Text("\(Date().getMonthName(month: String(gardenModel.selectedMonth))) \(String(gardenModel.selectedYear))")
                            .font(Font.mada(.bold, size: 30))
                        Spacer()
                        Button {
                            if gardenModel.selectedMonth == 1 {
                                gardenModel.selectedMonth = 12
                                gardenModel.selectedYear -= 1
                            } else {
                                gardenModel.selectedMonth -= 1
                            }
                            gardenModel.populateMonth()
                            getFavoritePlants()
                        } label: {
                            OperatorButton(imgName: "lessthan.square.fill")
                        }

                        Button {
                            if gardenModel.selectedMonth == 12 {
                                gardenModel.selectedMonth = 1
                                gardenModel.selectedYear += 1
                            } else {
                                gardenModel.selectedMonth += 1
                            }
                            gardenModel.populateMonth()
                            getFavoritePlants()
                        } label: {
                            OperatorButton(imgName: "greaterthan.square.fill")
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, -15)
                    GridStack(rows: 5, columns: 7) { row, col in
                        ZStack {
                            let c = gardenModel.placeHolders
                            if col < c && row == 0 {
                                Rectangle()
                                    .fill(Clr.dirtBrown)
                                    .frame(width: gp.size.width * 0.12, height: gp.size.width * 0.12)
                                    .shadow(color: .black.opacity(0.25), radius: 10, x: 4, y: 4)
                            } else {
                                if gardenModel.monthTiles[row]?[col + (row * 7) + 1 - c]?.0 != nil && gardenModel.monthTiles[row]?[col + (row * 7) + 1 - c]?.1 != nil {
                                    // mood & plant both exist
                                    ZStack {
                                        Rectangle()
                                            .fill(gardenModel.monthTiles[row]?[col + (row * 7) + 1 - c]?.1?.color ?? Clr.dirtBrown)
                                            .frame(width: gp.size.width * 0.12, height: gp.size.width * 0.12)
                                            .shadow(color: .black.opacity(0.25), radius: 10, x: 4, y: 4)
                                        Img.oneBlueberry
                                            .padding(3)
                                    }
                                } else if gardenModel.monthTiles[row]?[col + (row * 7) + 1 - c]?.0 != nil { // only mood is nil
                                    ZStack {
                                        Rectangle()
                                            .fill(Clr.dirtBrown)
                                            .frame(width: gp.size.width * 0.12, height: gp.size.width * 0.12)
                                            .shadow(color: .black.opacity(0.25), radius: 10, x: 4, y: 4)
                                        Img.oneBlueberry
                                            .padding(3)
                                    }
                                } else if gardenModel.monthTiles[row]?[col + (row * 7) + 1 - c]?.1 != nil { // only plant is nil
                                    Rectangle()
                                        .fill(gardenModel.monthTiles[row]?[col + (row * 7) + 1 - c]?.1?.color ?? Clr.dirtBrown)
                                        .frame(width: gp.size.width * 0.12, height: gp.size.width * 0.12)
                                        .shadow(color: .black.opacity(0.25), radius: 10, x: 4, y: 4)

                                } else { //both are nil
                                    Rectangle()
                                        .fill(Clr.dirtBrown)
                                        .frame(width: gp.size.width * 0.12, height: gp.size.width * 0.12)
                                        .shadow(color: .black.opacity(0.25), radius: 10, x: 4, y: 4)

                                }
                            }
                        }.onTapGesture {
                            day = col + (row * 7) + 1  - gardenModel.placeHolders
                            if day <= 31 && day >= 1 {
                                showSingleModal = true
                            }
                        }
                    }.offset(y: -10)
                    HStack(spacing: 5) {
                        VStack(spacing: 15) {
                            StatBox(label: "Total Mins", img: Img.iconTotalTime, value: "\(gardenModel.totalMins)")
                            StatBox(label: "Total Sessions", img: Img.iconSessions, value: "\(gardenModel.totalSessions)")
                        }
                        .frame(maxWidth: gp.size.width * 0.33)
                        ZStack {
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .cornerRadius(15)
                                .neoShadow()
                            VStack(spacing: 10) {
                                HStack(alignment: .bottom) {
                                    MoodImage(mood: .happy, value: gardenModel.totalMoods[.happy] ?? 0)
                                    MoodImage(mood: .sad, value: gardenModel.totalMoods[.sad] ?? 0)
                                }.padding(.horizontal, 10)
                                HStack(alignment: .bottom) {
                                    MoodImage(mood: .okay, value: gardenModel.totalMoods[.okay] ?? 0)
                                    MoodImage(mood: .angry, value: gardenModel.totalMoods[.angry] ?? 0)
                                }.padding(.horizontal, 10)
                            }
                        }.frame(maxWidth: gp.size.width * 0.47)
                    }.frame(maxHeight: gp.size.height * 0.16)
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Favorite Plants:")
                            .foregroundColor(.black)
                            .font(Font.mada(.semiBold, size: 20))
                            .padding(.leading, 5)
                        ZStack {
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .cornerRadius(15)
                                .neoShadow()
                            HStack(spacing: 25){
                                Spacer()
                                if topThreePlants.isEmpty {
                                    Text("You have no favorite plants")
                                        .foregroundColor(.black)
                                        .font(Font.mada(.semiBold, size: 20))
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
                        }.frame(maxWidth: gp.size.width * 0.8, maxHeight: gp.size.height * 0.4)
                    }.padding(.top, 15)
                }.padding(.horizontal, 25)
                .padding(.vertical, 15)
                .padding(.top, 30)
            }
            .sheet(isPresented: $showSingleModal) {
                SingleDay(showSingleModal: $showSingleModal, day: $day, month: gardenModel.selectedMonth, year: gardenModel.selectedYear)
                    .environmentObject(gardenModel)
                    .navigationViewStyle(StackNavigationViewStyle())
            }
            .onAppear {
                getFavoritePlants()
            }

        }
    }
    private func getFavoritePlants() {
        topThreePlants = [FavoritePlant]()
        let topThreeStrings = gardenModel.favoritePlants.sorted { $0.value > $1.value }.prefix(3)
        for str in topThreeStrings {
            if let plnt = Plant.plants.first(where: { plt in
                plt.title == str.key
            }) {
                topThreePlants.append(FavoritePlant(title: str.key, count: str.value,
                                                    img: plnt.coverImage))
            }
        }
    }
}


//MARK: - preview
struct Garden_Previews: PreviewProvider {
    static var previews: some View {
        PreviewDisparateDevices {
            Garden()
        }
    }
}

//MARK: - components
struct MoodImage: View {
    let mood: Mood
    let value: Int

    var body: some View {
        HStack(spacing: 0) {
            K.getMoodImage(mood: mood)
                .resizable()
                .aspectRatio(contentMode: .fit)
            VStack(alignment: .center) {
                Text(mood.title)
                    .font(.subheadline)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                Text(String(value))
                    .font(.headline)
                    .bold()
            }.padding(.leading, 3)
            .frame(maxWidth: 40)
        }.padding(3)
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
                .font(Font.mada(.regular, size: 16))
                .foregroundColor(isMonth ? .white : Clr.black1)
        }
    }
}

struct OperatorButton: View {
    let imgName: String

    var body: some View {
        Image(systemName: imgName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .background(Clr.darkgreen)
            .foregroundColor(Clr.darkWhite)
            .cornerRadius(10)
            .frame(height: 35)
            .neoShadow()
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
                .overlay(RoundedRectangle(cornerRadius: 15)
                            .stroke(Clr.darkgreen))
            HStack {
                Text("\(title)")
                    .font(Font.mada(.regular, size: 16))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text("\(count)").bold()
                    .font(Font.mada(.bold, size: 16))
            }.padding(.top, 8)
        }.frame(width: 70, height: 120)
        .padding(10)
    }
}
