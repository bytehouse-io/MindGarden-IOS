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
    
    private let buttonRadius : CGFloat = 10.0
    private let popupRadius : CGFloat = 20.0
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
        
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing:0) {
                    Spacer()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight:0, maxHeight: .infinity, alignment: Alignment.topLeading)
                    VStack(spacing:-10) {
                        PlusButtonShape(cornerRadius: popupRadius)
                            .fill(Color.white)
                            .plusPopupStyle(size: geometry.size, scale: scale)
                            .zIndex(1)
                        
                        PlusButtonShape(cornerRadius: buttonRadius)
                            .fill(Color.white)
                            .shadow(color:.black.opacity(0.25), radius: 4, x: 4, y: 4)
                            .plusButtonStyle(scale: scale)
                            .onTapGesture {
                                DispatchQueue.main.async {
                                    withAnimation(.spring()) {
                                        showPopup.toggle()
                                        scale = scale < 1.0 ? 1.0 : 0.01
                                    }
                                }
                            }
                    }
                    Spacer()
                        .frame(height:safeAreaInsets.bottom + 8)
                }
            }
            .ignoresSafeArea()
        }
    }
}
