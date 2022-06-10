//
//  LeaveFeedback.swift
//  MindGarden
//
//  Created by Vishal Davara on 09/06/22.
//

import SwiftUI
import FirebaseDynamicLinks
import Firebase

enum FeedbackType: String {
    case happy,confused,unhappy
    
    var title : String {
        switch self {
        case .happy:
            return "We'd love to know how we can make mindgarden even better and would really appriciate if you left review on the app store."
        case .confused:
            return "if you'er unsure about how to use mindgarden, why not visit the help center or contact the mind garden team."
        case .unhappy:
            return "We'e love to know we can make mind garden even better, and make your experience with mind garden a happy one."
        }
    }
}

struct LeaveFeedback: View {
    
    var userModel: UserViewModel
    @Binding var selectedFeedback:FeedbackType
    
    @State private var isSharePresented: Bool = false
    @State private var urlShare2 = URL(string: "https://mindgarden.io")
    @Environment(\.presentationMode) var presentationMode
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        return dateFormatter
    }()
    
    var body: some View {
        ZStack {
            Clr.darkWhite
            VStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        ZStack {
                            Image(systemName: "xmark")
                                .foregroundColor(.gray)
                                .frame(width: 50, height: 50)
                                .padding()
                         
                        }.frame(width: 50, height: 50)
                        .cornerRadius(25)
                    }
                    .buttonStyle(NeumorphicPress())
                    Spacer()
                }
                Spacer()
            }
            VStack {
                Spacer()
                    .frame(height:100)
                Text("Leave Feedback")
                    .font(Font.mada(.bold, size: 30))
                    .foregroundColor(Clr.darkgreen)
                
                Text(selectedFeedback.title)
                    .font(Font.mada(.regular, size: 18))
                    .foregroundColor(Clr.black2)
                    .padding()
                VStack {
                    switch selectedFeedback {
                    case .happy:
                        writeReview
                        Divider()
                            .padding(.horizontal)
                        contactTeam
                        Divider()
                            .padding(.horizontal)
                        inviteFriend
                    case .confused:
                        gettingStartedGuid
                        Divider()
                            .padding(.horizontal)
                        contactTeam
                    case .unhappy:
                        contactTeam
                    }
                }
                .frame(width:UIScreen.screenWidth*0.85)
                .background(
                    Rectangle()
                        .fill(Clr.darkWhite)
                        .cornerRadius(10)
                        .neoShadow()
                )
                
                .padding(20)
                Spacer()
            }
        }
        .ignoresSafeArea()
        .sheet(isPresented: $isSharePresented) {
            ReferralView(url: $urlShare2)
        }
    }
    
    var writeReview: some View {
        Button {
            if let url = URL(string: "https://tally.so/r/3EB1Bw") {
                UIApplication.shared.open(url)
            }
        } label: {
            HStack {
                Image(systemName: "doc.on.clipboard")
                    .foregroundColor(Clr.darkgreen)
                Text("Write a Review")
                    .font(Font.mada(.medium, size: 25))
                    .foregroundColor(Clr.black2)
                Spacer()
            }
        }
        .padding()
    }
    
    var contactTeam: some View {
        Button {
        } label: {
            HStack {
                Image(systemName: "envelope.fill")
                    .foregroundColor(Clr.darkgreen)
                Text("Contact Mindgarden Team")
                    .font(Font.mada(.medium, size: 25))
                    .foregroundColor(Clr.black2)
                Spacer()
            }
        }
        .padding()
    }
    
    var inviteFriend: some View {
        Button {
            sendInvite()
        } label: {
            HStack {
                Image(systemName: "arrowshape.turn.up.right.fill")
                    .foregroundColor(Clr.darkgreen)
                Text("Invite a Firend")
                    .font(Font.mada(.medium, size: 25))
                    .foregroundColor(Clr.black2)
                Spacer()
            }
        }
        .padding()
    }
    
    var gettingStartedGuid: some View {
        Button {
        } label: {
            HStack {
                Image(systemName: "questionmark.circle.fill")
                    .foregroundColor(Clr.darkgreen)
                Text("Getting Started Guid")
                    .font(Font.mada(.medium, size: 25))
                    .foregroundColor(Clr.black2)
                Spacer()
            }
        }
        .padding()
    }
    
    func sendInvite() {
        guard let uid = Auth.auth().currentUser?.email else {
            return
        }
        
        guard let link = URL(string: "https://mindgarden.io?referral=\(uid)") else { return }
        let referralLink = DynamicLinkComponents(link: link, domainURIPrefix: "https://mindgarden.page.link")


        if let myBundleId = Bundle.main.bundleIdentifier {
            referralLink?.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)
            referralLink?.iOSParameters?.minimumAppVersion = "1.44"
            referralLink?.iOSParameters?.appStoreID = "1588582890"
        }

        let newDate = Calendar.current.date(byAdding: .day, value: 2, to: Date())
        let newDateString = dateFormatter.string(from: newDate ?? Date())
        referralLink?.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        referralLink?.socialMetaTagParameters?.title = "\(userModel.name) has invited you to 👨‍🌾 MindGarden"
        referralLink?.socialMetaTagParameters?.descriptionText = "📱 Download the app by \(newDateString) to claim your free trial"
        guard let imgUrl = URL(string: "https://i.ibb.co/1GW6YxY/MINDGARDEN.png") else { return }
        referralLink?.socialMetaTagParameters?.imageURL = imgUrl
        referralLink?.shorten { (shortURL, warnings, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            urlShare2 = shortURL!
            isSharePresented = true
        }
    }
}


struct LeaveFeedback_Previews: PreviewProvider {
    static var previews: some View {
        LeaveFeedback(userModel: UserViewModel(), selectedFeedback: .constant(.happy))
    }
}
