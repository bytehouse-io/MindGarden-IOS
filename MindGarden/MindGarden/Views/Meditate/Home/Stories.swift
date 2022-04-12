//
//  Stories.swift
//  MindGarden
//
//  Created by Dante Kim on 3/31/22.
//

import SwiftUI
import Storyly
import WidgetKit

struct Stories: UIViewRepresentable {
    static var storylyViewProgrammatic = StorylyView()
//    @Binding var updateStoryly: Bool

    func makeUIView(context: UIViewRepresentableContext<Stories>) -> UIView {
        let view = UIView(frame: .zero)
        Stories.storylyViewProgrammatic.storylyInit = StorylyInit(storylyId: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjU2OTgsImFwcF9pZCI6MTA2MDcsImluc19pZCI6MTEyNTV9.zW_oJyQ7FTAXHw8MXnEeP4k4oOafFrDGKylUw81pi3I", segmentation: StorylySegmentation(segments: storylySegments))
        view.addSubview(Stories.storylyViewProgrammatic)
        Stories.storylyViewProgrammatic.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            Stories.storylyViewProgrammatic.widthAnchor.constraint(equalTo: view.widthAnchor),
            Stories.storylyViewProgrammatic.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        Stories.storylyViewProgrammatic.storyGroupIconBorderColorNotSeen = [UIColor.systemGreen, UIColor.systemYellow]
        Stories.storylyViewProgrammatic.storyGroupTextFont = UIFont(name: "Mada-Medium", size: 14)!
        Stories.storylyViewProgrammatic.storyGroupTextColor = UIColor.systemGray
        Stories.storylyViewProgrammatic.storyGroupSize = "small"
        Stories.storylyViewProgrammatic.delegate = StorylyManager.shared
        Stories.storylyViewProgrammatic.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        Stories.storylyViewProgrammatic.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        Stories.storylyViewProgrammatic.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        Stories.storylyViewProgrammatic.heightAnchor.constraint(equalToConstant: 120).isActive = true
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
//        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
        print("updating \(true)")
        Stories.storylyViewProgrammatic.refresh()
    }
    
}
