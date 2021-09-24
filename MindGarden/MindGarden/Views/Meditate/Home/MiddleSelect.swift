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
                                        Img.daisy
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: g.size.width/3, height: g.size.height/6)
                                        VStack(alignment: .leading) {
                                            Text("Anxiety and Stress")
                                                .foregroundColor(Clr.black2)
                                                .font(Font.mada(.semiBold, size: 28))
                                                .lineLimit(2)
                                                .minimumScaleFactor(0.05)
                                            Text("Description Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, ")
                                                .foregroundColor(Clr.black2)
                                                .font(Font.mada(.regular, size: 16))
                                                .padding(.trailing)
                                        }.frame(width: g.size.width/1.7)
                                        .padding(.vertical, 5)
                                    }
                                    .padding()
                                    .frame(width: g.size.width)
                                        Divider().padding()
                                        VStack {
                                            ForEach(model.selectedMeditations, id: \.self) { meditation in
                                                MiddleRow(width: g.size.width/1.2, meditation: meditation, viewRouter: viewRouter, model: model, tappedMeditation: $tappedMeditation)
                                            }
                                        }
                                        Divider().padding()
                                        HStack(spacing: 15) {
                                            Button {

                                            } label: {
                                                HomeSquare(width: g.size.width, height: g.size.height, img: Img.daisy, title: "Timed Meditation", id: 0, description: "", duration: 15)
                                            }.buttonStyle(NeumorphicPress())
                                            Button {

                                            } label: {
                                                HomeSquare(width: g.size.width, height: g.size.height, img: Img.daisy, title: "Timed Meditation", id: 1, description: "",  duration: 15)
                                            }.buttonStyle(NeumorphicPress())
                                        }.padding(.top)
                                    }
                                }
                        }
                        }.zIndex(25)
                }
            }.animation(nil)
            .navigationBarTitle("")
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
            print("tap tap")
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
        @Binding var tappedMeditation: Bool
        @State var isFavorited: Bool = false
        var body: some View {
            Button {
                tappedMeditation = true
                model.selectedMeditation = meditation
                withAnimation {
                    viewRouter.currentPage = .play
                }
            } label: {
                HStack {
                    Text(meditation.title)
                        .foregroundColor(Clr.black2)
                        .font(Font.mada(.semiBold, size: 22))
                        .lineLimit(1)
                        .minimumScaleFactor(0.05)
                    Spacer()
                    Image(systemName: "play.fill")
                        .foregroundColor(Clr.darkgreen)
                        .font(.system(size: 24))
                        .padding(.horizontal, 10)
                    Image(systemName: isFavorited ? "heart.fill" : "heart")
                        .foregroundColor(isFavorited ? Color.red : Color.gray)
                        .font(.system(size: 24))
                        .onTapGesture {
                            model.favorite(selectMeditation: meditation)
                            isFavorited.toggle()
                        }
                }
            }
            .padding(8)
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
