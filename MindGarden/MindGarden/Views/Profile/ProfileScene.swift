//
//  ProfileScene.swift
//  MindGarden
//
//  Created by Dante Kim on 7/6/21.
//

import SwiftUI

enum settings {
    case stats
    case journey
}
struct SideBarButtonStyle: ButtonStyle {
    var isTrue: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(isTrue ? Color.gray.opacity(0.5) : .clear)
    }
}

struct ProfileScene: View {
    @State private var selection: settings = .stats
    let colors = ["Red", "Green", "Blue", "Black", "Tartan"]

    var body: some View {
        NavigationView {
            VStack() {
                HStack {
                    Button {
                        selection = .stats
                    } label: {
                        Text("Stats")
                            .font(Font.mada(.bold, size: 24))
                            .foregroundColor(selection == .stats ? Clr.brightGreen : Clr.black1)
                    }.buttonStyle(SideBarButtonStyle(isTrue: selection == .stats))
                    HStack {
                        Divider()
                    }.frame(height: 25)
                    Button {
                        selection = .journey
                    } label: {
                        Text("Journey")
                            .font(Font.mada(.bold, size: 24))
                            .foregroundColor(selection == .journey ? Clr.brightGreen : Clr.black1)
                    }.buttonStyle(SideBarButtonStyle(isTrue: selection == .journey))
                }
                Divider()
                Spacer()
            }
        }
    }
}

struct ProfileScene_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScene()
    }
}
