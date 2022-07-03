//
//  BreathMiddle.swift
//  MindGarden
//
//  Created by Dante Kim on 7/2/22.
//

import SwiftUI

struct BreathMiddle: View {
    @State var duration: Int
    let breathWork: Breathwork
    var body: some View {
        ZStack {
            Clr.darkWhite
            GeometryReader { g in
                let width = g.size.width
                let height = g.size.height
                VStack(alignment: .center) {
                    Text("Hello, World!1")
                    HStack {
                        
                    }
                    HStack {
                        Spacer()
                        BreathSequence(sequence: breathWork.sequence, width: width, height: height)
                        Spacer()
                    }
                }
            }
        
        }
    }
    
    //MARK: - Breath Sequence
    struct BreathSequence:  View {
        let sequence: [(Int,String)]
        let width, height: CGFloat
        
        var body: some View {
            ZStack {
                Rectangle()
                    .fill(Clr.calmPrimary)
                    .frame(height: height * 0.2)
                    .addBorder(Color.black, width: 1.5, cornerRadius: 14)
                    .padding(.horizontal, 15)
                    .opacity(0.4)
                VStack {
                    Text("Breath Sequence")
                        .font(Font.fredoka(.semiBold, size: 20))
                    HStack {
                        // inhale
                        VStack(spacing: 3) {
                            Image(systemName: "nose")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 35, height: 35)
                            HStack(spacing: 15) {
                                Image(systemName: "line.diagonal.arrow")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 12)
                                    .rotationEffect(sequence[0].1 == "e" ? .degrees(180) : .degrees(0))
                                Image(systemName: "line.diagonal.arrow")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 12)
                                    .rotationEffect(.degrees(270))
                                    .rotationEffect(sequence[0].1 == "e" ? .degrees(180) : .degrees(0))
                            }.foregroundColor(Clr.calmsSecondary)
                            VStack(spacing: -3) {
                                Text("3")
                                    .font(Font.fredoka(.semiBold, size: 16))
                                Text(sequence[0].1 == "i" ? "Inhale" : "Exhale")
                                    .font(Font.fredoka(.regular, size: 16))
                            }.offset(y: -7)
                        }
                        if sequence[1].0 != 0 {
                            Spacer()
                            // hold
                            VStack(spacing: 3) {
                                Image(systemName: "pause.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 35)
                                    .offset(y: -5)
                          
                                VStack(spacing: -3) {
                                    Text("3")
                                        .font(Font.fredoka(.semiBold, size: 16))
                                    Text("Hold")
                                        .font(Font.fredoka(.regular, size: 16))
                                }
                            }
                        }
                        Spacer()
                        VStack(spacing: 3) {
                            mouth
                            HStack(spacing: 15) {
                                Image(systemName: "line.diagonal.arrow")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 12)
                                    .rotationEffect(sequence[2].1 == "e" ? .degrees(180) : .degrees(0))
                                Image(systemName: "line.diagonal.arrow")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 12)
                                    .rotationEffect(.degrees(270))
                                    .rotationEffect(sequence[2].1 == "e" ? .degrees(180) : .degrees(0))
                            }.foregroundColor(Clr.calmsSecondary)
                            VStack(spacing: -3) {
                                Text("3")
                                    .font(Font.fredoka(.semiBold, size: 16))
                                Text(sequence[2].1 == "i" ? "Inhale" : "Exhale")
                                    .font(Font.fredoka(.regular, size: 16))
                            }.offset(y: -7)
                        }
                    }.frame(width: width * 0.5)
                }.foregroundColor(Clr.black2)
            }

        }
        
        var mouth: some View {
             Image(systemName: "mouth")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 35, height: 35)
                .offset(y: 5)
        }
    }
    
}

struct BreathMiddle_Previews: PreviewProvider {
    static var previews: some View {
        BreathMiddle(breathWork: Breathwork.breathworks[0])
    }
}
