//
//  CourseScene.swift
//  MindGarden
//
//  Created by Dante Kim on 2/18/22.
//

import SwiftUI
import Lottie

struct CourseScene: View {
    @State var viewState = CGSize.zero
    @Environment(\.presentationMode) var presentationMode
    @State private var index = 0
    @State private var progressValue = 0.3
    @Binding var title: String
    @Binding var selectedSlides: [Slide]
    @State private var completed: Bool = false
    let lottieView = LottieView(fileName: "check", loopMode: .playOnce)

    var body: some View {
        ZStack {
            Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
            Img.pencil
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 75)
                .rotationEffect(.degrees(270))
                .position(x: 20, y: 35)
            Img.brain
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .position(x: 30, y: UIScreen.main.bounds.height * (K.isSmall() ? 0.75 : 0.7))
            Img.books
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .position(x: UIScreen.main.bounds.width - 30, y: UIScreen.main.bounds.height * (K.isSmall() ? 0.75 : 0.7))
            GeometryReader { g in
                let width = g.size.width
                VStack {
                    HStack {
                        lottieView
                            .frame(width: 75, height: 50)
                        Spacer()
                    }.frame(width: width, height: 50)
                    Text("💯 Great Job!")
                        .font(Font.mada(.bold, size: 40))
                        .foregroundColor(Clr.darkgreen)
                        .offset(x: 65, y: UIScreen.main.bounds.height * 0.55)
                } .offset(x: -width/6, y: completed ? 0 : UIScreen.main.bounds.height)
              
          
                VStack(){
                    Spacer()
                    HStack {
                        ZStack {}.frame(width: 50, height: 50)
                        .cornerRadius(25)
                        .opacity(0)
                        Spacer()
                        Text("\(title)")
                            .foregroundColor(Clr.black2)
                            .lineLimit(2)
                            .font(Font.mada(.bold, size: 24))
                            .frame(width: width - 125, alignment: .center)
                        Spacer()
                        Button {} label: {
                            ZStack {
                                Circle()
                                    .fill(Clr.darkWhite)
                                    .frame(width: 50, height: 50)
                                Image(systemName: "xmark")
                                    .foregroundColor(.gray)
                                    .frame(width: 50, height: 50)
                                    .padding()
                             
                            }.frame(width: 50, height: 50)
                            .cornerRadius(25)
                            .onTapGesture {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                presentationMode.wrappedValue.dismiss()
                            }
                        }.buttonStyle(NeumorphicPress())
                            .padding(.trailing)
                    }.frame(width: g.size.width - 75, height: 50)
                    TabView(selection: $index) {
                        ForEach(selectedSlides.indices, id: \.self) { idx in
                            GeometryReader { proxy in
                                FeaturedItem(slide: selectedSlides[idx])
                                    .modifier(OutlineModifier(cornerRadius: 30))
                                    .rotation3DEffect(
                                        .degrees(proxy.frame(in: .global).minX / -10),
                                        axis: (x: 0, y: 1, z: 0), perspective: 1
                                    )
                                    .blur(radius: abs(proxy.frame(in: .global).minX) / 40)
                                    .accessibilityElement(children: .combine)
                                    .neoShadow()
                            }
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(width: width, height: UIScreen.main.bounds.height * (K.isSmall() ? 0.65 : 0.55) + 50, alignment: .center)
                    .background(Color.clear)
                    .offset(y: !completed ? -25 : UIScreen.main.bounds.height)
        
                    Spacer()
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Clr.brightGreen)
                                .cornerRadius(25)
                                .frame(width: min(CGFloat(progressValue * (width * 0.65)), width * 0.65), height: 50)
                                .padding(.leading, 40)
                                .shadow(radius: 5)
                            HStack {
                            Button {} label: {
                                ZStack {
                                    Circle()
                                        .fill(Clr.darkWhite)
                                        .frame(width: 60, height: 60)
                                    Image(systemName: "chevron.left")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60)
                                        .foregroundColor(Clr.black2)
                                        .padding()
                                        .onTapGesture {
                                            withAnimation {
                                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                                index -= 1
                                                progressValue -= 1.0/Double(selectedSlides.count)
                                            }
                                        }
                                }.frame(width: 60, height: 60)
                                .cornerRadius(30)
                            }.buttonStyle(NeumorphicPress())
                            .padding()
                            Spacer()
                            Button {} label: {
                                ZStack {
                                    Circle()
                                        .fill(Clr.darkWhite)
                                        .frame(width: 60, height: 60)
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60)
                                        .foregroundColor(Clr.black2)
                                        .padding()
                                        .onTapGesture {
                                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                            withAnimation {
                                                index += 1
                                                progressValue += 1.0/Double(selectedSlides.count)
                                                if progressValue > 1.0 {
                                                    completed = true
                                                }
                                                lottieView.playAnimation()
                                            }
                                        }
                                }.frame(width: 60, height: 60)
                                .cornerRadius(30)
                            }.buttonStyle(NeumorphicPress())
                            .padding()
                        }
                    }.frame(width: width * 0.85, height: 80)
                    .background(Clr.darkWhite)
                    .cornerRadius(35)
                    .neoShadow()
                    Spacer()
                }.frame(width: g.size.width, height: g.size.height, alignment: .center)
            }
        }.onAppear {
            progressValue = 1.0/Double(selectedSlides.count)
        }
       
