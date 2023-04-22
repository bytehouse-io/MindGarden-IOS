//
//  HelperFunctions.swift
//  MindGarden
//
//  Created by apple on 22/04/23.
//

import Foundation

func onMainThread(_ completion: @escaping () -> Void) {
    DispatchQueue.main.async {
        completion()
    }
}
