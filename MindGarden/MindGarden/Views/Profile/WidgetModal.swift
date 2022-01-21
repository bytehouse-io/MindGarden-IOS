//
//  NewUpdateModal.swift
//  MindGarden
//
//  Created by Dante Kim on 10/4/21.
//

import SwiftUI

struct WidgetModal: View {
    @Binding var shown: Bool

    var body: some View {
        GeometryReader { g in
            VStack(spacing: 10) {
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .center, spacing: 0) {
                        HStack {
                            Spacer()
                            Text("⚙️ Adding our Widget")
                                .font(Font.mada(.bold, size: 28))
                                .foregroundColor(Clr.black2)
                                .frame(height: g.size.height * 0.12)
                            Spacer()
                        }.padding([.horizontal, .top])
                        HStack {
                            Text("1. Long press on your IPhone's homescreen")
                        }.multilineTextAlignment(.leading)
                            .font(Font.mada(.regular, size: 20))
                            .foregroundColor(Clr.black2)
                            .frame(width: g.size.width * 0.85 * 0.8, alignment: .leading)
                            .padding(.bottom, 10)
                        HStack {
                            Text("2. Tap the '+' buttoon in the top left corner")
                        }.multilineTextAlignment(.leading)
                            .font(Font.mada(.regular, size: 20))
                            .foregroundColor(Clr.black2)
                            .frame(width: g.size.width * 0.85 * 0.8, alignment: .leading)
                            .padding(.bottom, 10)
                        HStack {
                            Text("3. Find and tap on the MindGarden widget")
                        }.multilineTextAlignment(.leading)
                            .font(Font.mada(.regular, size: 20))
                            .foregroundColor(Clr.black2)
                            .frame(width: g.size.width * 0.85 * 0.8, alignment: .leading)
                            .padding(.bottom, 10)
                        HStack {
                            Text("4. Tap the 'Add Widget' button search for MindGarden on your homescreen.")
                        }.multilineTextAlignment(.leading)
                            .font(Font.mada(.regular, size: 20))
                            .foregroundColor(Clr.black2)
                            .frame(width: g.size.width * 0.85 * 0.8, alignment: .leading)
                            .padding(.bottom, 10)
                        Spacer()
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation {
                                shown = false
                                UserDefaults.standard.setValue(true, forKey: "1.3Update")
                            }
                        } label: {
                            Capsule()
                                .fill(Clr.brightGreen)
                                .overlay(
                                    Text("Got it!")
                                        .font(Font.mada(.bold, size: 18))
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                )
                                .frame(width: g.size.width * 0.7 * 0.5, height: g.size.height * 0.05)
                        }.buttonStyle(NeumorphicPress())
                            .padding([.horizontal, .bottom])
                        Spacer()
                    }
                    .font(Font.mada(.regular, size: 18))
                    .frame(width: g.size.width * 0.85, height: g.size.height * (K.hasNotch() ? 0.65 : 0.7), alignment: .center)
                    .minimumScaleFactor(0.05)
                    .background(Clr.darkWhite)
                    .neoShadow()
                    .cornerRadius(12)
                    .offset(y: -50)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct WidgetModalPreview: PreviewProvider {
    static var previews: some View {
        WidgetModal(shown: .constant(true))
    }
}
