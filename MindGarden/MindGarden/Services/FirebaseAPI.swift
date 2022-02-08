//
//  FirebaseAPI.swift
//  MindGarden
//
//  Created by Dante Kim on 2/7/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore


struct FirebaseAPI {
    let db = Firestore.firestore()
    func fetchMeditations() {
        db.collection("Meditation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }

    }
}
