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
                                        LearnCard(width: width, height: height, readTime: course.duration, description: course.description, img: course.img)
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
                                    ForEach(["1", "2"], id: \.self) { meditation in
                                        LearnCard(width: width, height: height, readTime: "3-5", description: "", img: "https://firebasestorage.googleapis.com/v0/b/mindgarden-b9527.appspot.com/o/powerofgratitude.png?alt=media&token=bdfc4943-dbe2-4d18-a123-b260a9801b54")
                                    }
                                }.frame(height: height * 0.3 + 15)
                                    .padding([.leading, .trailing], g.size.width * 0.07)
                            }.frame(width: width * 0.85, height: height * 0.3, alignment: .center)
                        }
                    }.frame(width: width * 0.85, height: height * 0.3, alignment: .center)
                    .padding(.top, 40)
                }.frame(width: width, alignment: .center)
                .padding(.top, 75)
            }
        }
        .fullScreenCover(isPresented: $showCourse) {
            CourseScene()
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
        let readTime: String
        let description: String
        let img: String
        
        var body: some View {
            Button {} label: {
               Rectangle()
                    .fill(Clr.darkWhite)
                    .cornerRadius(20)
                    .overlay(
                        VStack(alignment: .leading, spacing: 0) {
                            AsyncImage(url: URL(string: img)!,
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
