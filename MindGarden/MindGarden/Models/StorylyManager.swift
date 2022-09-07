//
//  StorylyManager.swift
//  MindGarden
//
//  Created by Dante Kim on 3/31/22.
//
import Storyly
import Foundation
import Amplitude
import Firebase

class StorylyManager: StorylyDelegate {
    static var shared = StorylyManager()
    let db = Firestore.firestore()

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
           if story.media.actionUrl == "notification" {
               Analytics.shared.log(event: .story_notification_swipe)
               storylyViewProgrammatic.dismiss(animated: true)
               NotificationCenter.default.post(name: Notification.Name("notification"), object: nil)
           } else if story.media.actionUrl == "referral"  {
               Analytics.shared.log(event: .story_notification_swipe)
               storylyViewProgrammatic.dismiss(animated: true)
               NotificationCenter.default.post(name: Notification.Name("referrals"), object: nil)
           } else if story.media.actionUrl == "gratitude" {
               Analytics.shared.log(event: .story_notification_swipe_gratitude)
               storylyViewProgrammatic.dismiss(animated: true)
               NotificationCenter.default.post(name: Notification.Name("gratitude"), object: nil)
           } else if story.media.actionUrl == "trees" {
               Analytics.shared.log(event: .story_swipe_trees_future)
               storylyViewProgrammatic.dismiss(animated: true)
               NotificationCenter.default.post(name: Notification.Name("trees"), object: nil)
           }
       }

       func storylyStoryPresented(_ storylyView: Storyly.StorylyView) {}

       func storylyStoryDismissed(_ storylyView: Storyly.StorylyView) {
           if !UserDefaults.standard.bool(forKey: "showedChallenge") {
               NotificationCenter.default.post(name: Notification.Name("storyOnboarding"), object: nil)
           }
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
           if let story = story {
               if !story.seen {
                   let components = story.title.components(separatedBy: " ")
                   Amplitude.instance().logEvent("opened_story", withEventProperties: ["title": "\(story.title)"])
                   var storyArray = UserDefaults.standard.array(forKey: "storySegments") as? [String]
                   var unique = Array(Set(storyArray ?? [""]))

                   if story.title.lowercased().contains("intro/day")  {
                       Analytics.shared.log(event: .story_bijan_opened)
                       storyArray?.removeAll(where: { str in
                           str.lowercased().contains("intro/day")
                       })
                      storyArray =  updateComps(components: components, segs: storyArray)
                      unique = Array(Set(storyArray ?? [""]))
                      saveToFirebase(unique: unique)
                   } else if story.title.lowercased() == "#4" || story.title.lowercased().contains("tip") {
                       Analytics.shared.log(event: .story_tip_opened)
                       storyArray?.removeAll(where: { str in
                           str.lowercased().contains("tip")
                       })
                       storySegments = Set(storyArray ?? [""])
                       StorylyManager.refresh()
//                       storylyViewProgrammatic.dismiss(animated: true)
                       let unique = Array(storySegments)
                       UserDefaults.standard.setValue(unique, forKey: "storySegments")
                       UserDefaults.standard.setValue(unique, forKey: "oldSegments")
                       saveToFirebase(unique: unique)
                       return
                   } else if story.title.lowercased().contains("trees for the future") {
                       storyArray?.removeAll(where: { str in
                           str.lowercased().contains("trees for the future")
                       })
//                       storylyViewProgrammatic.dismiss(animated: true)
                       UserDefaults.standard.setValue(storyArray, forKey: "storySegments")
                       saveToFirebase(unique: storyArray ?? [""])
                       return
                    }
                   unique = Array(Set(storyArray ?? [""]))
                    UserDefaults.standard.setValue(unique, forKey: "storySegments")
               }
           }
       }
    
    private func saveToFirebase(unique: [String]) {
        if let email = Auth.auth().currentUser?.email {
            //Read Data from firebase, for syncing
            self.db.collection(K.userPreferences).document(email).updateData([
                "storySegments": unique,
            ]) { (error) in
                if let e = error {
                    print("There was a issue saving data to firestore \(e) ")
                } else {
                    print("Succesfully saved meditations")
                }
            }
        }
    }
    
    private func updateComps(components: [String], segs: [String]?) -> [String]? {
        var segments = segs
        if let num = Int(components[1]) {
            let count = num + 1
            var finalStr = components[0]
            finalStr += " " + String(count)
            
            segments?.append(finalStr)
        }
        return segments
    }
    static func updateStories() {
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
            return formatter
        }()
        
        guard let userDate = UserDefaults.standard.string(forKey: "userDate") else {
            UserDefaults.standard.setValue(formatter.string(from: Date()), forKey: "userDate")
            if let oldSegments = UserDefaults.standard.array(forKey: "oldSegments") as? [String] {
//                UserDefaults.standard.setValue(oldSegments, forKey: "oldSegments")
                StorylyManager.updateSegments(segs: oldSegments)
            }
            return
        }
//
//         start with today
//        let cal = NSCalendar.current
//        var date = cal.startOfDay(for: Date())
//        var arrDates = [Date]()
//        arrDates.append(Date())
//        date = cal.date(byAdding: Calendar.Component.day, value: -1, to: date)!
//        UserDefaults.standard.setValue(formatter.string(from: date), forKey: "userDate")
//        let userDate = UserDefaults.standard.string(forKey: "userDate")!

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
            if let oldSegments = UserDefaults.standard.array(forKey: "oldSegments") as? [String] {
//                UserDefaults.standard.setValue(oldSegments, forKey: "oldSegments")
                StorylyManager.updateSegments(segs: oldSegments)
            }
        }
    }
    
    static func updateSegments(segs: [String]) {
        storySegments = Set(segs)
        StorylyManager.refresh()
    }
    
    static func refresh() {
        storylyViewProgrammatic.storylyInit = StorylyInit(storylyId: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjU2OTgsImFwcF9pZCI6MTA2MDcsImluc19pZCI6MTEyNTV9.zW_oJyQ7FTAXHw8MXnEeP4k4oOafFrDGKylUw81pi3I", segmentation: StorylySegmentation(segments: storySegments))
        storylyViewProgrammatic.storyGroupListStyling = StoryGroupListStyling(edgePadding: 0, paddingBetweenItems: 10)
        storylyViewProgrammatic.storyGroupSize = "small"
        storylyViewProgrammatic.refresh()
    }
    
}
