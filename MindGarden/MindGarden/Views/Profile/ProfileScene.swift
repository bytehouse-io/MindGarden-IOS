//
//  ProfileScene.swift
//  MindGarden
//
//  Created by Dante Kim on 7/6/21.
//

import SwiftUI
import MessageUI
import Purchases
import FirebaseDynamicLinks
import Firebase
import StoreKit
import GTMAppAuth
import WidgetKit

var tappedRefer = false
var mindfulNotifs = false
enum settings {
    case referrals
    case settings
    case journey
}

struct ProfileScene: View {
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var profileModel: ProfileViewModel
    @State private var selection: settings = .settings
    @State private var showNotification = false
    @State private var isSignedIn = true
    @State private var tappedSignedIn = false
    @State private var showMailView = false
    @State private var mailNeedsSetup = false
    @State private var notificationOn = false
    @State private var showNotif = false
    @State private var dateTime = Date()
    @State private var restorePurchase = false
    @State private var numRefs = 0
    @State private var refDate = ""
    @State private var tappedRate = false
    @State private var showSpinner = false
    @State private var showMindful = false
    @State private var showWidget = false

    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        return dateFormatter
    }()

    var body: some View {
        LoadingView(isShowing: $showSpinner) {
            VStack {
                if #available(iOS 14.0, *) {
                    NavigationView {
                        GeometryReader { g in
                            let width = g.size.width
                            let height = g.size.height
                            ZStack {
                                Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                                VStack(alignment: .center, spacing: 0) {
                                    HStack(alignment: .bottom, spacing: 0) {
                                        SelectionButton(selection: $selection, type: .referrals)
                                            .frame(width: abs(g.size.width/4 - 1))
                                        VStack {
                                            Rectangle().fill(Color.gray.opacity(0.3))
                                                .frame(width: 2, height: 35)
                                                .padding(.top, 10)
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.3))
                                                .frame(height: 5)
                                        }.frame(width: 5)
                                        SelectionButton(selection: $selection, type: .settings)
                                            .frame(width: abs(g.size.width/4 - 1))
                                        VStack {
                                            Rectangle().fill(Color.gray.opacity(0.3))
                                                .frame(width: 2, height: 35)
                                                .padding(.top, 10)
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.3))
                                                .frame(height: 5)
                                        }.frame(width: 5)
                                        SelectionButton(selection: $selection, type: .journey)
                                            .frame(width: abs(g.size.width/4 - 1))
                                    }.background(Clr.darkWhite).frame(height: 50)
                                        .cornerRadius(12)
                                        .neoShadow()
                                    if showNotification && selection == .settings {
                                        Button {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            showNotification = false
                                        } label: {
                                            Capsule()
                                                .fill(Clr.darkWhite)
                                                .padding(.horizontal)
                                                .overlay(
                                                    Text("Go Back")
                                                        .font(Font.mada(.semiBold, size: 20))
                                                        .foregroundColor(Clr.darkgreen)
                                                )
                                                .frame(width: width * 0.35, height: 30)
                                        }
                                        .buttonStyle(NeumorphicPress())
                                        .padding(.top)
                                    }

                                    if selection == .settings {
                                        if showNotification {
                                            Text("Notifications")
                                                .font(Font.mada(.regular, size: 20))
                                                .foregroundColor(Color.gray)
                                                .frame(width: width * 0.7, height: 20, alignment: .leading)
                                                .padding(.bottom, 30)
                                                .padding(.top, 20)
                                            ZStack {
                                                Rectangle()
                                                    .fill(Clr.darkWhite)
                                                    .cornerRadius(12)
                                                    .neoShadow()
                                                VStack {
                                                    Row(title: "Meditation Reminders", img: Image(systemName: "bell.fill"), swtch: true, action: {
                                                        withAnimation {
                                                            showNotification = false
                                                            UserDefaults.standard.setValue(true, forKey: "notifOn")
                                                            showNotif = true
                                                        }
                                                    }, showNotif: $showNotif, showMindful: $showMindful)
                                                        .frame(height: 40)
                                                    Divider()
                                                    Row(title: "Mindful Reminders", img: Image(systemName: "bell.fill"), swtch: true, action: {
                                                        withAnimation {
                                                            UserDefaults.standard.setValue(true, forKey: "mindful")
                                                            showMindful = true
                                                        }
                                                    }, showNotif: $showNotif, showMindful: $showMindful)
                                                        .frame(height: 40)
                                                }.padding()
                                            }.frame(width: width * 0.75, height: 80)
                                                .transition(.slide)
                                                .animation(.default)
                                        } else {
                                            ScrollView(.vertical, showsIndicators: false) {
                                                VStack {
                                                    Text("Settings")
                                                        .font(Font.mada(.regular, size: 20))
                                                        .foregroundColor(Color.gray)
                                                        .frame(width: width * 0.7, height: 20, alignment: .leading)
                                                        .padding(.bottom, 30)
                                                    ZStack {
                                                        Rectangle()
                                                            .fill(Clr.darkWhite)
                                                            .cornerRadius(12)
                                                            .neoShadow()
                                                        VStack {
                                                            if !UserDefaults.standard.bool(forKey: "isPro") {
                                                                Row(title: "Unlock Pro", img: Image(systemName: "heart.fill"), action: {
                                                                    Analytics.shared.log(event: .profile_tapped_goPro)
                                                                    withAnimation {
                                                                        fromPage = "profile"
                                                                        viewRouter.currentPage = .pricing
                                                                    }
                                                                }, showNotif: $showNotif, showMindful: $showMindful)
                                                                    .frame(height: 40)
                                                                Divider()
                                                            }
                                                            Row(title: "Notifications", img: Image(systemName: "bell.fill"), action: {
                                                                showNotification = true
                                                                Analytics.shared.log(event: .profile_tapped_notifications)
                                                            }, showNotif: $showNotif, showMindful: $showMindful)
                                                                .frame(height: 40)
                                                            Divider()
                                                            Row(title: "Contact Us", img: Image(systemName: "envelope.fill"), action: {
                                                                Analytics.shared.log(event: .profile_tapped_email)
                                                                if MFMailComposeViewController.canSendMail() {
                                                                    showMailView = true
                                                                } else {
                                                                    mailNeedsSetup = true
                                                                }
                                                            }, showNotif: $showNotif, showMindful: $showMindful)
                                                                .frame(height: 40)
                                                            Divider()
                                                            Row(title: "Restore Purchases", img: Image(systemName: "arrow.triangle.2.circlepath"), action: {
                                                                Analytics.shared.log(event: .profile_tapped_restore)
                                                                Purchases.shared.restoreTransactions { (purchaserInfo, error) in
                                                                    if purchaserInfo?.entitlements.all["isPro"]?.isActive == true {
                                                                        UserDefaults.standard.setValue(true, forKey: "isPro")
                                                                        restorePurchase = true
                                                                    } else {
                                                                        UserDefaults.standard.setValue(false, forKey: "isPro")
                                                                    }
                                                                }
                                                            }, showNotif: $showNotif, showMindful: $showMindful)
                                                                .frame(height: 40)
                                                            Divider()
                                                            Row(title: "Add Widget", img: Image(systemName: "gear"), action: {
                                                                Analytics.shared.log(event: .profile_tapped_add_widget)
                                                                showWidget = true
                                                            }, showNotif: $showNotif, showMindful: $showMindful)
                                                                .frame(height: 40)
                                                        }.padding()
                                                    }.frame(width: width * 0.75, height: UserDefaults.standard.bool(forKey: "isPro") ? 200 : 240)

                                                    Text("I want to help")
                                                        .font(Font.mada(.regular, size: 20))
                                                        .foregroundColor(Color.gray)
                                                        .frame(width: width * 0.7, height: 20, alignment: .leading)
                                                        .padding(.bottom, 30)
                                                        .padding(.top, 50)
                                                    ZStack {
                                                        Rectangle()
                                                            .fill(Clr.darkWhite)
                                                            .cornerRadius(12)
                                                            .neoShadow()
                                                        VStack {
                                                            Row(title: "Invite Friends", img: Image(systemName: "arrowshape.turn.up.right.fill"), action: {
                                                                Analytics.shared.log(event: .profile_tapped_invite)
                                                                actionSheet() }, showNotif: $showNotif, showMindful: $showMindful)
                                                                .frame(height:40)
                                                            Divider()
                                                            Row(title: "Rate the app", img: Image(systemName: "star.fill"), action: {
                                                                rateFunc()
                                                            }, showNotif: $showNotif, showMindful: $showMindful)
                                                                .frame(height:  40)
                                                            Divider()
                                                            Row(title: "Request Feature/Med", img: Image(systemName: "hand.raised.fill"), action: {
                                                                Analytics.shared.log(event: .profile_tapped_roadmap)
                                                                if let url = URL(string: "https://mindgarden.upvoty.com/") {
                                                                    UIApplication.shared.open(url)
                                                                }
                                                            }, showNotif: $showNotif, showMindful: $showMindful)
                                                                .frame(height: 40)
                                                            Divider()
                                                            Row(title: "Feedback Form", img: Image(systemName: "doc.on.clipboard"), action: {
                                                                Analytics.shared.log(event: .profile_tapped_feedback)
                                                                if let url = URL(string: "https://tally.so/r/3EB1Bw") {
                                                                    UIApplication.shared.open(url)
                                                                }
                                                            }, showNotif: $showNotif, showMindful: $showMindful)
                                                                .frame(height: 40)
                                                        }.padding()
                                                    }.frame(width: width * 0.75, height: 190)
                                                    Text("Stay up to date")
                                                        .font(Font.mada(.regular, size: 20))
                                                        .foregroundColor(Color.gray)
                                                        .frame(width: width * 0.7, height: 20, alignment: .leading)
                                                        .padding(.bottom, 30)
                                                        .padding(.top, 50)
                                                    ZStack {
                                                        Rectangle()
                                                            .fill(Clr.darkWhite)
                                                            .cornerRadius(12)
                                                            .neoShadow()
                                                        VStack {
                                                            Row(title: "Join the Community", img: Img.redditIcon, action: {
                                                                Analytics.shared.log(event: .profile_tapped_reddit)
                                                                if let url = URL(string: "https://www.reddit.com/r/MindGarden/") {
                                                                    UIApplication.shared.open(url)
                                                                    if !UserDefaults.standard.bool(forKey: "reddit") {
                                                                        userModel.willBuyPlant = Plant.badgePlants.first(where: { p in
                                                                            p.title == "Lemon"
                                                                        })
                                                                        userModel.buyPlant(unlockedStrawberry: true)
                                                                        UserDefaults.standard.setValue(true, forKey: "reddit")
                                                                    }
                                                                }
                                                            }, showNotif: $showNotif, showMindful: $showMindful).frame(height: 40)
                                                                .frame(height: K.isSmall() ? 30 : 40)
                                                            Divider()
                                                            Row(title: "Daily Motivation", img: Img.instaIcon, action: {
                                                                Analytics.shared.log(event: .profile_tapped_instagram)
                                                                if let url = URL(string: "https://www.instagram.com/mindgardn/") {
                                                                    UIApplication.shared.open(url)
                                                                }
                                                            }, showNotif: $showNotif, showMindful: $showMindful)
                                                                .frame(height: K.isSmall() ? 30 : 40)
                                                        }.padding()
                                                    }.frame(width: width * 0.8, height: 70)
                                                } .frame(width: width * 0.8)
                                                .padding(.bottom)
                                            }
                                            .frame(width: width * 0.8, height: height * 0.7)
                                            .padding(.top, 25)
                                        }
                                    } else if selection == .journey {
                                        // Journey
                                        JourneyPage(profileModel: profileModel, width: width, height: height, totalSessions: gardenModel.totalSessions, totalMins: gardenModel.totalMins)
                                    } else {
                                        VStack {
                                            Text("🎁 Get & give 2 weeks free of MindGarden Pro for every referral (stackable)")
                                                .font(Font.mada(.bold, size: K.isSmall() ? 18 : 20))
                                                .foregroundColor(Clr.black2)

                                                .multilineTextAlignment(.leading)
                                                .offset(y: -24)
                                            ZStack {
                                                Rectangle()
                                                    .fill(Clr.darkWhite)
                                                    .cornerRadius(12)
                                                    .frame(width: abs(width - 100))
                                                    .neoShadow()
                                                VStack(alignment: .leading) {
                                                    HStack(alignment: .center, spacing: 10) {
                                                        Image(systemName: "number")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .foregroundColor(Clr.darkgreen)
                                                        Text("Total Referrals")
                                                            .font(Font.mada(.regular, size: 20))
                                                            .foregroundColor(Clr.black1)
                                                            .padding(.top, 3)
                                                    }.frame(width: abs(width - 150), alignment: .leading)
                                                        .frame(height: 25)
                                                    HStack {
                                                        Text("\(numRefs)")
                                                            .font(Font.mada(.bold, size: 40))
                                                            .foregroundColor(Clr.darkgreen)
                                                        Text("Referrals")
                                                            .font(Font.mada(.semiBold, size: 28))
                                                            .foregroundColor(Clr.black1)
                                                    }.frame(width: abs(width - 150), alignment: .leading)
                                                    HStack(alignment: .center, spacing: 10) {
                                                        Image(systemName: "calendar")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                        Text("Pro Expires On:")
                                                            .font(Font.mada(.regular, size: 20))
                                                            .foregroundColor(Clr.black1)
                                                            .padding(.top, 3)
                                                    }.frame(width: abs(width - 150), alignment: .leading)
                                                        .frame(height: 25)
                                                    Text("\(refDate)")
                                                        .font(Font.mada(.bold, size: 24))
                                                        .foregroundColor(Clr.darkgreen)
                                                        .frame(width: abs(width - 150), alignment: .leading)
                                                }.padding()
                                            }.frame(width: abs(width - 100), height: height/4)
                                                .padding(.horizontal)
                                        }
                                        .frame(width: abs(width - 100))
                                        .offset(y: 40)
                                    }
                                    if selection == .referrals {
                                        Button {
                                            Analytics.shared.log(event: .profile_tapped_refer_friend)
                                            if let _ = Auth.auth().currentUser?.email {
                                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                                actionSheet()
                                            } else {
                                                withAnimation {
                                                    tappedSignIn = false
                                                    viewRouter.currentPage = .authentication
                                                }
                                            }
                                        } label: {
                                            Capsule()
                                                .fill(Clr.darkgreen)
                                                .neoShadow()
                                                .overlay(Text("Refer a friend")
                                                            .foregroundColor(.white)
                                                            .font(Font.mada(.bold, size: 24)))
                                        }
                                        .frame(width: abs(width - 100), height: 50, alignment: .center)
                                        .padding(.top, 80)
                                        if !tappedRate {
                                            Text("⭐️ Support our 3 person team!")
                                                .foregroundColor(Clr.darkgreen)
                                                .font(Font.mada(.bold, size: 20))
                                                .minimumScaleFactor(0.5)
                                                .lineLimit(2)
                                                .padding(.top, 50)
                                                .frame(width: abs(width - 100), alignment: .leading)
                                            Button {
                                                rateFunc()
                                            } label: {
                                                Capsule()
                                                    .fill(Clr.yellow)
                                                    .neoShadow()
                                                    .overlay(
                                                        Text("Rate MindGarden")
                                                            .foregroundColor(Clr.darkgreen)
                                                            .font(Font.mada(.bold, size: 20))
                                                            .minimumScaleFactor(0.5)
                                                            .lineLimit(2)
                                                            .padding(9))
                                            }
                                            .frame(width: abs(width - 100), height: 50, alignment: .center)
                                            .padding(.top, 10)
                                        }
                                    } else {
                                        Spacer()
                                        if selection == .settings && !showNotification {
                                            if let _ = Auth.auth().currentUser?.email {} else {
                                                Text("Save your progress")
                                                    .foregroundColor(Clr.black2).font(Font.mada(.semiBold, size: 20))
                                                    .padding(.top, K.isSmall() ? 0 : 15)
                                                    .padding(.bottom, -10)
                                            }
                                            Button {
                                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                                if let _ = Auth.auth().currentUser?.email {
                                                    Analytics.shared.log(event: .profile_tapped_logout)
                                                    profileModel.signOut()
                                                    // if user signs out -> send them to meditate page
                                                    withAnimation {
                                                        viewRouter.currentPage = .onboarding
                                                    }
                                                } else {
                                                    Analytics.shared.log(event: .profile_tapped_create_account)
                                                    withAnimation {
                                                        viewRouter.currentPage = .authentication
                                                    }
                                                }
                                            } label: {
                                                if let _ = Auth.auth().currentUser?.email {
                                                    Capsule()
                                                        .fill(Clr.redGradientBottom)
                                                        .neoShadow()
                                                        .overlay(Text("Sign Out").foregroundColor(.white).font(Font.mada(.bold, size: 24)))
                                                } else {
                                                    Capsule()
                                                        .fill(Clr.darkgreen)
                                                        .neoShadow()
                                                        .overlay(
                                                            Text("Create an account").foregroundColor(.white).font(Font.mada(.bold, size: 24)))
                                                }
                                            }
                                            .frame(width: abs(width - 100), height: 50, alignment: .center)
                                            .padding()
                                        }
                                    }
                                    Spacer()
                                }.navigationBarTitle("\(userModel.name)", displayMode: .inline)
                                    .frame(width: width, height: height)
                                    .background(Clr.darkWhite)
                                if showWidget {
                                    Color.black
                                        .opacity(0.3)
                                        .edgesIgnoringSafeArea(.all)
                                    Spacer()
                                }
                                WidgetModal(shown: $showWidget)
                                    .offset(y: showWidget ? 0 : g.size.height)
                                    .animation(.default, value: showWidget)
                            }
                        }
                    }
                    .onAppear {
                        fromOnboarding = false
                        // Set the default to clear
                        UITableView.appearance().backgroundColor = .clear
                        UITableView.appearance().showsVerticalScrollIndicator = false
                        //                    UITableView.appearance().isScrollEnabled = false
                        profileModel.update(userModel: userModel, gardenModel: gardenModel)
                    }
                    .sheet(isPresented: $showMailView) {
                        MailView()
                    }
                    .fullScreenCover(isPresented: $showNotif) {
                        NotificationScene(fromSettings: true)
                    }
                    .fullScreenCover(isPresented: $showMindful) {
                        MindfulScene()
                    }
                    .alert(isPresented: $mailNeedsSetup) {
                        Alert(title: Text("Your mail is not setup"), message: Text("Please try manually emailing team@mindgarden.io thank you."))
                    }
                    .alert(isPresented: $restorePurchase) {
                        Alert(title: Text("Success!"), message: Text("You've restored MindGarden Pro"))
                    }
                    .onAppearAnalytics(event: .screen_load_profile)
                } else {
                    // Fallback on earlier versions
                }
            }
        }.onAppear {
            //            print(dateFormatter.string(from: UserDefaults.standard.value(forKey: K.defaults.meditationReminder) as! Date), "so fast")
            if tappedRefer {
                selection = .referrals
                tappedRefer = false
            } else {
                selection = .settings
                if mindfulNotifs {
                    showNotification = true
                    mindfulNotifs = false
                }
            }

            tappedRate = UserDefaults.standard.bool(forKey: "tappedRate")
            if userModel.referredStack == "" {
                if !UserDefaults.standard.bool(forKey: "isPro") {
                    refDate = "No referrals"
                } else {
                    refDate = "Pro account is active"
                }
                numRefs = 0
            } else {
                let plusIndex = userModel.referredStack.indexInt(of: "+") ?? 0
                refDate =  userModel.referredStack.substring(to: plusIndex)
                numRefs = Int(userModel.referredStack.substring(from: plusIndex + 1)) ?? 0
            }
        }
    }
    struct JourneyPage: View {
        var profileModel: ProfileViewModel
        var width: CGFloat
        var height: CGFloat
        var totalSessions: Int
        var totalMins: Int
        @State private var text = ""
        @State private var response = ""
        var body: some View {
            VStack {
                VStack(alignment: .center, spacing: 20) {
                    HStack(alignment: .center, spacing: 15) {
                        StatBox(label: "All Mins", img: Img.iconTotalTime, value: "\(totalMins/60 == 0 && totalMins != 0 ? "0.5" : "\(totalMins/60)")")
                        StatBox(label: "All Sess", img: Img.iconSessions, value: "\(totalSessions)")
                    }.padding(.horizontal, 5)
                    HStack(alignment: .center, spacing: 15) {
                        StatBox(label: "All Gratitudes", img: Img.hands, value: "\(UserDefaults.standard.integer(forKey: "numGrads"))")
                        StatBox(label: "Longest Streak", img: Img.newStar, value: "\(UserDefaults.standard.integer(forKey: "longestStreak") == 0 ? 1 : UserDefaults.standard.integer(forKey: "longestStreak")  )")
                    }.padding(.horizontal, 5)
                }.frame(width: width * 0.8, height: 160)
                    .padding()
                ZStack {
                    Rectangle()
                        .fill(Clr.yellow)
                        .cornerRadius(12)
                        .frame(width: width * 0.75, height: 120)
                        .neoShadow()
                    VStack(alignment: .leading) {
                        HStack(alignment: .center, spacing: 10) {
                            Image(systemName: "calendar")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.black)
                            Text("Your journey began")
                                .font(Font.mada(.regular, size: 18))
                                .foregroundColor(.black)
                                .padding(.top, 3)
                        }.frame(width: width * 0.75, height: 25, alignment: .leading)
                        Text("\(profileModel.signUpDate)")
                            .font(Font.mada(.bold, size: 34))
                            .foregroundColor(Clr.darkgreen)
                    }
                    .frame(width: width * 0.65, height: 120, alignment: .leading)
                    .padding()
                }.frame(width: width * 0.75, height: 120)
                    .padding()
                Text(response)
                    .foregroundColor(Clr.darkgreen)
                    .font(Font.mada(.semiBold, size: 16))
                    .frame(width: width * 0.75, alignment: .center)
                HStack {
                    TextField("Enter promo code", text: $text)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Clr.darkWhite)
                        .frame(width: width * 0.5, height: 40)
                        .oldShadow()
                    Button {
                        if text == "FTXTNL7E3AA6" {
                            UserDefaults.standard.setValue(true, forKey: "promoCode")
                            UserDefaults(suiteName: "group.io.bytehouse.mindgarden.widget")?.setValue(true, forKey: "isPro")
                            WidgetCenter.shared.reloadAllTimelines()
                            UserDefaults.standard.setValue(true, forKey: "isPro")
                            UserDefaults.standard.setValue(true, forKey: "bonsai")
                            if let email = Auth.auth().currentUser?.email {
                                Firestore.firestore().collection(K.userPreferences).document(email).updateData([
                                    "isPro": true,
                                ]) { (error) in
                                    if let e = error {
                                        print("There was a issue saving data to firestore \(e) ")
                                    } else {
                                        print("Succesfully saved new items")
                                    }
                                }
                            }
                            response = "✅ Success your a pro user now!"
                        } else {
                            response = "Invalid code"
                        }
                    } label: {
                        ZStack {
                            Rectangle()
                                .fill(Clr.yellow)
                                .cornerRadius(12)
                            Text("Submiit")
                                .font(Font.mada(.semiBold, size: 16))
                                .foregroundColor(.black)
                        }
                    }.buttonStyle(NeumorphicPress())
                }.frame(width: width * 0.75,height: 35)
                    .keyboardResponsive()
            }
        }
    }
    private func rateFunc() {
        Analytics.shared.log(event: .profile_tapped_rate)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if let windowScene = UIApplication.shared.windows.first?.windowScene { SKStoreReviewController.requestReview(in: windowScene)
            UserDefaults.standard.setValue(true, forKey: "tappedRate")
            //                                                userModel.willBuyPlant = Plant.badgePlants.first(where: { p in
            //                                                    p.title == "Camellia"
            //                                                })
            //                                                userModel.buyPlant(unlockedStrawberry: true)
        }
        tappedRate = true
    }

    func actionSheet() {
        guard var urlShare2 = URL(string: "https://mindgarden.io") else { return }
        if selection == .referrals {
            showSpinner = true
            guard let uid = Auth.auth().currentUser?.email else { return }
            guard let link = URL(string: "https://mindgarden.io?referral=\(uid)") else { return }
            let referralLink = DynamicLinkComponents(link: link, domainURIPrefix: "https://mindgarden.page.link")


            if let myBundleId = Bundle.main.bundleIdentifier {
                referralLink?.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)
                referralLink?.iOSParameters?.minimumAppVersion = "1.18"
                referralLink?.iOSParameters?.appStoreID = "1588582890"
            }

            let newDate = Calendar.current.date(byAdding: .day, value: 2, to: Date())
            let newDateString = dateFormatter.string(from: newDate ?? Date())
            referralLink?.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
            referralLink?.socialMetaTagParameters?.title = "\(userModel.name) invited you to MindGarden"
            referralLink?.socialMetaTagParameters?.descriptionText = "📱 Download the app by \(newDateString) to claim your 2 free weeks of PRO! ⬇️ Keep it checked"
            guard let imgUrl = URL(string: "https://i.ibb.co/1GW6YxY/MINDGARDEN.png") else { return }
            referralLink?.socialMetaTagParameters?.imageURL = imgUrl
            referralLink?.shorten { (shortURL, warnings, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                urlShare2 = shortURL!
                let activityVC = UIActivityViewController(activityItems: [urlShare2], applicationActivities: nil)
                UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: {
                    showSpinner = false
                })
            }
        } else {
            let activityVC = UIActivityViewController(activityItems: [urlShare2], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
    }


    struct Row: View {
        var title: String
        var img: Image
        var swtch: Bool = false
        var action: () -> ()
        @State var notifOn = true
        @Binding var showNotif: Bool
        @Binding var showMindful: Bool
        var body: some View {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                action()
            } label: {
                VStack(spacing: 20) {
                    HStack() {
                        img
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 20)
                            .offset(x: -10)
                            .foregroundColor(Clr.darkgreen)
                        Text(title)
                            .font(Font.mada(.medium, size: title == "Meditation Reminders" || title == "Mindful Reminders" ? 14 : 20))
                            .foregroundColor(title == "Unlock Pro" ? Clr.brightGreen : Clr.black1)
                        Spacer()
                        if title == "Notifications" {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        } else if swtch {
                            if #available(iOS 14.0, *) {
                                if title == "Meditation Reminders" {
                                    Toggle("", isOn: $notifOn)
                                        .onChange(of: notifOn) { val in
                                            UserDefaults.standard.setValue(val, forKey: "notifOn")
                                            if val {
                                                Analytics.shared.log(event: .profile_tapped_toggle_on_notifs)
                                                showNotif = true
                                            } else { //turned off
                                                Analytics.shared.log(event: .profile_tapped_toggle_off_notifs)
                                                UserDefaults.standard.setValue(false, forKey: "notifOn")
                                                let center = UNUserNotificationCenter.current()
                                                center.removePendingNotificationRequests(withIdentifiers: ["1", "2", "3", "4", "5", "6", "7"]) // To remove all pending notifications which are not delivered yet but scheduled.
                                            }
                                        }.toggleStyle(SwitchToggleStyle(tint: Clr.gardenGreen))
                                        .frame(width: UIScreen.main.bounds.width * 0.1)
                                } else {
                                    Toggle("", isOn: $notifOn)
                                        .onChange(of: notifOn) { val in
                                            UserDefaults.standard.setValue(val, forKey: "mindful")
                                            if val {
                                                Analytics.shared.log(event: .profile_tapped_toggle_on_mindful)
                                                showMindful = true
                                            } else { //turned off
                                                NotificationHelper.deleteMindfulNotifs()
                                                Analytics.shared.log(event: .profile_tapped_toggle_off_mindful)
                                            }
                                        }.toggleStyle(SwitchToggleStyle(tint: Clr.gardenGreen))
                                        .frame(width: UIScreen.main.bounds.width * 0.1)
                                }
                            }
                        }
                    }.padding()
                }
                .listRowBackground(title == "Unlock Pro" ? Clr.yellow : Clr.darkWhite)
            }.onAppear {
                if title == "Meditation Reminders" {
                    notifOn = UserDefaults.standard.bool(forKey: "notifOn")
                } else {
                    notifOn = UserDefaults.standard.bool(forKey: "mindful")
                }
            }
        }
    }
}

struct ProfileScene_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScene(profileModel: ProfileViewModel())
    }
}

struct SelectionButton: View {
    @Binding var selection: settings
    var type: settings

    var body: some View {
        VStack {
            Spacer()
            Button {
                if type == .settings {
                    Analytics.shared.log(event: .profile_tapped_settings)
                } else if type == .journey{
                    Analytics.shared.log(event: .profile_tapped_journey)
                } else {
                    Analytics.shared.log(event: .profile_tapped_refer)
                }
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                selection = type
            } label: {
                HStack(alignment: .top) {
                    Text(type == .settings ?  "Settings" : type == .referrals ? "Referrals" : "Journey")
                        .font(Font.mada(.bold, size: 18))
                        .foregroundColor(selection == type ? Clr.brightGreen : Clr.black1)
                        .padding(.top, 10)
                }
            }.frame(height: 25, alignment: .center)
            Spacer()
            Rectangle()
                .fill(selection == type ?  Clr.brightGreen : Color.gray.opacity(0.3))
                .frame(height: 8)
        }.frame(height: 52)

    }
}

