//
//  ExitButton.swift
//
//
//  Created by Vishal Davara on 26/03/22.
//

import SwiftUI

struct ExitButton: View {
    
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "xmark")
                .resizable()
                .renderingMode(.template)
                .frame(width: 25, height: 25, alignment: .center)
                .foregroundColor(Clr.black1)
            
        }.padding(20)
    }
}

struct ExitButton_Previews: PreviewProvider {
    static var previews: some View {
        ExitButton(action: {
            // tap event
        })
    }
}
