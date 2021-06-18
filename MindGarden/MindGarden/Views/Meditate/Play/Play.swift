//
//  Play.swift
//  MindGarden
//
//  Created by Dante Kim on 6/18/21.
//

import SwiftUI

struct Play: View {
    @State var progressValue: Float = 0.35

    var body: some View {
        NavigationView {
            ZStack {
                Clr.darkWhite.edgesIgnoringSafeArea(.all)
                VStack(alignment: .center) {
                    HStack(alignment: .center) {
                        ZStack {
                            Circle()
                                .stroke(lineWidth: 20.0)
                                .foregroundColor(Clr.superLightGray)
                            Circle()
                                .trim(from: 0.0, to: CGFloat(min(self.progressValue, 1.0)))
                                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                                .foregroundColor(Clr.brightGreen)
                                .rotationEffect(Angle(degrees: 270.0))
                                .animation(.linear)
                            Circle()
                                .frame(width: 230)
                                .foregroundColor(Clr.darkWhite)
                                .shadow(color: .black.opacity(0.35), radius: 20, x: 10, y: 5)
                        }
                        .frame(width: 250)
                    }
                    HStack(alignment: .center, spacing: 20) {
                        Button {
                            progressValue += 0.1
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Clr.darkWhite)
                                    .frame(width: 70)
                                    .neoShadow()
                                VStack {
                                    Image(systemName: "backward.fill")
                                        .foregroundColor(Clr.brightGreen)
                                        .font(.title)
                                    Text("15")
                                        .font(.caption)
                                        .foregroundColor(Clr.darkgreen)
                                }

                            }
                        }

                        Button {
                            progressValue += -0.1
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Clr.darkWhite)
                                    .frame(width: 90)
                                    .neoShadow()
                                Image(systemName: "play.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(Clr.brightGreen)
                                    .frame(width: 35)
                                    .padding(.leading, 5)
                            }
                        }
                        Button {
                            progressValue += 0.1
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Clr.darkWhite)
                                    .frame(width: 70)
                                    .neoShadow()
                                VStack {
                                    Image(systemName: "forward.fill")
                                        .foregroundColor(Clr.brightGreen)
                                        .font(.title)
                                    Text("15")
                                        .font(.caption)
                                        .foregroundColor(Clr.darkgreen)
                                }

                            }
                        }
                    }

                }
            }

        }
    }
}

struct Play_Previews: PreviewProvider {
    static var previews: some View {
        Play()
    }
}
