//
//  TermsAndPrivacyView.swift
//  MindGarden
//
//  Created by apple on 04/04/23.
//

import SwiftUI

struct TermsAndPrivacyView: View {
    var body: some View {
        HStack {
            // PRIVACY POLICY
            Text("Privacy Policy")
                .foregroundColor(.gray)
                .font(Font.fredoka(.regular, size: 14))
                .onTapGesture {
                    MGAudio.sharedInstance.playBubbleSound()
                    if let url = URL(string: "https://www.termsfeed.com/live/5201dab0-a62c-484f-b24f-858f2c69e581") {
                        UIApplication.shared.open(url)
                    }
                }
            Spacer()
            // TERMS OF SERVICES
            Text("Terms of Service")
                .foregroundColor(.gray)
                .font(Font.fredoka(.regular, size: 14))
                .onTapGesture {
                    MGAudio.sharedInstance.playBubbleSound()
                    if let url = URL(string: "https:/mindgarden.io/terms-of-use") {
                        UIApplication.shared.open(url)
                    }
                }
        } //: HStack
        .padding(.horizontal)
    }
}

struct TermsAndPrivacyView_Previews: PreviewProvider {
    static var previews: some View {
        TermsAndPrivacyView()
    }
}
