//
//  StorylyManager.swift
//  MindGarden
//
//  Created by Dante Kim on 3/31/22.
//
import Amplitude
import Firebase
import Foundation
import Storyly

class StorylyManager: StorylyDelegate {
    static var shared = StorylyManager()

    func storylyLoaded(_: Storyly.StorylyView,
                       storyGroupList _: [Storyly.StoryGroup],
                       dataSource _: StorylyDataSource) {}

    func storylyLoadFailed(_: Storyly.StorylyView,
                           errorMessage _: String) {}

    func storylyActionClicked(_: Storyly.StorylyView,
                              rootViewController _: UIViewController,
                              story: Storyly.Story)
    {
        if story.media.actionUrl == "notification" {
            Analytics.shared.log(event: .story_notification_swipe)
            storylyViewProgrammatic.dismiss(animated: true)
            NotificationCenter.default.post(name: .notification, object: nil)
        } else if story.media.actionUrl == "referral" {
            Analytics.shared.log(event: .story_notification_swipe)
            storylyViewProgrammatic.dismiss(animated: true)
            NotificationCenter.default.post(name: .referrals, object: nil)
        } else if story.media.actionUrl == "gratitude" {
            Analytics.shared.log(event: .story_notification_swipe_gratitude)
            storylyViewProgrammatic.dismiss(animated: true)
            NotificationCenter.default.post(name: .gratitude, object: nil)
        } else if story.media.actionUrl == "trees" {
            Analytics.shared.log(event: .story_swipe_trees_future)
            storylyViewProgrammatic.dismiss(animated: true)
            NotificationCenter.default.post(name: .trees, object: nil)
        }
    }

    func storylyStoryPresented(_: Storyly.StorylyView) {}

    func storylyStoryDismissed(_: Storyly.StorylyView) {
        if !DefaultsManager.standard.value(forKey: .showedChallenge).boolValue {
            NotificationCenter.default.post(name: .storyOnboarding, object: nil)
        }
    }

    func storylyUserInteracted(_: Storyly.StorylyView,
                               storyGroup _: Storyly.StoryGroup,
                               story _: Storyly.Story,
                               storyComponent _: Storyly.StoryComponent) {}

    func storylyEvent(_: Storyly.StorylyView,
                      event _: Storyly.StorylyEvent,
                      storyGroup _: Storyly.StoryGroup?,
                      story: Storyly.Story?,
                      storyComponent _: Storyly.StoryComponent?)
    {
        if let story = story {
            Amplitude.instance().logEvent("opened_story", withEventProperties: ["title": "\(story.title)"])
            let components = story.title.components(separatedBy: " ")
            var storyArray = UserDefaults.standard.array(forKey: "storySegments") as? [String]
            var unique = Array(Set(storyArray ?? [""]))
            if story.title.lowercased().contains("intro/day") {
                storyArray?.removeAll(where: { str in
                    str.lowercased().contains("intro/day")
                })

                // case doesn't matter for setting storylabels
                storyArray = updateComps(components: components, segs: storyArray)
                unique = Array(Set(storyArray ?? [""]))
                SceneDelegate.userModel.completedIntroDay = true
            } else if story.title.lowercased() == "#4" || story.title.lowercased().contains("tip") {
                storyArray?.removeAll(where: { str in
                    str.lowercased().contains("tip")
                })
                storySegments = Set(storyArray ?? [""])
                StorylyManager.refresh()
//                       storylyViewProgrammatic.dismiss(animated: true)
                let unique = Array(storySegments)
                DefaultsManager.standard.set(value: unique, forKey: .storySegments)
                DefaultsManager.standard.set(value: unique, forKey: .oldSegments)
                return
            } else if story.title.lowercased().contains("trees for the future") {
                storyArray?.removeAll(where: { str in
                    str.lowercased().contains("trees for the future")
                })
//                       storylyViewProgrammatic.dismiss(animated: true)
                DefaultsManager.standard.set(value: storyArray ?? [], forKey: .storySegments)
                return
            } else if story.title.lowercased().contains("welcome!") {
                storyArray?.removeAll(where: { str in
                    str.lowercased().contains("intro/day")
                })
                storySegments = Set(storyArray ?? [""])
                StorylyManager.refresh()

                let comps = ["intro/day", "1"]
                // case doesn't matter for setting storylabels
                storyArray = updateComps(components: comps, segs: storyArray)
                unique = Array(Set(storyArray ?? [""]))
                SceneDelegate.userModel.completedIntroDay = true
            }

            unique = Array(Set(storyArray ?? [""]))
            DefaultsManager.standard.set(value: unique, forKey: .storySegments)
        }
    }

