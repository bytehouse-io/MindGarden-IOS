//
//  NotificationScene.swift
//  MindGarden
//
//  Created by Dante Kim on 9/5/21.
//

import SwiftUI

struct NotificationScene: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var dateTime = Date()
    @State private var bottomSheetShown = false
    @State private var goToAuthentication = false
    var displayedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: dateTime)
    }
    init() {
        //        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        //        UINavigationBar.appearance().shadowImage = UIImage()
    }

    var body: some View {
        NavigationView {
            GeometryReader { g in
                let width = g.size.width
                ZStack {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                    VStack(spacing: -5) {
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
                            UserDefaults.standard.setValue(dateTime, forKey: K.defaults.meditationReminder)
                            withAnimation {
                                viewRouter.currentPage = .authentication
                            }
                        } label: {
                            Capsule()
                                .fill(Clr.darkWhite)
                                .overlay(
                                    Text("Continue")
                                        .foregroundColor(Clr.darkgreen)
                                        .font(Font.mada(.bold, size: 20))
                                )
                        }.frame(height: 50)
                        .padding()
                        .buttonStyle(NeumorphicPress())
                        Text("Skip")
                            .foregroundColor(.gray)
                            .padding()
                            .onTapGesture {
                                withAnimation {
                                    goToAuthentication = true
                                }
                            }
                    }.frame(width: width * 0.9)
                    if bottomSheetShown {
                        Color.black
                            .opacity(0.2)
                            .edgesIgnoringSafeArea(.all)
                        Spacer()
                    }
                }
                BottomSheetView(
                    dateSelected: $dateTime,
                    isOpen: self.$bottomSheetShown,
                    maxHeight: g.size.height * 0.6
                ) {
                    HStack {
                        DatePicker("", selection: $dateTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                            .offset(y: -25)
                    }.frame(width: width, alignment: .center)
                }.offset(y: g.size.height * 0.3)
            }.navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(trailing: Image(systemName: "arrow.backward")
                                    .font(.title)
                                    .foregroundColor(Clr.darkgreen)
                                    .padding()
                                    .onTapGesture {
                                        viewRouter.currentPage = .experience
                                    }
            )
        }
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
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    self.isOpen = value.translation.height < 0
                }
            )
        }
    }
}
