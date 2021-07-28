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
    @State var selectedPlant: Plant = Plant(title: "White Daisy", price: 100, selected: false, description: "", packetImage: Img.blueTulipsPacket, coverImage: Img.daisy)
    var isShop: Bool = true
    
    var body: some View {
        ZStack {
            Clr.darkWhite.edgesIgnoringSafeArea(.all)
            GeometryReader { g in
                ScrollView {
                    HStack(alignment: .top, spacing: 20) {
                        ForEach(Plant.plants.suffix(2), id: \.self) { plant in
                            VStack(spacing: -10) {
                                Text(isShop ? "🌻 Seed\nShop" : "🌻 Plant Select")
                                    .font(Font.mada(.bold, size: 32))
                                    .minimumScaleFactor(0.005)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Clr.black1)
                                    .padding()
                                Button {
                                    if isShop {
                                        selectedPlant = plant
                                        withAnimation {
                                            showModal = true
                                        }
                                    } else {

                                    }
                                } label: {
                                    PlantTile(width: g.size.width, height: g.size.height, plant: plant, isShop: isShop)
                                }.buttonStyle(NeumorphicPress())
                            }
                        }
                            VStack {
                                Rectangle()
                                    .foregroundColor(Clr.darkWhite)
                                    .frame(width: g.size.width * 0.35, height: g.size.height * 0.27)
                                    .cornerRadius(15)
                                    .neoShadow()
                                    .padding()
                            }
                    }.padding()
                }.padding(.top)
                .opacity(confirmModal ? 0.3 : 1)
                if showModal || confirmModal {
                    Color.black
                        .opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                    Spacer()
                }
                PurchaseModal(shown: $showModal, showConfirm: $confirmModal, plant: selectedPlant).offset(y: showModal ? 0 : g.size.height)
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
                            Text("Succesfully Unlocked!")
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
                            }
                            .buttonStyle(NeumorphicPress())
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
                            Text("Are you sure you want to spend \(userModel.coins) coins on unlocking \(userModel.willBuyPlant?.title ?? "")")
                                .font(Font.mada(.medium, size: 18))
                                .foregroundColor(Clr.black2.opacity(0.7))
                                .lineLimit(2)
                                .minimumScaleFactor(0.05)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            HStack(alignment: .center, spacing: -10) {
                                Button {
                                    withAnimation {
                                        shown = false
                                    }
                                } label: {
                                    Text("Cancel")
                                        .font(Font.mada(.bold, size: 18))
                                        .foregroundColor(.white)
                                        .frame(width: g.size.width/3, height: 40)
                                        .background(Color.gray.opacity(0.5))
                                        .clipShape(Capsule())
                                        .padding()
                                }
                                .buttonStyle(NeumorphicPress())
                                Button {
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
                                        .padding()
                                }
                                .buttonStyle(NeumorphicPress())
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
            Store()
    }
}
