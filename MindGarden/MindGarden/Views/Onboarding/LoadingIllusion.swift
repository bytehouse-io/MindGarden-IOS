//
//  LoadingIllusion.swift
//  MindGarden
//
//  Created by Dante Kim on 6/24/22.
//

import SwiftUI

struct LoadingIllusion: View {
    @State private var showCircleProgress = true
    
    @State var meditateTimer: Timer?
    @State var time = 1.5
    @State var index = -1
    @State var topics = ["subtitle1",
                         "subtitle2",
                         "subtitle3",
                         "subtitle4",
                         "subtitle5"]
    
    var body: some View {
        CircleLoadingView(isShowing: $showCircleProgress) {
            ZStack(alignment:.bottom) {
                Clr.darkgreen
                HStack {
                    VStack(alignment:.leading) {
                        Text("Title")
                            .font(Font.mada(.bold, size: 30))
                            .foregroundColor(Clr.darkWhite)
                        if index >= 0 {
                            ForEach(0...index, id: \.self) { idx in
                                Text(topics[idx])
                                    .font(Font.mada(.bold, size: 20))
                                    .foregroundColor( idx == index ? .white : Clr.lightGray.opacity(0.5))
                            }
                        }
                        Spacer()
                            .frame(height:100)
                    }
                    Spacer()
                }
                .padding(50)
            }
        }.onAppear() {
            meditateTimer = Timer.scheduledTimer(withTimeInterval: time, repeats: true) { timer in
                withAnimation(.easeOut) {
                    index += 1
                    if index == topics.count-1 {
                        meditateTimer?.invalidate()
                    }
                }
            }
        }.onDisappear() {
            meditateTimer?.invalidate()
        }
    }
}

struct LoadingIllusion_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIllusion()
    }
}
