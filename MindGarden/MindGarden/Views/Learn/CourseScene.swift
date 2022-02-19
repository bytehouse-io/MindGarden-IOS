//
//  CourseScene.swift
//  MindGarden
//
//  Created by Dante Kim on 2/18/22.
//

import SwiftUI

struct CourseScene: View {
    @State var viewState = CGSize.zero

    var body: some View {
        TabView {
            ForEach(LearnCourse.courses, id: \.self) { course in
                GeometryReader { proxy in
                    FeaturedItem(course: course)
                        .cornerRadius(30)
                        .modifier(OutlineModifier(cornerRadius: 30))
                        .rotation3DEffect(
                            .degrees(proxy.frame(in: .global).minX / -10),
                            axis: (x: 0, y: 1, z: 0), perspective: 1
                        )
                        .shadow(color: Color("Shadow").opacity(0.3),
                                radius: 30, x: 0, y: 30)
                        .blur(radius: abs(proxy.frame(in: .global).minX) / 40)
                        .overlay(
                            Img.bee
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .offset(x: 32, y: -80)
                                .frame(height: 230)
                                .offset(x: proxy.frame(in: .global).minX / 2)
                        )
                        .padding(20)
                        .onTapGesture {
//                            showCourse = true
//                            selectedCourse = course
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityAddTraits(.isButton)
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 460)
        .background(
            Image("Blob 1")
                .offset(x: 250, y: -100)
                .accessibility(hidden: true)
        )
//        .sheet(isPresented: $showCourse) {
//            CourseView(namespace: namespace, course: $selectedCourse, isAnimated: false)
//        }
    }
}

struct CourseScene_Previews: PreviewProvider {
    static var previews: some View {
        CourseScene()
    }
}

struct FeaturedItem: View {
    var course: LearnCourse
    @Environment(\.sizeCategory) var sizeCategory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Spacer()
            Img.bee
                .resizable()
                .frame(width: 26, height: 26)
                .cornerRadius(10)
                .padding(8)
                .cornerRadius(18)
                .modifier(OutlineOverlay(cornerRadius: 18))
            Text(course.title)
                .font(.title).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(course.duration)
                .font(.footnote.weight(.semibold))
            Text(course.description)
                .lineLimit(sizeCategory > .large ? 1 : 2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
        .frame(height: 350)
        .backgroundColor(opacity: 0.5)
    }
}

struct FeaturedItem_Previews: PreviewProvider {
    static var previews: some View {
        Group {
//            FeaturedItem(course: courses[0])
//            FeaturedItem(course: courses[0])
//                .environment(\.sizeCategory, .accessibilityLarge)
        }
    }
}
