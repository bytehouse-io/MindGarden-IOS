//
//  MiddleSelect.swift
//  MindGarden
//
//  Created by Dante Kim on 7/19/21.
//

import SwiftUI

@available(iOS 14.0, *)
struct MiddleSelect: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var model: MeditationViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    @State var tappedMeditation: Bool = false

    var body: some View {
        NavigationView {
            GeometryReader { g in
                ZStack {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                        VStack {
                            Spacer()
                            ZStack {
                                Rectangle()
                                    .fill(Clr.darkWhite)
                                    .frame(width: g.size.width, height: g.size.height)
                                    .cornerRadius(44)
                                    .neoShadow()
                                ScrollView(showsIndicators: false) {
                                    VStack(spacing: 0) {
                                    Text("Selected Plant: Pick Tulips")
                                        .foregroundColor(Clr.black2)
                                        .font(Font.mada(.semiBold, size: 16))
                                        .padding(.top)
                                    HStack(spacing: 0) {
                                        model.selectedMeditation?.img
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: g.size.width/3, height: g.size.height/6)
                                        VStack(alignment: .leading) {
                                            Text(model.selectedMeditation?.title ?? "")
                                                .foregroundColor(Clr.black2)
                                                .font(Font.mada(.semiBold, size: 28))
                                                .lineLimit(2)
                                                .minimumScaleFactor(0.05)
                                            Text(model.selectedMeditation?.description ?? "")
                                                .foregroundColor(Clr.black2)
                                                .font(Font.mada(.regular, size: 16))
                                                .padding(.trailing)
                                        }.frame(width: g.size.width/1.7)
                                        .padding(.vertical, 5)
                                        .offset(x: -10)
                                    }
                                    .padding()
                                    .frame(width: g.size.width)
                                        Divider().padding()
                                        VStack {
                                            ForEach(Array(zip(model.selectedMeditations.indices, model.selectedMeditations)), id: \.0) { (idx,meditation) in
                                                MiddleRow(width: g.size.width/1.2, meditation: meditation, viewRouter: viewRouter, model: model, didComplete: (meditation.type == .lesson && gardenModel.medIds.contains(String(meditation.id)) && meditation.belongsTo != "Timed Meditation"), tappedMeditation: $tappedMeditation, idx: idx)
                                            }
                                        }
                                        Divider().padding()
                                        HStack(spacing: 15) {
                                            Button {
                                                model.selectedMeditation = model.recommendedMeds[0]
                                                if model.selectedMeditation?.type == .course {
                                                    viewRouter.currentPage = .middle
                                                } else {
                                                    viewRouter.currentPage = .play
                                                }
                                            } label: {
                                                HomeSquare(width: g.size.width, height: g.size.height, img: model.recommendedMeds[0].img, title: model.recommendedMeds[0].title, id: model.recommendedMeds[0].id, description: model.recommendedMeds[0].description, duration: model.recommendedMeds[0].duration)
                                            }.buttonStyle(NeumorphicPress())
                                            Button {
                                                model.selectedMeditation = model.recommendedMeds[1]
                                                if model.selectedMeditation?.type == .course {
                                                    viewRouter.currentPage = .middle
                                                } else {
                                                    viewRouter.currentPage = .play
                                                }
                                            } label: {
                                                HomeSquare(width: g.size.width, height: g.size.height, img: model.recommendedMeds[1].img, title: model.recommendedMeds[1].title, id: model.recommendedMeds[1].id, description: model.recommendedMeds[1].description, duration: model.recommendedMeds[1].duration)
                                            }.buttonStyle(NeumorphicPress())
                                        }.padding(.vertical)
                                    }
                                }
                        }
                        }.zIndex(25)
                }
            }.animation(nil)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(
                leading: ZStack {
                    Img.morningSun
                    backButton.padding(.trailing, UIScreen.main.bounds.width/1.35)
                    heart.padding(.leading, UIScreen.main.bounds.width/1.2)
                }.offset(x: -10)
            )
            .edgesIgnoringSafeArea(.bottom)
        }.transition(.move(edge: .trailing))
        .animation(tappedMeditation ? nil : .default)
        .onAppear {
            model.checkIfFavorited()
        }
    }

    var backButton: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            withAnimation {
                viewRouter.currentPage = .meditate
            }
        } label: {
            Image(systemName: "arrow.backward")
                .font(.title)
                .foregroundColor(Clr.darkgreen)
        }
    }

    var heart: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            if let med = model.selectedMeditation {
                model.favorite(selectMeditation: med)
            }
        } label: {
            Image(systemName: model.isFavorited ? "heart.fill" : "heart")
                .font(.system(size: 22))
                .foregroundColor(model.isFavorited ? .red : .gray)
        }
    }

    struct MiddleRow: View {
        let width: CGFloat
        let meditation: Meditation
        let viewRouter: ViewRouter
        let model: MeditationViewModel
        let didComplete: Bool
        @Binding var tappedMeditation: Bool
        @State var isFavorited: Bool = false
        let idx: Int

        var body: some View {
            Button {
                tappedMeditation = true
                model.selectedMeditation = meditation
                withAnimation {
                    viewRouter.currentPage = .play
                }
            } label: {
                HStack {
                    Text("\(idx + 1).")
                        .foregroundColor(Clr.darkgreen)
                        .font(Font.mada(.semiBold, size: 22))
                        .padding(.trailing, 3)
                    Text(meditation.title)
                        .foregroundColor(Clr.black2)
                        .font(Font.mada(.semiBold, size: 20))
                        .lineLimit(1)
                        .minimumScaleFactor(0.05)
                    Spacer()
                    if didComplete {
                        Image(systemName: "checkmark.circle.fill")
                            .renderingMode(.template)
                            .foregroundColor(Clr.darkgreen)
                            .font(.system(size: 24))
                            .padding(.horizontal, 10)
                    } else {
                        Image(systemName: "play.fill")
                            .foregroundColor(Clr.darkgreen)
                            .font(.system(size: 24))
                            .padding(.horizontal, 10)
                    }

                    Image(systemName: isFavorited ? "heart.fill" : "heart")
                        .foregroundColor(isFavorited ? Color.red : Color.gray)
                        .font(.system(size: 24))
                        .onTapGesture {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            model.favorite(selectMeditation: meditation)
                            isFavorited.toggle()
                        }
                }
            }
            .padding(5)
            .frame(width: width)
            .onAppear {
                isFavorited = model.favoritedMeditations.contains { $0 == meditation}
            }
        }
    }
}

@available(iOS 14.0, *)
struct MiddleSelect_Previews: PreviewProvider {
    static var previews: some View {
        MiddleSelect()
            .environmentObject(MeditationViewModel())
            .environmentObject(ViewRouter())
    }
}
