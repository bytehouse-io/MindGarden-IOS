//
//  PromptsTab.swift
//  MindGarden
//
//  Created by Vishal Davara on 29/06/22.
//

import SwiftUI

struct PromptsDetailView: View {
        
    var body: some View {
        ZStack(alignment:.top) {
            Clr.darkWhite.ignoresSafeArea()
            VStack(spacing:0) {
                Spacer()
                    .frame(height:50)
                HStack {
                    Text("Thursday, jun 28")
                        .font(Font.fredoka(.medium, size: 16))
                        .foregroundColor(Clr.blackShadow)
                        .multilineTextAlignment(.center)
                        .opacity(0.5)
                    Spacer()
                    Text("Prompts")
                        .font(Font.fredoka(.semiBold, size: 16))
                        .foregroundColor(Clr.gardenRed)
                        .multilineTextAlignment(.center)
                        .padding()
                    Image(systemName: "shuffle")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Clr.black1)
                        .aspectRatio(contentMode: .fit)
                        .frame(width:30)
                        .onTapGesture {
                            //TODO: implement shuffle tap event
                        }
                    
                }
                .padding(.horizontal,30)
                Text("What does an ideal next year look like to you?")
                    .font(Font.fredoka(.semiBold, size: 28))
                    .foregroundColor(Clr.black2)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .padding(.horizontal,20)
                    
            }
        }
        .ignoresSafeArea()
    }
}
