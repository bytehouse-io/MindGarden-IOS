//
//  PlusButtonPopup.swift
//  sample
//
//  Created by Vishal Davara on 21/02/22.
//

import SwiftUI

struct PlusButtonPopup: View {
    @Binding var showPopup: Bool
    @Binding var scale : CGFloat
    @Binding var selectedOption : PlusMenuType
    
    private let buttonRadius : CGFloat = 15.0
    private let popupRadius : CGFloat = 20.0
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
        
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing:0) {
                    Spacer()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight:0, maxHeight: .infinity, alignment: Alignment.topLeading)
                    VStack(spacing:-10) {
                        ZStack {
                        PlusButtonShape(cornerRadius: popupRadius)
                            .fill(Color.white)
                            .plusPopupStyle(size: geometry.size, scale: scale)
                            
                            PlusMenuView(showPopup:$showPopup, selectedOption: $selectedOption).cornerRadius(popupRadius)
                            .plusPopupStyle(size: geometry.size, scale: scale)
                        }.zIndex(1)
                        PlusButtonShape(cornerRadius: buttonRadius)
                            .fill(Color.white)
                            .shadow(color:.black.opacity(0.25), radius: 4, x: 4, y: 4)
                            .plusButtonStyle(scale: scale)
                            .onTapGesture {
                                DispatchQueue.main.async {
                                withAnimation(.spring()) {
                                        DispatchQueue.main.async {
                                        showPopup.toggle()
                                    }
                                }
                                }
                            }
                    }
                    Spacer()
                        .frame(height:safeAreaInsets.bottom + 8)
                }
            }
            .ignoresSafeArea()
            .onChange(of: showPopup) { value in
                withAnimation(.easeInOut(duration: 0.1)) {
                    DispatchQueue.main.async {
                        withAnimation(.spring()) {
                            DispatchQueue.main.async {
                                scale = scale < 1.0 ? 1.0 : 0.01
                            }
                        }
                    }
                }
            }
            
        }
    }
}
