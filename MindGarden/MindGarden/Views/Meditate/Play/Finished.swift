//
//  Finished.swift
//  MindGarden
//
//  Created by Dante Kim on 7/10/21.
//

import SwiftUI

struct Finished: View {
    @EnvironmentObject var model: MeditationViewModel
    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { g in
                    Clr.darkWhite.edgesIgnoringSafeArea(.all)
                    Rectangle()
                        .fill(Clr.finishedGreen)
                        .frame(width: g.size
                                .width/1, height: g.size.height/1.8)
                        .offset(y: -g.size.height/4)
                    Img.greenBlob
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: g.size
                                .width/1, height: g.size.height/1.8)
                        .offset(x: g.size.width/6, y: -g.size.height/4)
                    HStack(alignment: .center) {
                        Spacer()
                        VStack(alignment: .center, spacing: 20) {
                            VStack {
                                Text("Minutes Meditated")
                                    .font(Font.mada(.semiBold, size: 28))
                                    .foregroundColor(.white)
                                    .onTapGesture {
                                        withAnimation {
                                            viewRouter.currentPage  = .garden
                                        }
                                    }
                                Text("87")
                                    .font(Font.mada(.bold, size: 70))
                                    .foregroundColor(.white)
                                HStack {
                                    Text("You received:")
                                        .font(Font.mada(.semiBold, size: 24))
                                        .foregroundColor(.white)
                                    Img.coin
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 20)
                                    Text("20!")
                                        .font(Font.mada(.bold, size: 24))
                                        .foregroundColor(.white)
                                        .offset(x: -5)
                                }.offset(y: -20)
                            }
                            Spacer()
                            VStack {
                                Text("With patience and mindfulness you were able to grow a daisy!")
                                    .font(Font.mada(.bold, size: 22))
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.05)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Clr.black1)
                                    .frame(height: g.size.height/12)
                                    .padding()
                                Img.daisyBadge
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: g.size.height/2.75)
                                    .padding(10)
                                Spacer()
                                HStack {
                                    Image(systemName: "heart")
                                        .font(.system(size: 36, weight: .bold))
                                        .foregroundColor(Clr.black1)
                                        .padding()
                                        .padding(.leading)
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(Clr.black1)
                                    Spacer()
                                    Button {
                                        withAnimation {
                                            viewRouter.currentPage = .garden
                                        }
                                    } label: {
                                        Capsule()
                                            .fill(Clr.yellow)
                                            .padding(.horizontal)
                                            .overlay(
                                                HStack {
                                                    Text("Finished")
                                                        .foregroundColor(Clr.black1)
                                                        .font(Font.mada(.bold, size: 22))
                                                    Image(systemName: "arrow.right")
                                                        .foregroundColor(Clr.black1)
                                                        .font(.system(size: 22, weight: .bold))
                                                }
                                            )
                                    }.buttonStyle(NeumorphicPress())
                                }.frame(width: g.size.width, height: g.size.height/12)
                                .padding()
                            }
                            .frame(height: g.size.height/2)
                        }
                        Spacer()
                    }.frame(width: g.size.width, height: g.size.height)
                    .offset(y: -40)
                }
            }
        }.transition(.move(edge: .trailing))
        .animation(.easeIn)
    }
}

struct Finished_Previews: PreviewProvider {
    static var previews: some View {
        Finished()
    }
}
