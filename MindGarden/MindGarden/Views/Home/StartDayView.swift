//
//  StartDayView.swift
//  MindGarden
//
//  Created by Vishal Davara on 04/07/22.
//

import SwiftUI

struct StartDayView: View {
    @Binding var activeSheet: Sheet?
    @Binding var selectedMood: NewMood
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
                        .frame(width:18,height: 18)
                        .addBorder(Color.black.opacity(0.2), width: 1.5, cornerRadius: 14)
                    DottedLine()
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [10]))
                        .opacity(0.5)
                        .frame(width:2)
                    Circle()
                        .fill(.white)
                        .frame(width:18,height: 18)
                        .addBorder(Color.black.opacity(0.2), width: 1.5, cornerRadius: 14)
                    DottedLine()
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [10]))
                        .opacity(0.5)
                        .frame(width:2)
                    Circle()
                        .fill(.white)
                        .frame(width:18,height: 18)
                        .addBorder(Color.black.opacity(0.2), width: 1.5, cornerRadius: 14)
                }
                .padding()
                .padding(.vertical,50)
                VStack(spacing:30) {
                    ZStack {
                        Img.whiteClouds
                            .resizable()
                            .frame(height:170)
                            .aspectRatio(contentMode: .fill)
                        
                        VStack {
                            Spacer()
                            VStack {
                                Text("How are you feeling?")
                                    .foregroundColor(Clr.brightGreen)
                                    .font(Font.fredoka(.semiBold, size: 12))
                                HStack(alignment:.top) {
                                    ForEach(NewMood.allCases, id: \.id) { item in
                                        Button {
                                            selectedMood = item
                                            activeSheet = .mood
                                        } label: {
                                            VStack(spacing:0) {
                                                item.moodImage
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(maxWidth:80)
                                                Text(item.title)
                                                    .foregroundColor(.black)
                                                    .font(Font.fredoka(.regular, size: 8))
                                            }
                                            .padding(.bottom,10)
                                        }
                                    }
                                }.padding(.horizontal, 5)
                            }
                            .padding(5)
                            .background(Clr.darkWhite.addBorder(Color.black, width: 1.5, cornerRadius: 14))
                            
                        }
                        
                    }
                    .addBorder(Color.black, width: 1.5, cornerRadius: 14)
                    
                    ZStack {
                        Rectangle().fill(Clr.yellow)
                            .frame(height:150)
                            .addBorder(Color.black, width: 1.5, cornerRadius: 14)
                    }
                    ZStack {
                        Rectangle().fill(Clr.yellow)
                            .frame(height:150)
                            .addBorder(Color.black, width: 1.5, cornerRadius: 14)
                    }
                }
            }
        }
        .padding(.horizontal,30)
    }
}
