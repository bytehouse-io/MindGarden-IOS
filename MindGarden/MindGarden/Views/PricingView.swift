//
//  PricingView.swift
//  MindGarden
//
//  Created by Dante Kim on 10/26/21.
//

import SwiftUI
import Purchases
import AppsFlyerLib
import Firebase
import FirebaseFirestore

var fromPage = ""
var userWentPro = false

struct PricingView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var meditationModel: MeditationViewModel
    @State private var selectedPrice = ""
    @State private var packagesAvailableForPurchase = [Purchases.Package]()
    @State private var monthlyPrice = 0.0
    @State private var yearlyPrice = 0.0
    @State private var lifePrice = 0.0
    @State private var selectedBox = "Lifetime"
    @State private var question1 = false
    @State private var question2 = false
    @State private var question3 = false

    let items = [("Regular vs\n Pro", "😔", "🤩"), ("Total # of Meditations", "30", "Infinite"), ("Total # of Gratitudes", "30", "Infinite"), ("Total # of Mood Checks", "30", "Infinite"), ("Unlock all Meditations", "🔒", "✅"), ("Save data on  the cloud", "🔒", "✅")]
    var body: some View {
            GeometryReader { g in
                let width = g.size.width
                let height = g.size.height
                ZStack {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all)
                    VStack {
                        ScrollView(showsIndicators: false) {
                            ZStack {
                                Img.morningSun
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                Image(systemName: "xmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20)
                                    .foregroundColor(.gray)
                                    .padding(.leading, UIScreen.main.bounds.width/1.25)
                                    .padding(.bottom, 100)
                                    .opacity(0.5)
                                    .onTapGesture {
                                        withAnimation {
                                            switch fromPage {
                                            case "home": viewRouter.currentPage = .meditate
                                            case "profile": viewRouter.currentPage = .profile
                                            case "onboarding": viewRouter.currentPage = .garden
                                            case "onboarding2":
                                                meditationModel.selectedMeditation = Meditation.allMeditations.first(where: { $0.id == 6 })
                                                viewRouter.currentPage = .middle
                                            case "lockedMeditation": viewRouter.currentPage = .categories
                                            case "middle": viewRouter.currentPage = .middle
                                            default: viewRouter.currentPage = .meditate
                                            }
                                        }
                                    }
                            }.frame(width: g.size.width)
                            Text("Get 1% happier everyday\nby upgrading to\nMindGarden Pro 🍏")
                                .font(Font.mada(.bold, size: 26))
                                .foregroundColor(Clr.black2)
                                .multilineTextAlignment(.leading)
                                .frame(width: width * 0.80)
                                .padding()
                            Button {
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                selectedBox = "Lifetime"
                                unlockPro()
                            } label: {
                                PricingBox(title: "Lifetime", price: lifePrice, selected: $selectedBox)
                            }.buttonStyle(NeumorphicPress())
                                .frame(width: width * 0.8, height: height * 0.08)
                                .padding(5)

                            Button {
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                selectedBox = "Yearly"
                                unlockPro()
                            } label: {
                                PricingBox(title: "Yearly", price: yearlyPrice, selected: $selectedBox)
                            }.buttonStyle(NeumorphicPress())
                                .frame(width: width * 0.8, height: height * 0.08)
                                .padding(5)

                            Button {
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                selectedBox = "Monthly"
                                unlockPro()

                            } label: {
                                PricingBox(title: "Monthly", price: monthlyPrice, selected: $selectedBox)
                            }.buttonStyle(NeumorphicPress())
                                .frame(width: width * 0.8, height: height * 0.08)
                                .padding(5)


                            Section() {
                                VStack(alignment: .trailing, spacing: 0){
                                        ForEach(items, id: \.0){ item in
                                            HStack() {
                                                if item.1 == "😔" {
                                                    Text("\(item.0)")
                                                        .foregroundColor(.black)
                                                        .font(Font.mada(.bold, size: 16))
                                                        .frame(width: width * 0.3, alignment: .center)
                                                        .lineLimit(2)
                                                        .minimumScaleFactor(0.05)
                                                        .multilineTextAlignment(.center)
                                                } else {
                                                    Text("\(item.0)")
                                                        .foregroundColor(Clr.darkgreen)
                                                        .font(Font.mada(.semiBold, size: 16))
                                                        .frame(width: width * 0.25, alignment: .leading)
                                                        .lineLimit(2)
                                                        .minimumScaleFactor(0.05)
                                                        .multilineTextAlignment(.leading)
                                                }
                                                Divider()
                                                Text("\(item.1)")
                                                    .font(Font.mada(.regular, size: item.1 == "😔" || item.1 == "🔒" ? 32 : 18))
                                                    .frame(width: width * 0.175)


                                                Divider()
                                                if item.2 == "Infinite" {
                                                    Text("∞")
                                                        .font(Font.mada(.regular, size: 36))
                                                        .frame(width: width * 0.175)
                                                } else {
                                                    Text("\(item.2)")
                                                        .font(Font.mada(.regular, size: item.2 == "🤩" ? 32 : 32))
                                                        .frame(width: width * 0.175)
                                                }

                                                // etc
                                            }
                                            Divider()
                                        }
                                    }

                                .padding()
                                    .background(RoundedRectangle(cornerRadius: 14)
                                                    .fill(Clr.darkWhite)
                                                    .frame(width: width * 0.8, height: height * 0.55)
                                                    .neoShadow())
                                }.frame(width: width * 0.8, height: height * 0.6)
                            Text("Don't just take it from us\n⭐️⭐️⭐️⭐️⭐️")
                                .font(Font.mada(.bold, size: 22))
                                .foregroundColor(Clr.black2)
                                .multilineTextAlignment(.center)
                                .padding(.top)
                            SnapCarousel()
                                .padding(.bottom)
                                .environmentObject(UIStateModel())
                            VStack {
                                Text("🙋‍♂️ Frequent Asked Questions")
                                    .font(Font.mada(.bold, size: 22))
                                    .foregroundColor(Clr.black2)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom)
                                Text("\(question1 ? "🔽" : "▶️") How does the pro plan help me?")
                                    .font(Font.mada(.bold, size: 18))
                                    .foregroundColor(Clr.black2)
                                    .multilineTextAlignment(.leading)
                                    .frame(width: width * 0.8, alignment: .leading)
                                    .onTapGesture {
                                        withAnimation {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            question1.toggle()
                                        }
                                    }
                                if question1 {
                                    Text("Pro users are 72% more likely to stick with meditation vs non pro users. You have no limits for moods, gratitudes, and meditations. You feel invested, so you make sure to use the app daily.")
                                        .font(Font.mada(.semiBold, size: 16))
                                        .foregroundColor(Clr.black1)
                                        .multilineTextAlignment(.leading)
                                        .frame(width: width * 0.8, alignment: .leading)
                                        .padding(.leading, 5)
                                }
                                Divider()
                                Text("\(question2 ? "🔽" : "▶️") How do app subscriptions work?")
                                    .font(Font.mada(.bold, size: 18))
                                    .frame(width: width * 0.8, alignment: .leading)
                                    .foregroundColor(Clr.black2)
                                    .multilineTextAlignment(.leading)
                                    .onTapGesture {
                                        withAnimation {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            question2.toggle()
                                        }
                                    }
                                if question2 {
                                    Text("With a subscription you pay access to pro features that last for either a month or a year. Yearly plans have a 7 day free trial where you won't be billed until the trial is over. Lifetime plans are paid once and last forever.")
                                        .font(Font.mada(.semiBold, size: 16))
                                        .foregroundColor(Clr.black1)
                                        .multilineTextAlignment(.leading)
                                        .frame(width: width * 0.8, alignment: .leading)
                                        .padding(.leading, 5)
                                }
                                Divider()
                                Text("\(question3 ? "🔽" : "▶️") How do I cancel my subscription?")
                                    .font(Font.mada(.bold, size: 18))
                                    .frame(width: width * 0.8, alignment: .leading)
                                    .foregroundColor(Clr.black2)
                                    .multilineTextAlignment(.leading)
                                    .onTapGesture {
                                        withAnimation {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            question3.toggle()
                                        }
                                    }
                                if question3 {
                                    Text("You can easily cancel your subscription by going to the Settings App of your iphone and after selecting your apple ID, select subscriptions and simply click on MindGarden.")
                                        .font(Font.mada(.semiBold, size: 16))
                                        .foregroundColor(Clr.black1)
                                        .multilineTextAlignment(.leading)
                                        .frame(width: width * 0.8, alignment: .leading)
                                        .padding(.leading, 5)
                                }
                            }.padding(.bottom, 25)
                        }

                        VStack {
                            Button {
                                unlockPro()
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            } label: {
                                Capsule()
                                    .fill(Clr.yellow)
                                    .overlay(
                                        Text(selectedBox == "Yearly" ? "Start your free trial" : "Get MindGarden Pro")
                                            .foregroundColor(Clr.darkgreen)
                                            .font(Font.mada(.bold, size: 18))
                                    )
                            }.frame(width: width * 0.825, height: 50)
                                .buttonStyle(NeumorphicPress())
                            HStack {
                                Text("Privacy Policy")
                                    .foregroundColor(.gray)
                                    .font(Font.mada(.regular, size: 14))
                                    .onTapGesture {
                                        if let url = URL(string: "https://www.termsfeed.com/live/5201dab0-a62c-484f-b24f-858f2c69e581") {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                Spacer()
                                Text("Terms of Service")
                                    .foregroundColor(.gray)
                                    .font(Font.mada(.regular, size: 14))
                                    .onTapGesture {
                                        if let url = URL(string: "https:/mindgarden.io/terms-of-use") {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                            }.padding(.horizontal)
                        }.padding(10)
                            .padding(.bottom, K.isSmall() ? 50 : 0)
                        Spacer()
                    }.padding(.top, K.hasNotch() ? 30 : 10)
                }
            }.onAppear {
                Purchases.shared.offerings { [self] (offerings, error) in
                    if let offerings = offerings {
                        let offer = offerings.current
                        let packages = offer?.availablePackages
                        guard packages != nil else {
                            return
                        }
                        for i in 0...packages!.count - 1 {
                            let package = packages![i]
                            self.packagesAvailableForPurchase.append(package)
                            let product = package.product
                            let price = product.price
                            let name = product.productIdentifier

                            if name == "io.mindgarden.pro.monthly" {
                                monthlyPrice = round(100 * Double(truncating: price))/100
                            } else if name == "io.mindgarden.pro.yearly" {
                                yearlyPrice = round(100 * Double(truncating: price))/100
                            } else if name == "io.mindgarden.pro.lifetime" {
                                lifePrice = round(100 * Double(truncating: price))/100
                            }
                        }
                    }
                }
            }
    }

    private func unlockPro() {
        var price = 0.0
        var package = packagesAvailableForPurchase[0]
        var event2 = "_Started_From_All"
        var event3 = "cancelled_"
        switch selectedBox {
        case "Yearly":
            package = packagesAvailableForPurchase.last { (package) -> Bool in
                return package.product.productIdentifier == "io.mindgarden.pro.yearly"
            }!
            price = yearlyPrice
            event2 = "Yearly" + event2
            event3 += "yearly"
        case "Lifetime":
            package = packagesAvailableForPurchase.last { (package) -> Bool in
                return package.product.productIdentifier == "io.mindgarden.pro.lifetime"
            }!
            price = lifePrice
            event2 = "Lifetime" + event2
            event3 += "lifetime"
        case "Monthly":
            package = packagesAvailableForPurchase.last { (package) -> Bool in
                return package.product.productIdentifier == "io.mindgarden.pro.monthly"
            }!
            price = monthlyPrice
            event2 = "Monthly" + event2
            event3 += "monthly"
        default: break
        }

        Purchases.shared.purchasePackage(package) { [self] (transaction, purchaserInfo, error, userCancelled) in
            if purchaserInfo?.entitlements.all["isPro"]?.isActive == true {
                let event = logEvent()
                AppsFlyerLib.shared().logEvent(name: event, values:
                                                [
                                                    AFEventParamRevenue: price,
                                                    AFEventParamCurrency:"\(Locale.current.currencyCode!)"
                                                ])
                AppsFlyerLib.shared().logEvent(name: event2, values:
                                                                [
                                                                    AFEventParamContent: "true"
                                                                ])
                userIsPro()
            } else if userCancelled {
                AppsFlyerLib.shared().logEvent(name: event3, values:
                                                [
                                                    AFEventParamContent: "true"
                                                ])
                if event2 == "Lifetime_Started_From_All" {
                    let center = UNUserNotificationCenter.current()
                    let content = UNMutableNotificationContent()
                    content.title = "Don't Miss This Opportunity"
                    content.body = "🎉 MindGarden Pro For Life is Gone in the Next 24 Hours!!! 🎉"
                    // Step 3: Create the notification trigger
                    let date = Date().addingTimeInterval(43200)
                    let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    // Step 4: Create the request
                    let uuidString = UUID().uuidString
                    let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                    // Step 5: Register the request
                    center.add(request) { (error) in }
                }
            }
        }
    }
    private func userIsPro() {
        UserDefaults.standard.setValue(true, forKey: "isPro")
        userWentPro = true
        viewRouter.currentPage = .meditate
        if let _ = Auth.auth().currentUser?.email {
            let email = Auth.auth().currentUser?.email
            Firestore.firestore().collection(K.userPreferences).document(email!).updateData([
                "isPro": true,
            ]) { (error) in
                if let e = error {
                    print("There was a issue saving data to firestore \(e) ")
                } else {
                    print("Succesfully saved new items")
                }
            }
        }
    }
    private func logEvent(cancelled: Bool = false) -> String {
            var event = ""

            switch selectedBox {
            case "Yearly":
                event = "yearly_started_from_"
            case "Lifetime":
                event = "lifetime_started_from_"
            case "Monthly":
                event = "monthly_started_from_"
            default: break
            }

            if cancelled {
                event = "cancelled_" + event
            }
            if fromPage == "onboarding" {
                event = event + "onboarding"
            } else if fromPage == "onboarding2" {
                    event = event + "onboarding2"
            } else if fromPage == "profile" {
                event = event + "profile"
            } else if fromPage == "home" {
                event = event + "from_Home"
            } else if fromPage == "plusMeditation" {
                event = event + "Plus_Meditations"
            } else if fromPage == "plusMood" {
                event = event + "Plus_Mood"
            } else if fromPage == "plus_Gratitude" {
                event = event + "PlusGratitude"
            } else if fromPage == "lockedMeditation" {
                event = event + "Locked_Meditation"
            } else if fromPage == "middle" {
                event = event + "Middle_Locked"
            }
            return event
        }


    struct PricingBox: View {
        let title: String
        let price: Double
        @Binding var selected: String

        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(selected == title ? Clr.darkgreen : Clr.darkWhite)
//                    .border(Clr.yellow, width: selected == title ? 4 : 0)
                HStack {
                    Text("\(title) Pro\(title == "Yearly" ? "     " : "")")
                        .foregroundColor(selected == title ? .white : Clr.darkgreen)
                        .font(Font.mada(.semiBold, size: 20))
                        .lineLimit(1)
                        .minimumScaleFactor(0.05)
                        .multilineTextAlignment(.leading)
                        .padding([.top,.bottom, .leading, .trailing], 15)
                    if title == "Lifetime" || title == "Yearly" {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Clr.yellow)
                            .overlay(
                                Text(title == "Yearly" ? "7 day\nfree trial" : "Limited\nTime!")
                                    .foregroundColor(Clr.darkgreen)
                                    .font(Font.mada(.bold, size: 14))
                                    .multilineTextAlignment(.center)
                            )
                            .frame(width: 65,height: 35, alignment: .leading)
                    }
                    Spacer()
                    VStack(spacing: -4){
                        (Text(Locale.current.currencySymbol ?? "$") + Text("\(price, specifier: "%.2f")"))
                            .foregroundColor(selected == title ? .white : Clr.darkgreen)
                            .font(Font.mada(.semiBold, size: 24))
                            .lineLimit(1)
                            .minimumScaleFactor(0.05)

                        (Text("(" + (Locale.current.currencySymbol ?? "($")) + Text(title == "Yearly" ? "\(((round(100 * (price/12))/100) - 0.01), specifier: "%.2f")" : title == "Monthly" ? "\(price, specifier: "%.2f")" : "0.00") + Text("/mo)")
                       )
                            .foregroundColor(selected == title ? .white : Color.black)
                            .font(Font.mada(.regular, size: 14))
                            .lineLimit(1)
                            .minimumScaleFactor(0.05)
                    }.padding(.trailing)
                }
            }
        }
    }
}


struct PricingView_Previews: PreviewProvider {
    static var previews: some View {
        PricingView()
    }
}
