//
//  StorylyManager.swift
//  MindGarden
//
//  Created by Dante Kim on 3/31/22.
//
import Storyly

class StorylyManager: StorylyDelegate {
    static var shared = StorylyManager()
    
    func storylyLoaded(_ storylyView: Storyly.StorylyView,
                          storyGroupList: [Storyly.StoryGroup],
                          dataSource: StorylyDataSource) {
       }

       func storylyLoadFailed(_ storylyView: Storyly.StorylyView,
                              errorMessage: String) {
       }

       func storylyActionClicked(_ storylyView: Storyly.StorylyView,
                                 rootViewController: UIViewController,
                                 story: Storyly.Story) {
       }

       func storylyStoryPresented(_ storylyView: Storyly.StorylyView) {
       }

       func storylyStoryDismissed(_ storylyView: Storyly.StorylyView) {
       }

       func storylyUserInteracted(_ storylyView: Storyly.StorylyView,
                                  storyGroup: Storyly.StoryGroup,
                                  story: Storyly.Story,
                                  storyComponent: Storyly.StoryComponent) {
       }

       func storylyEvent(_ storylyView: Storyly.StorylyView,
                         event: Storyly.StorylyEvent,
                         storyGroup: Storyly.StoryGroup?,
                         story: Storyly.Story?,
                         storyComponent: Storyly.StoryComponent?) {
       }
}
