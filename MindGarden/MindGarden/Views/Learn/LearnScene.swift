//
//  LearnScene.swift
//  MindGarden
//
//  Created by Dante Kim on 2/18/22.
//

import OneSignal
import SwiftUI

struct LearnScene: View {
    
    // MARK: - Properties
    
    @State private var meditationCourses: [LearnCourse] = []
    @State private var lifeCourses: [LearnCourse] = []
    @State private var showCourse: Bool = false
    @State private var selectedSlides: [Slide] = []
    @State private var learnCourse: LearnCourse = .init(id: 0, title: "", img: "", description: "", duration: "", category: "", slides: [Slide(topText: "", img: "", bottomText: "")])
    @State private var isNotifOn = false
    @State private var completedCourses = [Int]()
    
    @EnvironmentObject var bonusModel: BonusViewModel

    // MARK: - Body
    
    var body: some View {
        ZStack {
            Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
            GeometryReader { g in
                let width = g.size.width
                let height = g.size.height + (K.hasNotch() ? 0 : 50)
                ZStack {
                    ScrollView(showsIndicators: false) {
                        LazyVStack {
                            ZStack {
                                Rectangle()
                                    .fill(Clr.darkWhite)
                                    .cornerRadius(24)
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Clr.darkgreen, lineWidth: 3)
                                HStack(spacing: 5) {
                                    Img.books
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: width * 0.3)
                                    VStack(alignment: .leading) {
                                        Text("The Library")
                                            .font(Font.fredoka(.bold, size: 32))
                                            .foregroundColor(Clr.black1)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                            .offset(x: -3)
                                        Text("Master your mind with our science backed mini-courses ⬇️")
                                            .font(Font.fredoka(.medium, size: 14))
                                            .foregroundColor(Clr.black1)
                                            .lineLimit(2)
                                            .minimumScaleFactor(0.5)
                                    } //: VStack
                                } //: HStack
                                .padding(10)
                            } //: ZStack
                            .frame(height: height * 0.15, alignment: .center)
                            .padding(.horizontal, 28)
                            
                            ZStack {
                                Rectangle()
                                    .fill(Clr.darkWhite)
                                    .cornerRadius(24)
                                    .neoShadow()
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Clr.brightGreen, lineWidth: 3)
                                Rectangle()
                                    .fill(Clr.brightGreen)
                                    .frame(width: width * 0.55, height: 40)
                                    .cornerRadius(24, corners: [.topLeft, .bottomRight, .topRight])
                                    .overlay(
                                        Text("Learning Mindfulness")
                                            .font(Font.fredoka(.semiBold, size: 16))
                                            .foregroundColor(.white)
                                            .minimumScaleFactor(0.5)
                                            .lineLimit(1)
                                    )
                                    .position(x: width * 0.272, y: 0)
                                LazyHStack {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 20) {
                                            ForEach(meditationCourses, id: \.self) { course in
                                                LearnCard(width: width, height: height, course: course, showCourse: $showCourse, learnCourse: $learnCourse, completedCourses: $completedCourses)
                                            } //: ForEach Loop
                                        } //: HStack
                                        .frame(height: height * 0.325 + 15)
                                        .padding([.leading, .trailing], g.size.width * 0.07)
                                    } //: ScrollView
                                    .frame(width: width * 0.85, height: height * 0.275, alignment: .center)
                                } //: LazyHStack
                            } //: ZStack
                            .frame(width: width * 0.85, height: height * 0.275, alignment: .center)
                            .padding(.top, 40)
                            
                            ZStack {
                                Rectangle()
                                    .fill(Clr.darkWhite)
                                    .cornerRadius(24)
                                    .neoShadow()
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Clr.yellow, lineWidth: 3)
                                Rectangle()
                                    .fill(Clr.yellow)
                                    .frame(width: width * 0.55, height: 40)
                                    .cornerRadius(24, corners: [.topLeft, .bottomRight, .topRight])
                                    .overlay(
                                        Text("Building Life Skills")
                                            .font(Font.fredoka(.semiBold, size: 16))
                                            .foregroundColor(.black)
                                            .minimumScaleFactor(0.5)
                                            .lineLimit(1)
                                    )
                                    .position(x: width * 0.272, y: 0)
                                LazyHStack {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 20) {
                                            ForEach(lifeCourses, id: \.self) { course in
                                                LearnCard(width: width, height: height, course: course, showCourse: $showCourse, learnCourse: $learnCourse, completedCourses: $completedCourses)
                                            }
                                        } //: HStack
                                        .frame(height: height * 0.325 + 15)
                                        .padding([.leading, .trailing], g.size.width * 0.07)
                                    } //: ScrollView
                                    .frame(width: width * 0.85, height: height * 0.275, alignment: .center)
                                } //: LazyHStack
                            } //: ZStack
                            .frame(width: width * 0.85, height: height * 0.275, alignment: .center)
                            .padding(.top, 40)
                            Spacer()
                                .frame(height: 60)
                        } //: LazyVStack
                        .frame(width: width, alignment: .center)
                        .padding(.top, 25)
                        .padding(.bottom, g.size.height * (K.hasNotch() ? 0.1 : 0.25))
                    } //: ScrollView
                    .frame(height: height)
                } //: ZStack
            } //: GeometryReader
        } //: ZStack
        .fullScreenCover(isPresented: $showCourse) {
            CourseScene(course: $learnCourse, completedCourses: $completedCourses)
        }
        .onAppear {
            DispatchQueue.main.async {
                if let comCourses = UserDefaults.standard.array(forKey: "completedCourses") as? [Int] {
                    completedCourses = comCourses
                }
                isNotifOn = DefaultsManager.standard.value(forKey: .isNotifOn).boolValue
//                UserDefaults.standard.bool(forKey: "isNotifOn")
                for course in LearnCourse.courses {
                    if course.category == "meditation" {
                        meditationCourses.append(course)
                    } else {
                        lifeCourses.append(course)
                    }
                }
            }
        }
        .onAppearAnalytics(event: .screen_load_learn)
    }

    struct LearnCard: View {
        
        // MARK: - Properties
        
        let width, height: CGFloat
        let course: LearnCourse
        @Binding var showCourse: Bool
        @Binding var learnCourse: LearnCourse
        @Binding var completedCourses: [Int]
        @State var completed = false
        
        // MARK: - Body
        
        var body: some View {
            Button {} label: {
                Rectangle()
                    .fill(Clr.darkWhite)
                    .cornerRadius(16)
                    .overlay(
                        ZStack {
                            VStack(alignment: .leading, spacing: 0) {
                                UrlImageView(urlString: course.img)
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(16)
                                    .frame(width: width * 0.55, height: height * 0.2)
                            } //: VStack
                            .opacity(completed ? 0.5 : 1)
                            if completed {
                                Capsule()
                                    .fill(Clr.yellow)
                                    .overlay(
                                        HStack(spacing: 2) {
                                            Text("Completed")
                                                .font(Font.fredoka(.semiBold, size: 12))
                                                .minimumScaleFactor(0.05)
                                                .lineLimit(1)
                                                .foregroundColor(.black)
                                            Image(systemName: "checkmark.seal.fill")
                                                .foregroundColor(Clr.brightGreen)
                                                .frame(width: 24)
                                        } //: HStack
                                        .padding(3)
                                    )
                                    .padding(3)
                                    .frame(width: 100, height: 40)
                                    .position(x: 70, y: 40)
                                    .rightShadow()
                            }
                        } //: ZStack
                        .onTapGesture {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            if course.category == "meditation" {
                                Analytics.shared.log(event: .learn_tapped_meditation_course)
                            } else {
                                Analytics.shared.log(event: .learn_tapped_life_course)
                            }
                            learnCourse = course
                            showCourse = true
                        }
                    )
            } //: Button
            .buttonStyle(NeumorphicPress())
            .frame(width: width * 0.55, height: height * 0.175)
            .cornerRadius(16)
            .onAppear {
                completed = completedCourses.contains(where: { $0 == course.id })
            }
        }
    } //: LearnCard View
}

