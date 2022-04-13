//
//  StorylyManager.swift
//  MindGarden
//
//  Created by Dante Kim on 3/31/22.
//
import Storyly
import Foundation

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
           if let group = storyGroup {
               print(group.title, "storyGroup")
           }
           
           if let story = story {
               print(story.seen, "nobody")
               if let _ = UserDefaults.standard.array(forKey: "storySegments") { } else {
                   UserDefaults.standard.setValue(["new users", "Bijan 11", "Quotes 9", "Story 7"], forKey: "storySegments")
               }
               var storySegments = UserDefaults.standard.array(forKey: "storySegments") as? [String]
//               if !story.seen {
                   if story.title.lowercased().contains("bijan")  {
                       storySegments?.removeAll(where: { str in
                           str.lowercased().contains("bijan")
                       })
                       let components = story.title.components(separatedBy: " ")
                       if let num = Int(components[1]) {
                           let count = num + 1
                           let finalStr = components[0] + " " + String(count)
                           storySegments?.append(finalStr)
                           let unique = Array(Set(storySegments ?? [""]))
                           UserDefaults.standard.setValue(unique, forKey: "storySegments")
                       }
                   }
//               }
           }
       }
    
    static func updateStories() {
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
            return formatter
        }()
        
        guard let userDate = UserDefaults.standard.string(forKey: "userDate") else {
            UserDefaults.standard.setValue(formatter.string(from: Date()), forKey: "userDate")
            return
        }

        if (Date() - formatter.date(from: userDate)! >= 86400 && Date() - formatter.date(from: userDate)! <= 172800) {
            UserDefaults.standard.setValue(Date(), forKey: "userDate")
            if let newSegments = UserDefaults.standard.array(forKey: "storySegments") as? [String] {
                UserDefaults.standard.setValue(newSegments, forKey: "oldSegments")
                StorylyManager.updateSegments(segs: newSegments)
            }
        } else if  Date() - formatter.date(from: userDate)! > 172800 {
            UserDefaults.standard.setValue(Date(), forKey: "userDate")
            if let newSegments = UserDefaults.standard.array(forKey: "storySegments") as? [String] {
                UserDefaults.standard.setValue(newSegments, forKey: "oldSegments")
                StorylyManager.updateSegments(segs: newSegments)
            }
        } else {
//            UserDefaults.standard.setValue(false, forKey: "openedStory")
            if let oldSegments = UserDefaults.standard.array(forKey: "storySegments") as? [String] {
                UserDefaults.standard.setValue(oldSegments, forKey: "oldSegments")
                StorylyManager.updateSegments(segs: oldSegments)
            }
        }
    }
    
    static func updateSegments(segs: [String]) {
        storySegments = Set(segs)
        storylyViewProgrammatic.storylyInit = StorylyInit(storylyId: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjU2OTgsImFwcF9pZCI6MTA2MDcsImluc19pZCI6MTEyNTV9.zW_oJyQ7FTAXHw8MXnEeP4k4oOafFrDGKylUw81pi3I", segmentation: StorylySegmentation(segments: storySegments))
        storylyViewProgrammatic.refresh()
    }
}