//        .background(
//            Img.bee
//                .offset(x: 250, y: -100)
//                .accessibility(hidden: true)
//        )
//        .sheet(isPresented: $showCourse) {
//            CourseView(namespace: namespace, course: $selectedCourse, isAnimated: false)
//        }
    }
}

struct CourseScene_Previews: PreviewProvider {
    static var previews: some View {
        CourseScene(title: .constant(""), selectedSlides: .constant([Slide]()))
    }
}

struct FeaturedItem: View {
    var slide: Slide
    @Environment(\.sizeCategory) var sizeCategory
    
    var body: some View {
        ZStack {
        VStack(alignment: .center, spacing: 8) {
            Text(slide.topText)
                .font(Font.mada(.semiBold, size: 18))
                .lineLimit(sizeCategory > .large ? 3 : 4)
                .frame(maxWidth:  UIScreen.main.bounds.width * 0.75, alignment: .leading)
                .padding(.horizontal)
                .minimumScaleFactor(0.5)
                .foregroundColor(Clr.black2)
                .padding(.top)
            AsyncImage(url: URL(string: slide.img)!,
                       placeholder: { ProgressView() },
                       image: {
                $0.resizable()
            })
                .aspectRatio(contentMode: .fit)
                .cornerRadius(20)
                .frame(width:  UIScreen.main.bounds.width * 0.8, height: 200)
                .padding(10)
                .neoShadow()
            Text(slide.bottomText)
                .font(Font.mada(.semiBold, size: 18))
                .lineLimit(sizeCategory > .large ? 3 : 4)
                .frame(maxWidth:  UIScreen.main.bounds.width * 0.75, alignment: .leading)
                .padding(.bottom)
                .minimumScaleFactor(0.5)
                .foregroundColor(Clr.black2)
        }
            RoundedRectangle(cornerRadius: 30)
                .stroke(Clr.brightGreen, lineWidth: 4)
        }.frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * (K.isSmall() ? 0.65 : 0.55) , alignment: .center)
            .background(Clr.darkWhite)
            .cornerRadius(30)
            .padding(.horizontal, 20)
            .padding(.vertical, 40)
    }
}

struct FeaturedItem_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
//        FeaturedItem(course: LearnCourse(title: "Bruno", img: "https://firebasestorage.googleapis.com/v0/b/mindgarden-b9527.appspot.com/o/powerofgratitude.png?alt=media&token=bdfc4943-dbe2-4d18-a123-b260a9801b54", description: "Testing testing one two three", duration: "3-5", category: "meditation"))
//            FeaturedItem(course: courses[0])
//                .environment(\.sizeCategory, .accessibilityLarge)
    }
}