    static func saveToFirebase(unique: [String]) {
        if let email = Auth.auth().currentUser?.email {
            // Read Data from firebase, for syncing
            Firestore.firestore().collection(K.userPreferences).document(email).updateData([
                "storySegments": unique,
            ]) { error in
                if let e = error {
                    print("There was a issue saving data to firestore \(e) ")
                } else {
                    print("Succesfully saved stories")
                }
            }
        }
    }

    private func updateComps(components: [String], segs: [String]?) -> [String]? {
        if var segments = segs {
            if let num = Int(components[1]) {
                if components[0].lowercased() == "intro/day" && num == 1 && !DefaultsManager.standard.value(forKey: .fiveHundredBonus).boolValue {
                    SceneDelegate.userModel.showDay1Complete = true
                }
                let count = num + 1
                var finalStr = components[0]
                finalStr += " " + String(count)

                segments.append(finalStr)
            }
            return segments
        }
        return [""]
    }

    static func updateStories() {
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
            return formatter
        }()

        guard let userDate = DefaultsManager.standard.value(forKey: .userDate).string else {
            DefaultsManager.standard.set(value: formatter.string(from: Date()), forKey: .userDate)
            if let oldSegments = DefaultsManager.standard.value(forKey: .oldSegments).arrayValue as? [String] {
//                DefaultsManager.standard.set(value: oldSegments, forKey: "oldSegments")
                StorylyManager.updateSegments(segs: oldSegments)
            }
            return
        }

//         start with today
//        let cal = NSCalendar.current
//        var date = cal.startOfDay(for: Date())
//        var arrDates = [Date]()
//        arrDates.append(Date())
//        date = cal.date(byAdding: Calendar.Component.day, value: -1, to: date)!
//        DefaultsManager.standard.set(value: formatter.string(from: date), forKey: "userDate")
//        let userDate = UserDefaults.standard.string(forKey: "userDate")!
//
        let lastOpenedDate = formatter.date(from: userDate)!.setTime(hour: 00, min: 00, sec: 00)
        let currentDate = Date().setTime(hour: 00, min: 00, sec: 00) ?? Date()
        let interval = currentDate.interval(ofComponent: .day, fromDate: lastOpenedDate ?? Date())

        if interval >= 1 && interval < 2 { // update streak number and date
            DefaultsManager.standard.set(value: Date(), forKey: .userDate)
            if let newSegments = DefaultsManager.standard.value(forKey: .storySegments).arrayValue as? [String] {
                DefaultsManager.standard.set(value: newSegments, forKey: .oldSegments)
                StorylyManager.updateSegments(segs: newSegments)
                StorylyManager.saveToFirebase(unique: newSegments)
            }

        } else if interval >= 2 { // broke streak
            DefaultsManager.standard.set(value: Date(), forKey: .userDate)
            if let newSegments = DefaultsManager.standard.value(forKey: .storySegments).arrayValue as? [String] {
                DefaultsManager.standard.set(value: newSegments, forKey: .oldSegments)
                StorylyManager.updateSegments(segs: newSegments)
                StorylyManager.saveToFirebase(unique: newSegments)
            }

        } else {
            if let oldSegments = DefaultsManager.standard.value(forKey: .oldSegments).arrayValue as? [String] {
//                DefaultsManager.standard.set(value: oldSegments, forKey: "oldSegments")
                StorylyManager.updateSegments(segs: oldSegments)
            }
        }
        SceneDelegate.userModel.isIntroDone()
    }

    static func updateSegments(segs: [String]) {
        storySegments = Set(segs)
        StorylyManager.refresh()
    }

    static func refresh() {
        storylyViewProgrammatic.storylyInit = StorylyInit(storylyId: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjU2OTgsImFwcF9pZCI6MTA2MDcsImluc19pZCI6MTEyNTV9.zW_oJyQ7FTAXHw8MXnEeP4k4oOafFrDGKylUw81pi3I", segmentation: StorylySegmentation(segments: storySegments))
        storylyViewProgrammatic.storyGroupListStyling = StoryGroupListStyling(edgePadding: 0, paddingBetweenItems: 0)
        storylyViewProgrammatic.storyGroupSize = "small"
        storylyViewProgrammatic.refresh()
    }
}
