//
//  OnboardingScene.swift
//  MindGarden
//
//  Created by Dante Kim on 6/6/21.
//

import SwiftUI

var tappedSignIn = false
struct OnboardingScene: View {
    @State private var index = 0
    @EnvironmentObject var viewRouter: ViewRouter
    init() {
        if #available(iOS 14.0, *) {
            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Clr.gardenGreen)
        } else {
            // Fallback on earlier versions
        }
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
//        UINavigationBar.appearance().shadowImage = UIImage()
    }
    let titles = ["Simple meditation that actually sticks", "Simple meditation that actually sticks"]
    let subtitles = ["Stress less. Get 1% happier everyday by making meditation your lifestyle.", "Stress less. Get 1% happier everyday by making meditation your lifestyle."]
    let images = [Img.pottedPlants, Img.morningSun]
    var body: some View {
        NavigationView {
            GeometryReader { g in
                let height = g.size.height
                let width = g.size.height
                ZStack(alignment: .center) {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                    VStack(alignment: .center) {
                        if #available(iOS 14.0, *) {
                            TabView(selection: $index) {
                                ForEach((0..<2), id: \.self) { index in
                                    VStack {
                                        images[index]
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: width * 0.6 , height: height * (index == 0 ? 0.2 : 0.25))
                                            .padding()
                                        Spacer()
                                        VStack(alignment: .leading) {
                                            Text(titles[index])
                                                .font(Font.mada(.bold, size: 44))
                                                .minimumScaleFactor(0.05)
                                                .lineSpacing(0)
                                                .padding(.bottom, 5)
                                                .foregroundColor(Clr.darkgreen)
                                            Text(subtitles[index])
                                                .minimumScaleFactor(0.05)
                                                .font(Font.mada(.medium, size: 18))
                                                .foregroundColor(Clr.black1)
                                                .lineSpacing(10)
                                        }
                                        .multilineTextAlignment(.leading)
                                        .offset(y: -20)
                                        .padding(10)
                                        .frame(width: width * 0.5)
                                        Spacer()
                                        Spacer()
                                    }.offset(y: index == 0 ? 0 : -20)
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                            .frame(width: width * 0.55, height: height * 0.7, alignment: .center)
                        } else {
                            // Fallback on earlier versions
                        }
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation {
                                viewRouter.currentPage = .experience
                            }
                        } label: {
                            Capsule()
                                .fill(Clr.yellow)
                                .overlay(
                                    Text("Continue")
                                        .foregroundColor(Clr.darkgreen)
                                        .font(Font.mada(.bold, size: 20))
                                )
                        }.frame(height: 50)
                        .padding()
                        .buttonStyle(NeumorphicPress())
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation {
                                tappedSignIn = true
                                viewRouter.currentPage = .authentication
                            }
                        } label: {
                            Capsule()
                                .fill(Clr.darkWhite)
                                .overlay(
                                    Text("Already have an account")
                                        .foregroundColor(Clr.darkgreen)
                                        .font(Font.mada(.bold, size: 20))
                                )
                        }.frame(height: 50)
                            .padding([.bottom, .horizontal])
                        .buttonStyle(NeumorphicPress())
                        Spacer()
                    }
                }
            }
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}

struct OnboardingScene_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScene()
    }
}