extension LearnScene {
    private func promptNotif() {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { permission in
            switch permission.authorizationStatus {
            case .authorized:
                DefaultsManager.standard.set(value: true, forKey: .isNotifOn)
                Analytics.shared.log(event: .notification_success_learn)
                if DefaultsManager.standard.value(forKey: .oneDayNotif).isNil
//                    UserDefaults.standard.value(forKey: "oneDayNotif") == nil
                {
                    NotificationHelper.addOneDay()
                }
                if DefaultsManager.standard.value(forKey: .threeDayNotif).isNil
//                    UserDefaults.standard.value(forKey: "threeDayNotif") == nil
                {
                    NotificationHelper.addThreeDay()
                }
                if DefaultsManager.standard.value(forKey: .freeTrial).boolValue
//                    UserDefaults.standard.bool(forKey: "freeTrial")
                {
                    NotificationHelper.freeTrial()
                }
                DefaultsManager.standard.set(value: true, forKey: .notifOn)
                isNotifOn = true
            case .denied:
                Analytics.shared.log(event: .notification_settings_learn)
                DispatchQueue.main.async {
                    if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                        UIApplication.shared.open(appSettings)
                        DefaultsManager.standard.set(value: true, forKey: .isNotifOn)
                    }
                }
            case .notDetermined:
                Analytics.shared.log(event: .notification_settings_learn)
                DispatchQueue.main.async {
                    if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                        UIApplication.shared.open(appSettings)
                        DefaultsManager.standard.set(value: true, forKey: .isNotifOn)
                    }
                }
            default:
                print("Unknow Status")
            }
        })
    }
}

struct LearnScene_Previews: PreviewProvider {
    static var previews: some View {
        LearnScene()
    }
}
