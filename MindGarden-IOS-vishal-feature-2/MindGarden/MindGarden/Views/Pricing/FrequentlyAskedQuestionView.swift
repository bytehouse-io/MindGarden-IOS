//
//  FrequentlyAskedQuestionView.swift
//  MindGarden
//
//  Created by apple on 04/04/23.
//

import SwiftUI

struct FrequentlyAskedQuestionView: View {
    
    // MARK: - Properties
    var width: CGFloat
    
    @State private var question1 = false
    @State private var question2 = false
    @State private var question3 = false
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Text("🙋‍♂️ Frequent Asked Questions")
                .font(Font.fredoka(.bold, size: 22))
                .foregroundColor(Clr.black2)
                .multilineTextAlignment(.center)
                .padding(.vertical)
                .padding(.top, 10)
            Text("\(question1 ? "🔽" : "▶️") How does the pro plan help me?")
                .font(Font.fredoka(.bold, size: 18))
                .foregroundColor(Clr.black2)
                .multilineTextAlignment(.leading)
                .frame(width: width * 0.8, alignment: .leading)
                .onTapGesture {
                    MGAudio.sharedInstance.playBubbleSound()
                    withAnimation {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        question1.toggle()
                    }
                }

            if question1 {
                Text("Pro users are 72% more likely to stick with meditation vs non pro users. You have no limits for moods, gratitudes, and meditations. You feel invested, so you make sure to use the app daily.")
                    .font(Font.fredoka(.semiBold, size: 16))
                    .foregroundColor(Clr.black1)
                    .multilineTextAlignment(.leading)
                    .frame(width: width * 0.8, alignment: .leading)
                    .padding(.leading, 5)
            }
            Divider()
            Text("\(question2 ? "🔽" : "▶️") How do app subscriptions work?")
                .font(Font.fredoka(.bold, size: 18))
                .frame(width: width * 0.8, alignment: .leading)
                .foregroundColor(Clr.black2)
                .multilineTextAlignment(.leading)
                .onTapGesture {
                    MGAudio.sharedInstance.playBubbleSound()
                    withAnimation {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        question2.toggle()
                    }
                }
            if question2 {
                Text("With a subscription you pay access to pro features that last for either a month or a year. Yearly plans have a 7 day free trial where you won't be billed until the trial is over. Lifetime plans are paid once and last forever.")
                    .font(Font.fredoka(.semiBold, size: 16))
                    .foregroundColor(Clr.black1)
                    .multilineTextAlignment(.leading)
                    .frame(width: width * 0.8, alignment: .leading)
                    .padding(.leading, 5)
            }
            Divider()
            Text("\(question3 ? "🔽" : "▶️") How do I cancel my subscription?")
                .font(Font.fredoka(.bold, size: 18))
                .frame(width: width * 0.8, alignment: .leading)
                .foregroundColor(Clr.black2)
                .multilineTextAlignment(.leading)
                .onTapGesture {
                    MGAudio.sharedInstance.playBubbleSound()
                    withAnimation {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        question3.toggle()
                    }
                }
            if question3 {
                Text("You can easily cancel your subscription by going to the Settings App of your iphone and after selecting your apple ID, select subscriptions and simply click on MindGarden.")
                    .font(Font.fredoka(.semiBold, size: 16))
                    .foregroundColor(Clr.black1)
                    .multilineTextAlignment(.leading)
                    .frame(width: width * 0.8, alignment: .leading)
                    .padding(.leading, 5)
            }
            // LET US KNOW BUTTON
            Button {
                MGAudio.sharedInstance.playBubbleSound()
                guard let url = URL(string: "https://tally.so/r/3xRxkn") else { return }
                UIApplication.shared.open(url)
            } label: {
                HStack {
                    (Text("Are you a student & can't \nafford pro? ") + Text("Let us know").foregroundColor(Clr.brightGreen).bold()).multilineTextAlignment(.center)
                }.frame(width: width * 0.8)
                    .foregroundColor(Clr.black2)
            } //: Buttton
            .padding([.horizontal, .top])
            .padding(.top, 32)
        } //: VStack
//            .padding(.bottom, 25)
    }
}

struct FrequentlyAskedQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        FrequentlyAskedQuestionView(width: 300)
    }
}
