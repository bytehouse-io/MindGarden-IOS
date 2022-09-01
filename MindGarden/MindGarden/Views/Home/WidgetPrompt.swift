//
//  WidgetPrompt.swift
//  MindGarden
//
//  Created by Vishal Davara on 27/08/22.
//

import SwiftUI

struct WidgetPrompt: View {
    
    @State private var showNext = false
    @State private var currentStep = 0
    @State private var playAnim = false
    var body: some View {
        GeometryReader { geomatry in
            ZStack(alignment:.bottom) {
                Color.black.opacity(0.5)
                VStack {
                    Spacer()
                        .frame(height: 10)
                    
                    if showNext {
                        NextButtonView
                    } else {
                        
                        Text("MindGarden")
                            .font(Font.fredoka(.bold, size: 20))
                            .foregroundColor(Clr.black2)
                            .multilineTextAlignment(.center)
                        
                        Text("Add MindGarden widget to your home screen")
                            .font(Font.fredoka(.medium, size: 16))
                            .foregroundColor(Clr.black2)
                            .multilineTextAlignment(.center)
                            .padding()
//
//                        Img.widgetPrompt
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(height: geomatry.size.height*0.4)
//                            .cornerRadius(20).padding(.bottom, 20)
                        AddWidgetView
                    }
                    
                    Spacer()
                        .frame(height:20)
                }
                .frame(width: geomatry.size.width, height: geomatry.size.height*0.75)
                .background(Clr.darkWhite)
                .cornerRadius(20, corners:[.topLeft,.topRight])
                
                
                
            }.offset(y: playAnim ? 0 : 1000)
            .ignoresSafeArea()
                .onAppear {
                    withAnimation {
                        playAnim = true
                    }
            }
        }
    }
    
    var AddWidgetView: some View {
        VStack {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                withAnimation {
                    showNext = true
                }
            } label: {
                Rectangle()
                    .fill(Clr.yellow)
                    .overlay(
                        Text("Add Widget")
                            .foregroundColor(Clr.darkgreen)
                            .font(Font.fredoka(.bold, size: 20))
                    ).addBorder(Color.black, width: 1.5, cornerRadius: 20)
            }
            .frame(width:UIScreen.screenWidth*0.8, height: 40)
            .buttonStyle(NeumorphicPress())
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                noThanksTap()
            } label: {
                Rectangle()
                    .fill(Clr.yellow)
                    .overlay(
                        Text("No Thanks")
                            .foregroundColor(Clr.darkgreen)
                            .font(Font.fredoka(.bold, size: 20))
                    ).addBorder(Color.black, width: 1.5, cornerRadius: 20)
            }
            .frame(width:UIScreen.screenWidth*0.8, height: 40)
            .buttonStyle(NeumorphicPress())
            Spacer()
                .frame(height:20)
        }
    }
    
    var NextButtonView: some View {
            VStack {
                getImage()
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(20)
                    .padding(20)
                    .frame(width:UIScreen.screenWidth*0.8)
                ZStack {
                    Rectangle()
                        .fill(Clr.brightGreen.opacity(0.5))
                        .frame(height:5)
                        .padding()
                    HStack {
                        ForEach(0...3, id: \.self) {index in
                            ZStack {
                                Circle()
                                    .fill(Clr.darkgreen)
                                    .frame(width: 40, height: 40)
                                Text("\(index + 1)")
                                    .foregroundColor(.white)
                                    .font(Font.fredoka(.bold, size: 20))
                            }.scaleEffect(currentStep == index ? 1.2 : 1.0)
                            if index != 3 {
                            Spacer()
                            }
                        }
                    }
                }
                .padding(.bottom,20)
                .frame(width:UIScreen.screenWidth*0.60)
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    withAnimation {
                        currentStep+=1
                        if currentStep == 4 {
                            finishAllSteps()
                        }
                    }
                } label: {
                    Rectangle()
                        .fill(Clr.yellow)
                        .overlay(
                            Text("Next")
                                .foregroundColor(Clr.darkgreen)
                                .font(Font.fredoka(.bold, size: 20))
                        ).addBorder(Color.black, width: 1.5, cornerRadius: 20)
                }
                .frame(width:UIScreen.screenWidth*0.8, height: 40)
                .buttonStyle(NeumorphicPress())
                Spacer()
                    .frame(height:40)
            }
    }
    
    private func getImage()->Image {
        switch currentStep {
        case 0 :
            return Img.sleepingSloth
        case 1 :
            return Img.sleepingSloth
        case 2 :
            return Img.sleepingSloth
        default :
            return Img.sleepingSloth
        }
    }
    
    private func noThanksTap(){
        //TODO: no thanks button tap event
    }
    private func finishAllSteps(){
        //TODO: finish All Steps
    }
}
