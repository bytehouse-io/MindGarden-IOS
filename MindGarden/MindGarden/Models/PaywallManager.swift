//
//  PaywallManager.swift
//  MindGarden
//
//  Created by Dante Kim on 2/26/22.
//

import Paywall
import StoreKit
import Purchases // This example uses RevenueCat
import AppsFlyerLib
import Amplitude
import Firebase

class PaywallManager: PaywallDelegate {
    static var shared = PaywallManager()
    
    func purchase(product: SKProduct) {
        
    // TODO: Purchase the product. Below example uses RevenueCat
    
        Purchases.shared.purchaseProduct(product) { transaction, purchaserInfo, error, userCanceled in
            // check purchaserInfo and unlock the app if the user is paying.
            // no need to handle any errors or dismiss the paywall, Superwall does this for you automatically
        }
    }
    
    func shouldPresentPaywall() -> Bool {
        return false
    }
    

    func restorePurchases(completion: @escaping (Bool) -> ()) {
        
    // TODO: Restore Purchases. Below example uses RevenueCat.
    
    // Call `completion(false)` if the restore fails, `completion(true)` if it succeeds
        Purchases.shared.restoreTransactions { (purchaserInfo, error) in

            if let purchaserInfo = purchaserInfo {
                if let entitlement = purchaserInfo.entitlements["membership"] {
                    if entitlement.isActive {
                        completion(true)
                        return
                    }
                }
            }
            
            completion(false)

        }
    }
    
  func isUserSubscribed() -> Bool {
        
    // TODO: Return true if the user is subscribed, otherwise return false
      if UserDefaults.standard.bool(forKey: "isPro") {
          return true
      } else {
          return false
      }
  }
    
    func reset() {
        Paywall.reset()
    }
    
    
    func shouldTrack(event: String, params: [String : Any]) {}
}
