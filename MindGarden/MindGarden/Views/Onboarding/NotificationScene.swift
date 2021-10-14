//
//  NotificationScene.swift
//  MindGarden
//
//  Created by Dante Kim on 9/5/21.
//

import SwiftUI

struct NotificationScene: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var dateTime = Date()
    @State private var bottomSheetShown = false
    var fromSettings: Bool

    var displayedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: dateTime)
    }

    init(fromSettings: Bool = false) {
        self.fromSettings = fromSettings
        //        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        //        UINavigationBar.appearance().shadowImage = UIImage()
    }

    var body: some View {
        ZStack {
            GeometryReader { g in
                let width = g.size.width
                ZStack {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                    VStack(spacing: -5) {
                        HStack {
                            Img.topBranch.padding(.leading, -20)
                            Spacer()
                            Image(systemName: "arrow.backward")
                                .font(.system(size: 22))
                                .foregroundColor(Clr.darkgreen)
                                .padding()
                                .onTapGesture {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    if fromSettings {
                                        presentationMode.wrappedValue.dismiss()
                                    } else {
                                        viewRouter.currentPage = .experience
                                    }
                                }
                                .opacity(fromSettings ? 0 : 1)
                                .disabled(fromSettings)
                        }
                        VStack {
                            Text("Set Your Daily Reminder")
                                .font(Font.mada(.bold, size: 30))
                                .foregroundColor(Clr.darkgreen)
                                .multilineTextAlignment(.center)
                            Text("You're twice as likely to stick with the habit of meditation if you set a reminder. Pick a time you want us to give you a nudge.")
                                .font(Font.mada(.light, size: 20))
                                .foregroundColor(Clr.black1)
                                .multilineTextAlignment(.center)
                                .padding()
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                                    bottomSheetShown.toggle()
                                }
                            } label: {
                                Rectangle()
                                    .fill(Clr.yellow)
                                    .cornerRadius(12)
                                    .frame(width: width * 0.6, height: 75)
                                    .overlay(
                                        HStack {
                                            Text("\(displayedTime)")
                                                .font(Font.mada(.bold, size: 40))
                                                .foregroundColor(.black)
                                            Image(systemName: "chevron.down")
                                                .font(Font.title)
                                        }
                                    )
                            }.buttonStyle(NeumorphicPress())
                                .padding()
                            Spacer()
                            Button {
                                Analytics.shared.log(event: .notification_tapped_turn_on)
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                UserDefaults.standard.setValue(dateTime, forKey: K.defaults.meditationReminder)
                                withAnimation {
                                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                        if success {
                                            Analytics.shared.log(event: .notification_success)
                                            UserDefaults.standard.setValue(dateTime, forKey: "notif")
                                            UserDefaults.standard.setValue(true, forKey: "notifOn")
                                            let content = UNMutableNotificationContent()
                                            content.title = "It's time to meditate"
                                            content.subtitle = "Let's grow and become 1% happier and more present today."
                                            content.sound = UNNotificationSound.default

                                            let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dateTime)
                                            let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)

                                            // choose a random identifier
                                            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                                            // add our notification request
                                            UNUserNotificationCenter.current().add(request)
                                            DispatchQueue.main.async {
                                                if fromSettings {
                                                    presentationMode.wrappedValue.dismiss()
                                                } else {
                                                    viewRouter.currentPage = .name
                                                }
                                            }
                                        } else if let error = error {
                                            print(error.localizedDescription)
                                        } else {
                                            
                                            if fromSettings {
                                                presentationMode.wrappedValue.dismiss()
                                            } else {
                                                viewRouter.currentPage = .name
                                            }
                                        }
                                    }
                                }
                            } label: {
                                Capsule()
                                    .fill(Clr.darkWhite)
                                    .overlay(
                                        Text(fromSettings ? "Turn On" : "Continue")
                                            .foregroundColor(Clr.darkgreen)
                                            .font(Font.mada(.bold, size: 20))
                                    )
                            }.frame(height: 50)
                                .padding()
                                .buttonStyle(NeumorphicPress())
                            if !fromSettings {
                                Text("Skip")
                                    .foregroundColor(.gray)
                                    .padding()
                                    .onTapGesture {
                                        Analytics.shared.log(event: .notification_tapped_skip)
                                        withAnimation {
                                            viewRouter.currentPage = .name
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        }
                                    }
                            }
                        }.frame(width: width * 0.9)
                        .padding(.top, 40)
                    }
                    if bottomSheetShown  {
                        Color.black
                            .opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                        Spacer()
                    }
                }
                BottomSheetView(
                    dateSelected: $dateTime,
                    isOpen: self.$bottomSheetShown,
                    maxHeight: g.size.height * (fromSettings ? 0.45 : 0.6)
                ) {
                    if fromSettings {
                        HStack {
                            if #available(iOS 14.0, *) {
                                DatePicker("", selection: $dateTime, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .labelsHidden()
                                    .offset(y: -25)
                            } else {
                                // Fallback on earlier versions
                            }
                        }.frame(width: width, alignment: .center)
                    } else {
                        DatePicker("", selection: $dateTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                            .offset(y: -25)
                    }

                }.offset(y: g.size.height * 0.3)
            }
        }.onAppearAnalytics(event: .screen_load_notification)
    }
}

struct NotificationScene_Previews: PreviewProvider {
    static var previews: some View {
        NotificationScene()
    }
}

fileprivate enum Constants {
    static let radius: CGFloat = 16
    static let indicatorHeight: CGFloat = 6
    static let indicatorWidth: CGFloat = 60
    static let snapRatio: CGFloat = 0.25
    static let minHeightRatio: CGFloat = 0.3
}

struct BottomSheetView<Content: View>: View {
    @GestureState private var translation: CGFloat = 0
    @Binding var dateSelected: Date
    @Binding var isOpen: Bool
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }

    private var indicator: some View {
        HStack {
            Text("Done").padding().foregroundColor(Clr.darkWhite)
            Spacer()
            RoundedRectangle(cornerRadius: Constants.radius)
                .fill(Color.secondary)
                .frame(
                    width: Constants.indicatorWidth,
                    height: Constants.indicatorHeight
                )
            Spacer()
            Text("Done")
                .font(Font.mada(.bold, size: 18))
                .foregroundColor(Clr.darkgreen)
                .onTapGesture {
                    Analytics.shared.log(event: .notification_tapped_done)
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    self.isOpen.toggle()
                }
                .padding(.horizontal)
        }
    }

    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content

    init(dateSelected: Binding<Date>, isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.minHeight = maxHeight * Constants.minHeightRatio
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
        self._dateSelected = dateSelected
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                self.indicator.padding()
                self.content
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(Constants.radius)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring(), value: isOpen)
            .animation(.interactiveSpring(), value: translation)
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * Constants.snapRatio
                    guard abs(value.translation.height) > snapDistance else { return }
                    self.isOpen = value.translation.height < 0
                }
            )
        }
    }
}
