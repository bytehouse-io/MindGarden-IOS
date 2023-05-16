//
//  MWMManager.swift
//  MindGarden
//
//  Created by apple on 04/04/23.
//

import Foundation
import MWMPublishingSDK

final class MWMManager {
    static let shared = MWMManager()
    
    /// In order to purchase an IAP product
    func anyFunction() {
        MWM.inAppManager().purchaseIAP("<your IAP identifier>") { [weak self] success, error in
            if success {
                // The purchase has succeeded
            } else {
                // Handle error
            }
        }
    }
    
    /// restore previous purchases with the following method:
    func restorePurchases(completion: @escaping (MWMRestoreResult) -> ()) {
        MWM.inAppManager().restore { result in
            completion(result)
        }
    }
    
    /// In order to know if a user has unlocked any premium feature
    func isUserPremium() -> Bool {
        MWM.inAppManager().isAnyPremiumFeatureUnlocked()
    }

}
