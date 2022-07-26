//
//  BreathMiddle.swift
//  MindGarden
//
//  Created by Dante Kim on 7/2/22.
//

import SwiftUI

struct BreathMiddle: View {
    @State var duration: Int = 300
    @State var isLiked: Bool = false
    let breathWork: Breathwork
    @State var showPlay = false
    
    var body: some View {
        if showPlay {
            BreathworkPlay(totalTime:$duration, showPlay:$showPlay, breathWork:breathWork)
                .transition(.opacity)
        } else  {
            breathMiddle
        }
    }
    
    var breathMiddle: some View {
        ZStack {
            Clr.darkWhite
                .edgesIgnoringSafeArea(.all)
            GeometryReader { g in
                let width = g.size.width
                let height = g.size.height
                VStack {
                    HStack {
                        Button {
                            Analytics.shared.log(event: .breathwrk_middle_tapped_back)
                        } label: {
                            Circle()
                                .fill(Clr.darkWhite)
                                .frame(width: 40)
                                .overlay(
                                    Image(systemName: "arrow.left")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 15)
                                )
                        }.buttonStyle(NeoPress())
                         .offset(x: -5, y: 5)
                        Spacer()
                        heart

                    }.frame(width: width - 60, height: 40)
                    HStack {
                        Img.sun
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        VStack(alignment: .leading) {
                            Text("Fall Asleep Fast")
                                .font(Font.fredoka(.semiBold, size: 28))
                            Text(breathWork.description)
                        }.foregroundColor(Clr.black2)
                        .frame(width: width * 0.6, alignment: .leading)
                    }.frame(width: width - 30, height: height * 0.2)
                    HStack() {
                        Spacer()
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            Analytics.shared.log(event: .breathwrk_middle_duration_1)
                            withAnimation {
                                duration = 30
                            }
                        } label: {
                            DurationButton(selected: $duration, duration: 30)
                        }.buttonStyle(NeoPress())
                        Spacer()
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            Analytics.shared.log(event: .breathwrk_middle_duration_3)
                            withAnimation {
                                duration = 60
                            }
                        } label: {
                            DurationButton(selected: $duration, duration: 1)
                        }.buttonStyle(NeoPress())
                        Spacer()
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            Analytics.shared.log(event: .breathwrk_middle_duration_5)
                            withAnimation {
                                duration = 180
                            }
                        } label: {
                            DurationButton(selected: $duration, duration: 3)
                        }.buttonStyle(NeoPress())
                        Spacer()
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            Analytics.shared.log(event: .breathwrk_middle_duration_10)
                            withAnimation {
                                duration = 300
                            }
                        } label: {
                            DurationButton(selected: $duration, duration: 5)
                        }.buttonStyle(NeoPress())
                        Spacer()
                    }.frame(width: width - 15)
                    
                    HStack {
                        Spacer()
                        BreathSequence(sequence: breathWork.sequence, width: width, height: height)
                        Spacer()
                    }
                    Button {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.linear) {
                                showPlay = true
                            }
                        }
                    } label: {
                        ZStack {
                            Rectangle()
                                .fill(Clr.yellow)
                                .addBorder(Color.black, width: 1.5, cornerRadius: 14)
                            HStack {
                                Text("Start Breathwork")
                                    .font(Font.fredoka(.bold, size: 20))
                                Image(systemName: "arrow.right")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                VStack(alignment: .leading) {
                                    Text("Fall Asleep Fast")
                                        .font(Font.fredoka(.semiBold, size: 28))
                                    Text(breathWork.description)
                                        .font(Font.fredoka(.regular, size: 16))
                                }.foregroundColor(Clr.black2)
                                    .frame(width: width * 0.55, alignment: .leading)
                            }.frame(width: width - 60, height: height * 0.2)
                            HStack() {
                                Spacer()
                                Button {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    Analytics.shared.log(event: .breathwrk_middle_duration_1)
                                    withAnimation {
                                        duration = 30
                                    }
                                } label: {
                                    DurationButton(selected: $duration, duration: 30)
                                }.buttonStyle(NeoPress())
                                Spacer()
                                Button {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    Analytics.shared.log(event: .breathwrk_middle_duration_3)
                                    withAnimation {
                                        duration = 60
                                    }
                                } label: {
                                    DurationButton(selected: $duration, duration: 1)
                                }.buttonStyle(NeoPress())
                                Spacer()
                                Button {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    Analytics.shared.log(event: .breathwrk_middle_duration_5)
                                    withAnimation {
                                        duration = 180
                                    }
                                } label: {
                                    DurationButton(selected: $duration, duration: 3)
                                }.buttonStyle(NeoPress())
                                Spacer()
                                Button {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    Analytics.shared.log(event: .breathwrk_middle_duration_10)
                                    withAnimation {
                                        duration = 300
                                    }
                                } label: {
                                    DurationButton(selected: $duration, duration: 5)
                                }.buttonStyle(NeoPress())
                                Spacer()
                            }.frame(width: width - 15)
                            
                            HStack {
                                Spacer()
                                BreathSequence(sequence: breathWork.sequence, width: width, height: height)
                                Spacer()
                            }
                            Button {
                                
                            } label: {
                                ZStack {
                                    Rectangle()
                                        .fill(Clr.yellow)
                                        .addBorder(Color.black, width: 1.5, cornerRadius: 32)
                                    HStack {
                                        Text("Start Breathwork")
                                            .font(Font.fredoka(.bold, size: 20))
                                        Image(systemName: "arrow.right")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .font(Font.title.weight(.bold))
                                            .frame(width: 20)
                                    }.foregroundColor(Clr.black2)
                                    
                                }.frame(width: width - 45, height: 50)
                            }.buttonStyle(NeoPress())
                            (Text("💡 Tip: ").bold() + Text(breathWork.tip))
                                .font(Font.fredoka(.medium, size: 16))
                                .foregroundColor(Clr.black2)
                                .frame(width: width - 60, height: 70, alignment: .leading)
                            //MARK: - Recommended Use
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Recommended Use")
                                    .font(Font.fredoka(.semiBold, size: 20))
                                    .foregroundColor(Clr.black2)
                                VStack {
                                    WrappingHStack(list: breathWork.recommendedUse, geometry: g)
                                        .offset(x: -7)
                                }
                            }.frame(width: width - 60, alignment: .leading)
                                .offset(y: -15)
                            Spacer()
                        }
                    }
                }.padding(.top, K.hasNotch() ? 50 : 25)
            }
            
        }
    }
    
    var heart: some View {
        LikeButton(isLiked: isLiked) {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            Analytics.shared.log(event: .breathwrk_middle_favorited)
        }
    }
    
    struct DurationButton: View {
        @Binding var selected: Int
        let duration: Int
        
        var body: some View {
            ZStack {
                let width = UIScreen.screenWidth
                Rectangle()
                    .fill((duration * 60 == selected || selected == duration) ? Clr.yellow : Clr.darkWhite)
                    .addBorder(Color.black, width: 1.5, cornerRadius: 14)
                    .frame(width: width/5.5, height: width/5.5)
                VStack(spacing: -5) {
                    Text(String(duration))
                        .font(Font.fredoka(.semiBold, size: 32))
                    Text(duration == 30 ? "sec" : "min")
                        .font(Font.fredoka(.medium, size: 20))
                }.foregroundColor(Clr.black2)
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
                    .opacity(0.4)
                    .addBorder(Color.black, width: 1.5, cornerRadius: 14)
                    .padding(.horizontal, 15)
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

struct WrappingHStack: View {
    let list: [String]
    let geometry: GeometryProxy
    
    var body: some View {
        self.generateContent(in: geometry)
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(self.list, id: \.self) { platform in
                self.item(for: platform)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width - 40)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if platform == self.list.first! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if platform == self.list.first! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
    }
    
    func item(for text: String) -> some View {
        Text(text)
            .font(Font.fredoka(.medium, size: 16))
            .foregroundColor(Clr.black2)
            .padding(.horizontal, 15)
            .padding(.vertical, 5)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.black, lineWidth: 1.5)
            )
    }
}
