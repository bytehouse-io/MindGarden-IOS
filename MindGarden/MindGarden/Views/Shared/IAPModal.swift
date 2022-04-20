//
//  IAPModal.swift
//  MindGarden
//
//  Created by Dante Kim on 4/3/22.
//

import SwiftUI
import Purchases
import AppsFlyerLib
import Amplitude

enum IAPType {
    case freeze,potion,chest
}

struct IAPModal: View {
    @EnvironmentObject var userModel: UserViewModel
    @Binding var shown: Bool
    var fromPage: String
    @State private var freezePrice = 0.0
    @State private var potionPrice  = 0.0
    @State private var chestPrice  = 0.0
    @State private var packagesAvailableForPurchase = [Purchases.Package]()
    @Binding var alertMsg: String
    @Binding var showAlert: Bool

    //TODO if user has a potion or chest activated can't purchase more or the other.
    //TODO give user the ability to stack freeze streaks
    
    var body: some View {
        GeometryReader { g in
            VStack(spacing: 10) {
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .center, spacing: 0) {
                        VStack(spacing: 0) {
                            ZStack(alignment: .top) {
                                Img.coverImage
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                Button {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    withAnimation { shown.toggle() }
                                } label: {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.gray.opacity(0.85))
                                        .font(.system(size: 22))
                                        .padding()
                                }.position(x: 30, y: 25)
                            }
                            Text("Potion Shop")
                                    .font(Font.mada(.bold, size: 24))
                                    .foregroundColor(Clr.black1)
                            if userModel.streakFreeze > 0 {
                                Text("You have \(userModel.streakFreeze) streak freeze" + "\(userModel.streakFreeze == 1 ? " " : "s ")" + "equipped")
                                    .font(Font.mada(.semiBold, size: 16))
                                    .foregroundColor(Clr.freezeBlue)
                            } else {
                                Text("Purchases will activate immediately")
                                    .font(Font.mada(.semiBold, size: 16))
                                    .foregroundColor(Clr.black1)
                                    .opacity(0.8)
                            }
                            
                            Spacer()
                            Spacer()
                            Spacer()
                        }
                        .frame(width: g.size.width * 0.85, height: g.size.height * (K.isSmall() ? 0.3 : 0.25), alignment: .top)
                        VStack {
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                Analytics.shared.log(event: .IAP_tapped_freeze)
                                userModel.streakFreeze += 2
                                userModel.saveIAP()
                            } label: {
                                PurchaseBox(width: g.size.width, height: g.size.height, img: Img.freezestreak, title: "Freeze Streak (2x)", subtitle: "Protect your streak (twice) if you a miss a day of meditation. ", price: freezePrice, type: .freeze)
                            }.padding(.bottom, 10)
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                Analytics.shared.log(event: .IAP_tapped_potion)
                                if !userModel.isPotion && !userModel.isChest {
                                    onSuccess(type: .potion)
                                }
                            } label: {
                                PurchaseBox(width: g.size.width, height: g.size.height, img: Img.sunshinepotion, title: "Sunshine Potion", subtitle: "Potion will activate & triple coins after every meditation for 1 WEEK", price: potionPrice, type: .potion)
                            }.padding(.bottom, 10)
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                Analytics.shared.log(event: .IAP_tapped_chest)
                                if !userModel.isPotion && !userModel.isChest {
                                    onSuccess(type: .chest)
                                }
                            } label: {
                                PurchaseBox(width: g.size.width, height: g.size.height, img: Img.sunshinechest, title: "Sunshine Chest", subtitle: "Potion will activate & triple coins after every meditation for 3 WEEKs", price: chestPrice, type: .chest)
                            }.padding(.bottom, 10)
                             
                        }.frame(height: g.size.height * 0.4)
                        Spacer()
                    }
                    .frame(width: g.size.width * 0.85, height: g.size.height * (K.isSmall() ? 0.75 : 0.7), alignment: .center)
                    .background(Clr.darkWhite)
                    .cornerRadius(12)
                    Spacer()
                }
                Spacer()
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

                        if name == "io.bytehouse.mindgarden.freeze" {
                            freezePrice = round(100 * Double(truncating: price))/100
                        } else if name == "io.bytehouse.mindgarden.potion" {
                            potionPrice = round(100 * Double(truncating: price))/100
                        } else if name == "io.bytehouse.mindgarden.chest" {
                            chestPrice = round(100 * Double(truncating: price))/100
                        }
                    }
                }
            }

        }
    }
    
    private func onSuccess(type:IAPType) {
        switch type {
        case .freeze:
            alertMsg = "Freeze streak purchase was successful"
        case .potion:
            alertMsg = "Sunshine potion purchase was successful"
            userModel.potion = Date().getdateAfterweek(week: 1)?.toString() ?? ""
        case .chest:
            alertMsg = "Sunshine chest purchase was successful"
            userModel.chest = Date().getdateAfterweek(week: 3)?.toString() ?? ""
        }
        userModel.saveIAP()
        userModel.updateSelf()
        showAlert = true
    }
    
    private func unlockPurchase(selectedBox: String) {
        var price = 0.0
        var package = packagesAvailableForPurchase[0]
        var event2 = "_started_from_all"
        var event3 = "cancelled_"
        switch selectedBox {
        case "freeze":
            package = packagesAvailableForPurchase.last { (package) -> Bool in
                return package.product.productIdentifier == "io.bytehouse.mindgarden.freeze"
            }!
            price = freezePrice
            event2 = "freeze" + event2
            event3 += "freeze"
        case "potion":
            package = packagesAvailableForPurchase.last { (package) -> Bool in
                return package.product.productIdentifier == "io.bytehouse.mindgarden.potion"
            }!
            price = potionPrice
            event2 = "potion" + event2
            event3 += "potion"
        case "chest":
            package = packagesAvailableForPurchase.last { (package) -> Bool in
                return package.product.productIdentifier == "io.bytehouse.mindgarden.monthly"
            }!
            price = chestPrice
            event2 = "chest" + event2
            event3 += "chest"
        default: break
        }

        Purchases.shared.purchasePackage(package) { [self] (transaction, purchaserInfo, error, userCancelled) in
            let event = logEvent(selectedBox: selectedBox)
            let revenue = AMPRevenue().setProductIdentifier(event)
            revenue?.setPrice(NSNumber(value: price))

            if purchaserInfo?.entitlements.all["freeze"]?.isActive == true {
                logRevenue(event: event, event2: event2, price: price)
                userModel.streakFreeze += 2
//                userIsPro()
            } else if purchaserInfo?.entitlements.all["potion"]?.isActive == true  {
                logRevenue(event: event, event2: event2, price: price)
            } else if purchaserInfo?.entitlements.all["potion"]?.isActive == true  {
                logRevenue(event: event, event2: event2, price: price)
            } else if userCancelled {
                AppsFlyerLib.shared().logEvent(name: event3, values:
                                                [
                                                    AFEventParamContent: "true"
                                                ])
                Amplitude.instance().logEvent(event3)
            }
        }
    }
    
    private func logRevenue(event: String, event2: String, price: Double) {
        AppsFlyerLib.shared().logEvent(name: event, values:
                                                        [
                                                            AFEventParamContent: "true"
                                                        ])
        Amplitude.instance().logEvent(event2, withEventProperties: ["revenue": "\(price)"])
        Amplitude.instance().logEvent(event, withEventProperties: ["revenue": "\(price)"])

    AppsFlyerLib.shared().logEvent(name: event2, values:
                                                    [
                                                        AFEventParamContent: "true"
                                                    ])
    }
    
    private func logEvent(selectedBox: String) -> String {
            var event = ""

            switch selectedBox {
            case "freeze":
                event = "freeze_started_from_"
            case "potion":
                event = "potion_started_from_"
            case "chest":
                event = "chest_started_from_"
            default: break
            }

            event += fromPage
        
            return event
        }
    struct PurchaseBox: View {
        @EnvironmentObject var userModel: UserViewModel
        let width, height: CGFloat
        let img: Image
        let title: String
        let subtitle: String
        let price: Double
        let type: IAPType
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

        var body: some View {
            ZStack(alignment: .center){
                Rectangle()
                    .fill(Clr.darkWhite)
                    .cornerRadius(15)
                    .neoShadow()
                Capsule()
                    .fill(Clr.yellow)
                    .frame(width: 75, height: 25)
                    .neoShadow()
                    .overlay(HStack(spacing: 5) {
                        if (type == .potion && userModel.isPotion) || (type == .chest && userModel.isChest) {
                            Text("\(userModel.timeRemaining.stringFromTimeInterval())")
                                .foregroundColor(Clr.darkgreen)
                                .font(Font.mada(.medium, size: 16))
                        } else {
                            Img.moneybag
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 12)
                            Text("\(price,  specifier: "%.2f")")
                                .foregroundColor(Clr.darkgreen)
                                .font(Font.mada(.medium, size: 16))
                        }
                    })
                    .position(x: width * 0.615, y: height * 0.03)
                HStack(spacing: 10){
                    img
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35)
                    VStack(alignment: .leading) {
                        HStack {
                            Text(title)
                                .foregroundColor(title == "Freeze Streak (2x)" ? Clr.freezeBlue : Clr.sunshine)
                                .font(Font.mada(.bold, size: K.isSmall() ? 16 : 18))
                        }
                        Text(subtitle)
                            .foregroundColor(Clr.black2)
                            .font(Font.mada(.medium, size: 14))
                            .lineLimit(2)
                            .minimumScaleFactor(0.05)
                    }.frame(width: width * 0.5)
                        .padding(.trailing)
                        .multilineTextAlignment(.leading)
                }.frame(width: width * 0.75)
            }
            .onReceive(timer) { time in
                if userModel.timeRemaining > 0 {
                    userModel.timeRemaining -= 1
                }
            }
            .frame(width: width * 0.75, height: height * 0.125)
            .padding(.horizontal)
        }
    }
}

struct IAPModal_Previews: PreviewProvider {
    static var previews: some View {
        IAPModal(shown: .constant(false), fromPage: "home", alertMsg: .constant(""), showAlert: .constant(false))
    }
}
