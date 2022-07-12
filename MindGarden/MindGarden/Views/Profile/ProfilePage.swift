//
//  ProfilePage.swift
//  MindGarden
//
//  Created by Dante Kim on 7/11/22.
//

import SwiftUI
import Firebase
import WidgetKit

struct ProfilePage: View {
    @EnvironmentObject var gardenModel: GardenViewModel
    
    var profileModel: ProfileViewModel
    var width: CGFloat
    var height: CGFloat
    var totalSessions: Int
    var totalMins: Int
    @State private var text = ""
    @State private var response = ""
    var body: some View {
        ZStack {
            Clr.darkWhite.edgesIgnoringSafeArea(.all)
            VStack {
                VStack(alignment: .center, spacing: 10) {
                    Text("Your Mindfulness Journey")
                        .font(Font.fredoka(.medium, size: 24))
                        .foregroundColor(Clr.black2)
                        .frame(width: UIScreen.screenWidth * 0.85, alignment: .leading)
                    Text("7 Mindful Days")
                        .font(Font.fredoka(.regular, size: 20))
                        .foregroundColor(Clr.black2)
                        .frame(width: UIScreen.screenWidth * 0.85, alignment: .leading)
                    HStack(alignment: .center, spacing: 5) {
                        ProfileBox(img: Img.veryGoodPot, count: 3)
                        ProfileBox(img: Img.meditateTurtle, count: 4)
                        ProfileBox(img: Img.streak, count: UserDefaults.standard.integer(forKey: "longestStreak"))
                    }.padding(.top)
                    HStack(alignment: .center, spacing: 5) {
                        ProfileBox(img: Img.veryGoodPot, count: 72)
                        ProfileBox(img: Img.breathIcon, count: 22)
                        ProfileBox(img: Img.flowers, count: 14)
                    }
                }.frame(width: width * 0.8, height: 160)
                    .padding()
                ScrollView(showsIndicators: false) {
                    ZStack {
                        Rectangle()
                            .fill(Clr.darkWhite)
                            .cornerRadius(14)
                            .addBorder(.black,width:1.5, cornerRadius: 14)
                            .frame(width: width * 0.85, height: height * 0.35)
                            .neoShadow()
                        VStack(alignment: .leading) {
                            Text("July 14, Tuesday")
                                .font(Font.fredoka(.medium, size: 20))
                                .foregroundColor(Clr.brightGreen)
                                .frame(width: width * 0.75, alignment: .leading)
                            HStack(alignment: .center, spacing: 10) {
                                
                                
                            }.frame(width: width * 0.75, height: 75, alignment: .leading)
                        }
                    }.frame(width: width * 0.85, height: height * 0.35)
                }.frame(width: width)
                .padding()
                Text(response)
                    .foregroundColor(Clr.darkgreen)
                    .font(Font.fredoka(.semiBold, size: 16))
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
                                        print("Succesfully saved pro")
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
                            Text("Submit")
                                .font(Font.fredoka(.semiBold, size: 16))
                                .foregroundColor(.black)
                                .lineLimit(1)
                                .minimumScaleFactor(0.05)
                        }
                    }.buttonStyle(NeumorphicPress( ))
                }.frame(width: width * 0.75,height: 35)
                    .keyboardResponsive()
            }
        }.onAppear {
            fetchHistory()
        }
    }
    
    func fetchHistory() {
       
   }
    struct ProfileBox: View {
        let img: Image
        let count: Int
        
        var body: some View {
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(Clr.brightGreen)
                    .addBorder(.black, width: 1.5, cornerRadius: 14)
                    .neoShadow()
                VStack(alignment:.center){
                    HStack(spacing:5) {
                        img
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25)
                        (      Text("\(count)")
                            .font(Font.fredoka(.bold, size: 28))
                               + (img == Img.streak ? img == Img.flowers ? Text(" plants") : Text(" days") : Text("x"))
                            .font(Font.fredoka(.regular, size: 16)))
                        .minimumScaleFactor(0.7)
                        .foregroundColor(Color.white)
                           
                        
                    }
                    .padding(.horizontal, 5)
                }
            }.frame(width: UIScreen.screenWidth * 0.275, height: 60, alignment: .center)


        }
    }
}

struct ProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePage(profileModel: ProfileViewModel(), width: UIScreen.screenWidth, height: UIScreen.screenHeight, totalSessions: 0, totalMins: 0)
    }
}
