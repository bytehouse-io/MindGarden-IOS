//
//  StartDayView.swift
//  MindGarden
//
//  Created by Vishal Davara on 04/07/22.
//

import SwiftUI

struct StartDayView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var userModel: UserViewModel
    @Binding var activeSheet: Sheet?
    
    
    var body: some View {
        VStack {
            HStack {
                Text("Start your day")
                    .foregroundColor(Clr.brightGreen)
                    .font(Font.fredoka(.semiBold, size: 20))
                    .padding(.top,5)
                Spacer()
            }
            HStack {
                VStack {
                    Circle()
                        .fill(Clr.brightGreen)
                        .frame(width:24,height: 24)
                        .addBorder(Color.black.opacity(0.2), width: 1.5, cornerRadius: 14)
                    DottedLine()
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [10]))
                        .opacity(0.5)
                        .frame(width:2)
                    Circle()
                        .fill(.white)
                        .frame(width:24,height: 24)
                        .addBorder(Color.black.opacity(0.2), width: 1.5, cornerRadius: 16)
                    DottedLine()
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [10]))
                        .opacity(0.5)
                        .frame(width:2)
                    Circle()
                        .fill(.white)
                        .frame(width:24,height: 24)
                        .addBorder(Color.black.opacity(0.2), width: 1.5, cornerRadius: 16)
                }
                .padding(.vertical,50)
                VStack(spacing:30) {
                    ZStack {
                        Img.whiteClouds
                            .resizable()
                            .frame(height:170)
                            .aspectRatio(contentMode: .fill)
                            .opacity(0.9)
                        VStack {
                            Spacer()
                            VStack {
                                Text("How are you feeling?")
                                    .foregroundColor(Clr.brightGreen)
                                    .font(Font.fredoka(.semiBold, size: 16))
                                    .offset(y: 4)
                                HStack(alignment:.top) {
                                    ForEach(Mood.allCases(), id: \.id) { item in
                                        Button {
                                            withAnimation {
                                                userModel.selectedMood = item
                                                viewRouter.currentPage = .mood
                                            }                                         
                                        } label: {
                                            VStack(spacing:0) {
                                                Mood.getMoodImage(mood: item)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(maxWidth: 70)
                                                    .padding(.horizontal, 4)
                                            }.padding(.bottom,10)
                                        }
                                    }
                                }.padding(.horizontal, 10)
                            }.background(Clr.darkWhite.addBorder(Color.black, width: 1.5, cornerRadius: 8))
                        }
                    }
                    .frame(width: UIScreen.screenWidth * 0.775)
                    .addBorder(Color.black, width: 1.5, cornerRadius: 16)
                    .padding(.horizontal, 12)
                    
                    ZStack {
                        Rectangle().fill(Clr.yellow)
                            
                    }.frame(width: UIScreen.screenWidth * 0.775, height: 150)
                        .addBorder(Color.black, width: 1.5, cornerRadius: 16)
                        .padding(.horizontal, 12)
                    ZStack {
                        Rectangle().fill(Clr.yellow)
                            .frame(height:150)
                            .addBorder(Color.black, width: 1.5, cornerRadius: 14)
                    }.frame(width: UIScreen.screenWidth * 0.775)
                }
            }
        }.padding(.horizontal, 30)
    }
}
