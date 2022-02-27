//
//  LearnScene.swift
//  MindGarden
//
//  Created by Dante Kim on 2/18/22.
//

import SwiftUI

struct LearnScene: View {
    @State private var meditationCourses: [LearnCourse] = []
    @State private var showCourse: Bool = false
    @State private var selectedSlides: [Slide] = []
    @State private var courseTitle: String = ""
    
    var body: some View {
        ZStack {
            Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
            GeometryReader { g in
                let width = g.size.width
                let height = g.size.height + (K.hasNotch() ? 0 : 50)
                VStack {
                    ZStack {
                        Rectangle()
                            .fill(Clr.darkWhite)
                            .cornerRadius(20)
                            .neoShadow()
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Clr.darkgreen, lineWidth: 3)
                        HStack(spacing: 5) {
                            Img.books
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: width * 0.3)
                            VStack(alignment: .leading){
                                Text("The Library")
                                    .font(Font.mada(.bold, size: 32))
                                    .foregroundColor(Clr.black1)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                    .offset(x: -3)
                                Text("Master your mind with our science backed mini-courses")
                                    .font(Font.mada(.medium, size: 14))
                                    .foregroundColor(Clr.black1)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.5)
                            }
                        }.padding(10)
                    }.frame(width: width * 0.85, height: height * 0.15, alignment: .center)
                    ZStack {
                        Rectangle()
                            .fill(Clr.darkWhite)
                            .cornerRadius(20)
                            .neoShadow()
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Clr.brightGreen, lineWidth: 3)
                        Rectangle()
                            .fill(Clr.brightGreen)
                            .frame(width: width * 0.55, height: 40)
                            .cornerRadius(20, corners: [.topLeft, .bottomRight, .topRight])
                            .overlay(
                                Text("Understanding meditation")
                                    .font(Font.mada(.semiBold, size: 16))
                                    .foregroundColor(.white)
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                            )
                            .position(x: width * 0.272, y: 0)
                        HStack {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(meditationCourses, id: \.self) { course in
                                        LearnCard(width: width, height: height, course: course, showCourse: $showCourse, selectedSlides: $selectedSlides, courseTitle: $courseTitle)
                                    }
                                }.frame(height: height * 0.3 + 15)
                                    .padding([.leading, .trailing], g.size.width * 0.07)
                            }.frame(width: width * 0.85, height: height * 0.3, alignment: .center)
                        }
                    }.frame(width: width * 0.85, height: height * 0.3, alignment: .center)
                    .padding(.top, 40)
                    ZStack {
                        Rectangle()
                            .fill(Clr.darkWhite)
                            .cornerRadius(20)
                            .neoShadow()
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Clr.yellow, lineWidth: 3)
                        Rectangle()
                            .fill(Clr.yellow)
                            .frame(width: width * 0.55, height: 40)
                            .cornerRadius(20, corners: [.topLeft, .bottomRight, .topRight])
                            .overlay(
                                Text("Understanding meditation")
                                    .font(Font.mada(.semiBold, size:  16))
                                    .foregroundColor(.black)
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                            )
                            .position(x: width * 0.272, y: 0)
                        HStack {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(meditationCourses, id: \.self) { course in
                                        LearnCard(width: width, height: height, course: course, showCourse: $showCourse, selectedSlides: $selectedSlides, courseTitle: $courseTitle)
                                    }
                                }.frame(height: height * 0.3 + 15)
                                    .padding([.leading, .trailing], g.size.width * 0.07)
                            }.frame(width: width * 0.85, height: height * 0.3, alignment: .center)
                        }
                    }.frame(width: width * 0.85, height: height * 0.3, alignment: .center)
                    .padding(.top, 40)
                }.frame(width: width, alignment: .center)
                .padding(.top, K.hasNotch() ? 75 : 25)
            }
            if !UserDefaults.standard.bool(forKey: "day2") {
                Color.gray.edgesIgnoringSafeArea(.all).animation(nil).opacity(0.85)
                ZStack {
                    Rectangle()
                        .fill(Clr.darkWhite)
                        .cornerRadius(20)
                    (Text("🔐 This page will\nunlock on Day 2\nYou're on ").foregroundColor(Clr.black2)
                     + Text("Day \(UserDefaults.standard.integer(forKey: "day") )").foregroundColor(Clr.darkgreen))
                        .font(Font.mada(.bold, size: 24))
                        .multilineTextAlignment(.center)
                }.frame(width: UIScreen.main.bounds.width/1.5, height: UIScreen.main.bounds.height/2)
                .position(x: UIScreen.main.bounds.width/2, y: 300)
            }
            
        }
        .disabled(!UserDefaults.standard.bool(forKey: "day2"))
        .fullScreenCover(isPresented: $showCourse) {
            CourseScene(title: $courseTitle, selectedSlides: $selectedSlides)
        }
        .onAppear {
             for course in LearnCourse.courses {
                if course.category == "meditation" {
                    meditationCourses.append(course)
                } else {
                    meditationCourses.append(course)
                }
            }
        }
    }
    
    struct LearnCard: View {
        let width, height: CGFloat
        let course: LearnCourse
        @Binding var showCourse: Bool
        @Binding var selectedSlides: [Slide]
        @Binding var courseTitle: String
        
        var body: some View {
            Button {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                courseTitle = course.title
                selectedSlides = course.slides
                showCourse = true
            } label: {
               Rectangle()
                    .fill(Clr.darkWhite)
                    .cornerRadius(20)
                    .overlay(
                        VStack(alignment: .leading, spacing: 0) {
                            AsyncImage(url: URL(string: course.img)!,
                                          placeholder: { ProgressView() },
                                       image: {
                                $0.resizable()
                               })
                                .cornerRadius(20, corners: [.topRight, .topLeft])
                                .frame(width: width * 0.5, height: height * 0.13)
//                                  Text("The Power of Gratitude")
//                                                            .font(Font.mada(.semiBold, size: 16))
//                                                            .foregroundColor(Clr.black2)
//                                                            .padding(.leading, 10)
                            Spacer()
                            Text("3-5 min read")
                                .font(Font.mada(.medium, size: 14))
                                .foregroundColor(.gray)
                                .padding([.leading, .top], 10)
                            Text("🙏 Learn why gratitude is the most powerful human emotion")
                                .font(Font.mada(.medium, size: 12))
                                .foregroundColor(Clr.black1)
                                .padding(.horizontal, 10)
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                            Spacer()
                        }
                    )
            }.buttonStyle(NeumorphicPress())
            .frame(width: width * 0.5, height: height * 0.225)
            
        }
    }
}

struct LearnScene_Previews: PreviewProvider {
    static var previews: some View {
        LearnScene()
    }
}
