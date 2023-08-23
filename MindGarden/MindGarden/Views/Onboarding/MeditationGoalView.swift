//
//  MeditationGoalScene.swift
//  MindGarden
//
//  Created by apple on 18/04/23.
//

import SwiftUI


struct Goal: Identifiable, Hashable {
    enum GoalType {
        case seven
        case fourteen
        case thirty
        case fifty
    }
    
    var id = UUID()
    let type: GoalType
    
    var title: String {
        switch type {
        case .seven:
            return "7 Days"
        case .fourteen:
            return "14 Days"
        case .thirty:
            return "30 Days"
        case .fifty:
            return "50 Days"
        }
    }
    var description: String {
        switch type {
        case .seven:
            return "Great for beginners"
        case .fourteen:
            return "You're serious about this"
        case .thirty:
            return "Build a life-long habit"
        case .fifty:
            return "Become a master"
        }
    }
}

var goals: [Goal] = [
    Goal(type: .seven),
    Goal(type: .fourteen),
    Goal(type: .thirty),
    Goal(type: .fifty)
]

struct MeditationGoalView: View {
    
    // MARK: - Properties
    
    @State var isSelected: Bool = false
    @State var selectedGoal: Goal = .init(type: .seven)
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @EnvironmentObject var viewRouter: ViewRouter
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            GeometryReader { g in
                let width = g.size.width
                let height = g.size.height
                ZStack {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: -5) {
                        HStack {
                            Img.topBranch
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.screenWidth * 0.6)
                                .padding(.leading, -20)
                                .offset(x: -20, y: -10)
                            Spacer()
                            Image(systemName: "arrow.backward")
                                .font(.system(size: 22))
                                .foregroundColor(Clr.darkgreen)
                                .padding()
                                .onTapGesture {
                                    // Analytics.shared.log(event: .goalview_tapped_back)
                                    MGAudio.sharedInstance.playBubbleSound()
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    withAnimation {
                                        arr = []
                                        viewRouter.progressValue -= 0.1
                                        viewRouter.currentPage = .reason
                                    }
                                }.offset(x: -20, y: 20)

                        }.frame(width: width)
                        VStack {
                            // TITLE
                            Text("Select Your\nMeditation Goal")
                                .font(Font.fredoka(.bold, size: 28))
                                .foregroundColor(Clr.darkgreen)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .padding(.bottom, 15)
                            
                            // OPTIONS
                            ForEach(goals, id: \.self) { goal in
                                GoalDetailView(width: width, height: height, goal: goal, selectedGoal: $selectedGoal, isSelected: $isSelected)
                            }
                            
                            // IMAGE
                            Img.meditatingTurtle2
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: height * 0.15)
                                .padding(.vertical, 8)
                            
                            Spacer()
                            
                            // CONTINUE BUTTON
                            ContinueButton(
                                action: {
                                    withAnimation(.easeOut(duration: 0.5)) {
                                        DispatchQueue.main.async {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            MGAudio.sharedInstance.playBubbleSound()
                                            // Analytics.shared.log(event: .goalview_tapped_continue)
                                            viewRouter.progressValue += 0.1
                                            viewRouter.currentPage = .name
                                        }
                                    }
                                },
                                enabled: $isSelected
                            ) //: ContinueButton
                            .frame(width: width * 0.9)
                            Spacer()
                        }.frame(height: height * 0.85)
                    }.frame(width: width * 0.9)  //: VStack
                } //ZStack
            } //: GeometryReader
        }//VStack
        .transition(.move(edge: .trailing))
    }
}

#if DEBUG 
struct MeditationGoalView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationGoalView()
    }
}
#endif

struct GoalDetailView: View {
    
    // MARK: - Properties
    var width: CGFloat
    var height: CGFloat
    @State var goal: Goal
    @Binding var selectedGoal: Goal
    @Binding var isSelected: Bool
    
    // MARK: - Body
    
    var body: some View {
        Button {
            MGAudio.sharedInstance.playBubbleSound()
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            withAnimation {
//                switch goal.type {
//                case .seven:   // Analytics.shared.log(event: .goalview_tapped_7)
//                case .fourteen:  // Analytics.shared.log(event: .goalview_tapped_14)
//                case .thirty:  // Analytics.shared.log(event: .goalview_tapped_30)
//                case .fifty:  // Analytics.shared.log(event: .goalview_tapped_50)
//                }
                isSelected = true
                selectedGoal = goal
                DefaultsManager.standard.set(value: goal.title, forKey: .meditationGoal)
            }
        } label: {
            ZStack {
                // BACKGROUND COLOR
                Rectangle()
                    .fill(goal.id == selectedGoal.id ? Clr.brightGreen : Clr.darkWhite)
                
                HStack {
                    // DAYS
                    Text(goal.title)
                        .font(Font.fredoka(.semiBold, size: 20))
                        .foregroundColor(goal.id == selectedGoal.id ? .white : Clr.black2)
                        .lineLimit(1)
                        .minimumScaleFactor(0.05)
                    Spacer()
                    
                    // DESCRIPTION
                    Text(goal.description)
                        .font(Font.fredoka(.semiBold, size: 14))
                        .foregroundColor(goal.id == selectedGoal.id ? .white : Clr.black1)
                        .lineLimit(1)
                        .minimumScaleFactor(0.05)
                        
                } //: HStack
                .padding(.leading, 24)
                .padding(.trailing, 16)
            } //: ZStack
            .addBorder(.black, width: 1.5, cornerRadius: 12)
            .frame(height: height * 0.09)
            .neoShadow()
        } //: Button
        .buttonStyle(NeumorphicPress())
        .padding(.bottom, 12)
        .padding(.horizontal)
        .frame(width: width * 0.9)
    }
}
