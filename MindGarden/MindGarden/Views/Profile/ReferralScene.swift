//
//  ReferralScene.swift
//  MindGarden
//
//  Created by Vishal Davara on 27/04/22.
//

import SwiftUI

struct ReferralScene: View {
    @State private var currentPage = 0
    let inviteContactTitle = "Invite Contacts"
    let shareLinkTitle = "🔗 Share Link"
    @Binding var numRefs: Int
    @State var index: Int = 0
    @State private var offset: CGFloat = 0
    
    var action: () -> ()
//
//    init(numRefs: Binding<Int>, action: () -> ()) {
//        UIPageControl.appearance().currentPageIndicatorTintColor = Clr.darkgreen.uiColor()
//        UIPageControl.appearance().pageIndicatorTintColor = Clr.lightGray.uiColor()
//        self.numRefs = numRefs
//        self.action = action
//    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Capsule()
                    .fill(Clr.darkWhite)
                    .padding(.horizontal)
                    .overlay(
                        HStack {
                            Img.wateringPot
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40, alignment: .center)
                            Text("\(numRefs) Referrals Sent")
                                .foregroundColor(Clr.black2)
                                .font(Font.mada(.semiBold, size: 20))
                        }
                    )
                    .frame(width: UIScreen.screenWidth * 0.7, height: 50)
                    .padding(.top, 30)
                    .neoShadow()
                let cardWidth = UIScreen.screenWidth*0.75
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(referralList) { item in
                            ZStack {
                                VStack(spacing: 5) {
                                    item.image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 175, height:  150, alignment: .center)
                                        .padding()
                                        .padding(.top, item.image == Img.venusBadge ? 50 : 30)
                                    VStack(spacing: -10) {
                                        Text(item.title)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Clr.black2)
                                            .font(Font.mada(.semiBold, size: 22))
                                            .frame(width: UIScreen.screenWidth * 0.5, height: 50)
                                            .minimumScaleFactor(0.05)
                                            .lineLimit(2)
                                            .padding(20)
                                        Text(item.subTitle)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Clr.black2)
                                            .font(Font.mada(.regular, size: 16))
                                            .frame(width: UIScreen.screenWidth * 0.6, height: 75, alignment: .top)
                                            .padding([.bottom, .horizontal])
                                    }.offset(y: -25)
                           
                                }
                                .padding()
                                
                            }.frame(width: cardWidth, height:UIScreen.screenHeight*0.45)
                                .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Clr.brightGreen, lineWidth: 6)
                            )
                            .background(Clr.darkWhite)
                            .cornerRadius(30)
                            .neoShadow()
                            .padding(.vertical)
                        }
                    }
                }
                .content.offset(x: self.offset)
                    .frame(width: cardWidth, height: nil, alignment: .leading)
                    .gesture(DragGesture()
                        .onChanged({ value in
                            self.offset = value.translation.width - cardWidth * CGFloat(self.index)
                        })
                        .onEnded({ value in
                            if abs(value.predictedEndTranslation.width) >= cardWidth / 2 {
                                var nextIndex: Int = (value.predictedEndTranslation.width < 0) ? 1 : -1
                                nextIndex += self.index
                                self.index = nextIndex.keepIndexInRange(min: 0, max: referralList.count - 1)
                            }
                        withAnimation { self.offset = (-cardWidth * CGFloat(self.index)) - CGFloat((self.index * 10)) }
                        })
                    )
                HStack(alignment:.center) {
                    ForEach(0..<referralList.count) { indx in
                        Circle()
                            .fill(indx == self.index ? Clr.brightGreen : Clr.gardenGray)
                            .frame(width: 8, height: 8)
                    }
                }
                
//                Button {
//                } label: {
//                    HStack {
//                        Text(inviteContactTitle)
//                            .foregroundColor(.white)
//                            .font(Font.mada(.semiBold, size: 16))
//                            .padding(.trailing)
//                            .lineLimit(1)
//                            .minimumScaleFactor(0.05)
//                    }
//                    .frame(width: UIScreen.screenWidth * 0.7, height:50)
//                    .background(Clr.darkgreen)
//                    .cornerRadius(25)
//                    .onTapGesture {
//
//                    }
//                }
//                .buttonStyle(BonusPress())
                Button { } label: {
                    HStack {
                        Text(shareLinkTitle)
                            .foregroundColor(.black)
                            .font(Font.mada(.semiBold, size: 16))
                            .padding(.trailing)
                            .lineLimit(1)
                            .minimumScaleFactor(0.05)
                    }
                    .frame(width: UIScreen.screenWidth * 0.7, height:50)
                    .background(Clr.yellow)
                    .cornerRadius(25)
                    .onTapGesture {
                        print("suns")
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        action()
                    }
                }
                .buttonStyle(BonusPress())
                .padding(.top)
                Text("The average user refers 2.3 people!")
                    .font(Font.mada(.regular, size: 18))
                    .foregroundColor(.black)
                    .opacity(0.4)
                Spacer()
            }
            
        }
    }
}


extension Int {
    func keepIndexInRange(min: Int, max: Int) -> Int {
        switch self {
            case ..<min: return min
            case max...: return max
            default: return self
        }
    }
}
