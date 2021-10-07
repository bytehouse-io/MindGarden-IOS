//
//  Store.swift
//  MindGarden
//
//  Created by Dante Kim on 6/14/21.
//

import SwiftUI

struct Store: View {
    @EnvironmentObject var userModel: UserViewModel
    @State var showModal = false
    @State var confirmModal = false
    @State var showSuccess = false
    var isShop: Bool = true
    @Binding var showPlantSelect: Bool
    
    var body: some View {
        ZStack {
            Clr.darkWhite.edgesIgnoringSafeArea(.all)
            GeometryReader { g in
                ScrollView {
                    HStack(alignment: .top, spacing: 20) {
                        Spacer()
                        VStack(alignment: .leading, spacing: -10) {
                            HStack {
                                if !isShop {
                                    Button {
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        showPlantSelect = false
                                    } label: {
                                        Image(systemName: "xmark")
                                            .resizable()
                                            .renderingMode(.template)
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20)
                                            .foregroundColor(Clr.black1)
                                            .padding(.leading)
                                    }
                                }
                                Text(isShop ? "🌻 Seed\nShop" : "🌻 Plant Select")
                                    .font(Font.mada(.bold, size: 32))
                                    .minimumScaleFactor(0.005)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Clr.black1)
                                    .padding(isShop ? 25 : 10)
                            }
                            ForEach(isShop ? Plant.plants.prefix(Plant.plants.count/2) : userModel.ownedPlants.prefix(userModel.ownedPlants.count/2), id: \.self)
                                { plant in
                                if userModel.ownedPlants.contains(plant) && isShop {
                                    PlantTile(width: g.size.width, height: g.size.height, plant: plant, isShop: isShop, isOwned: true)
                                } else {
                                    Button {
                                        if isShop {
                                            userModel.willBuyPlant = plant
                                            withAnimation {
                                                showModal = true
                                            }
                                        } else {
                                            UserDefaults.standard.setValue(plant.title, forKey: K.defaults.selectedPlant)
                                            userModel.selectedPlant = plant
                                        }
                                    } label: {
                                        PlantTile(width: g.size.width, height: g.size.height, plant: plant, isShop: isShop)
                                    }.buttonStyle(NeumorphicPress())
                                }
                            }
                        }
                            VStack {
                                HStack {
                                    Img.coin
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 25)
                                        .padding(5)
                                    Text(String(userCoins))
                                        .font(Font.mada(.semiBold, size: 24))
                                        .foregroundColor(Clr.black1)
                                }.padding(.bottom, -10)
                                ForEach(isShop ? Plant.plants.suffix(Plant.plants.count/2 + (Plant.plants.count % 2 == 0 ? 0 : 1))
                                            : userModel.ownedPlants.suffix(userModel.ownedPlants.count/2 + (userModel.ownedPlants.count % 2 == 0 ? 0 : 1)), id: \.self) { plant in
                                    if userModel.ownedPlants.contains(plant) && isShop {
                                        PlantTile(width: g.size.width, height: g.size.height, plant: plant, isShop: isShop, isOwned: true)
                                    } else {
                                        Button {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            if isShop {
                                                userModel.willBuyPlant = plant
                                                withAnimation {
                                                    showModal = true
                                                }
                                            } else {
                                                UserDefaults.standard.setValue(plant.title, forKey: K.defaults.selectedPlant)
                                                userModel.selectedPlant = plant
                                            }
                                        } label: {
                                            PlantTile(width: g.size.width, height: g.size.height, plant: plant, isShop: isShop)
                                        }.buttonStyle(NeumorphicPress())
                                    }
                                }
                            }
                        Spacer()
                    }.padding()
                }.padding(.top)
                .opacity(confirmModal ? 0.3 : 1)
                if showModal || confirmModal {
                    Color.black
                        .opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                }
                PurchaseModal(shown: $showModal, showConfirm: $confirmModal).offset(y: showModal ? 0 : g.size.height)
                    .opacity(confirmModal || showSuccess ? 0.3 : 1)
                ConfirmModal(shown: $confirmModal, showSuccess: $showSuccess).offset(y: confirmModal ? 0 : g.size.height)
                    .opacity(showSuccess ? 0.3 : 1)
                SuccessModal(showSuccess: $showSuccess, showMainModal: $showModal).offset(y: showSuccess ? 0 : g.size.height)
            }.padding(.top)
        }
    }

    struct SuccessModal: View {
        @EnvironmentObject var userModel: UserViewModel
        @Binding var showSuccess: Bool
        @Binding var showMainModal: Bool

        var title = "Blue Tulips"

        var  body: some View {
            GeometryReader { g in
                VStack {
                    Spacer()
                    HStack(alignment: .center) {
                        Spacer()
                        VStack(alignment: .center, spacing: 0) {
                            Text("Successfully Unlocked!")
                                .foregroundColor(Clr.black1)
                                .font(Font.mada(.bold, size: 24))
                                .lineLimit(1)
                                .minimumScaleFactor(0.05)
                                .multilineTextAlignment(.center)
                                .padding(.vertical)
                            Text("Go to the home screen and press the select plant button to equip your new plant")
                                .font(Font.mada(.medium, size: 18))
                                .foregroundColor(Clr.black2.opacity(0.7))
                                .lineLimit(2)
                                .minimumScaleFactor(0.05)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                                    showSuccess = false
                                    showMainModal = false
                                }
                            } label: {
                                Text("Got it")
                                    .font(Font.mada(.bold, size: 18))
                                    .foregroundColor(.white)
                                    .frame(width: g.size.width/3, height: 40)
                                    .background(Clr.darkgreen)
                                    .clipShape(Capsule())
                                    .padding()
                                    .neoShadow()
                            }
                        }.frame(width: g.size.width * 0.85, height: g.size.height * 0.30, alignment: .center)
                        .background(Clr.darkWhite)
                        .cornerRadius(20)
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }
    struct ConfirmModal: View {
        @EnvironmentObject var userModel: UserViewModel
        @Binding var shown: Bool
        @Binding var showSuccess: Bool

        var body: some View {
            GeometryReader { g in
                VStack {
                    Spacer()
                    HStack(alignment: .center) {
                        Spacer()
                        VStack(alignment: .center, spacing: 0) {
                            Text("Unlock this plant species?")
                                .foregroundColor(Clr.black1)
                                .font(Font.mada(.bold, size: 24))
                                .lineLimit(1)
                                .minimumScaleFactor(0.05)
                                .multilineTextAlignment(.center)
                                .padding(.vertical)
                            Text("Are you sure you want to spend \(userCoins) coins on unlocking \(userModel.willBuyPlant?.title ?? "")")
                                .font(Font.mada(.medium, size: 18))
                                .foregroundColor(Clr.black2.opacity(0.7))
                                .lineLimit(2)
                                .minimumScaleFactor(0.05)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            HStack(alignment: .center, spacing: -10) {
                                Button {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    withAnimation {
                                        shown = false
                                    }
                                } label: {
                                    Text("Cancel")
                                        .font(Font.mada(.bold, size: 18))
                                        .foregroundColor(.white)
                                        .frame(width: g.size.width/3, height: 40)
                                        
                                }
                                Button {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    userModel.buyPlant()
                                    withAnimation {
                                        shown = false
                                        showSuccess = true
                                    }
                                } label: {
                                    Text("Confirm")
                                        .font(Font.mada(.bold, size: 18))
                                        .foregroundColor(.white)
                                        .frame(width: g.size.width/3, height: 40)
                                        .background(Clr.darkgreen)
                                        .clipShape(Capsule())
                                        .neoShadow()
                                        .padding()
                                }
                            }.padding(.horizontal)
                        }.frame(width: g.size.width * 0.85, height: g.size.height * 0.30, alignment: .center)
                        .background(Clr.darkWhite)
                        .cornerRadius(20)
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }

}

struct Store_Previews: PreviewProvider {
    static var previews: some View {
        Store(showPlantSelect: .constant(false))
    }
}
