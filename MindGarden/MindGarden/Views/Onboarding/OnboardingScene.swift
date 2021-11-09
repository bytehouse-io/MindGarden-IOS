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
    }
    let titles = ["Simple meditation that actually sticks", "Visualize Your Progress", "Collect all the flowers, fruits and trees!"]
    let subtitles = ["Stress less. Get 1% happier everyday by making meditation a lifestyle.", "Create your own beautiful MindGarden. (Tile color represents mood)", "Stay motivated, the longer you keep your streak alive the more coins you earn."]
    let images = [Img.pottedPlants, Img.gardenCalender, Img.packets]
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
                                ForEach((0..<3), id: \.self) { index in
                                    VStack {
                                            images[index]
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: width * 0.6 , height: height * (index == 0 ? 0.2 : 0.38))
                                                .padding()
                                            Spacer()
                                            VStack(alignment: .leading) {
                                                Text(titles[index])
                                                    .font(Font.mada(.bold, size: 42))
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
                                        }
                                    }.offset(y: index == 0 ? 0 : -20)
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                            .frame(width: width * 0.55, height: height * 0.75, alignment: .center)
                        } else {
                            // Fallback on earlier versions
                        }
                        Button {
                            Analytics.shared.log(event: .onboarding_tapped_continue)
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
                            Analytics.shared.log(event: .onboarding_tapped_sign_in)
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            tappedSignIn = true
                            withAnimation {
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
//                    .offset(y: K.isPad() ? 0 : g.size.height * -0.45)
                }
            }.navigationBarTitle("", displayMode: .inline)
        }.onAppearAnalytics(event: .screen_load_onboarding)
        .onAppear(perform: {
        })

    }
}

struct OnboardingScene_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScene()
    }
}
