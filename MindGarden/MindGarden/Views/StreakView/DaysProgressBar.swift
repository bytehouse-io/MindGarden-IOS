//
//  DaysProgressBar.swift
//
//
//  Created by Vishal Davara on 11/03/22.
//

import SwiftUI

struct DayItem: Identifiable {
    var id = UUID()
    var title: String
    var image: String
}

struct DaysProgressBar: View {
    
    @Binding var currentDay: Int
    
    var days = [DayItem(title: "M", image: ""),
                DayItem(title: "T", image: ""),
                DayItem(title: "W", image: ""),
                DayItem(title: "Th", image: ""),
                DayItem(title: "F", image: "")]
    var progress: CGFloat {
        return CGFloat((1.0/Double(days.count-1))*Double(currentDay-1))
    }
    let pregressWidth = UIScreen.screenWidth * 0.80
    
    var body: some View {
        
        VStack {
            HStack(alignment:.center) {
                Spacer()
                ForEach(0..<days.count) { index in
                    Text("\(days[index].title)")
                        .daysProgressTitleStyle()
                    Spacer()
                }
            }
            ZStack(alignment:.center) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white)
                        .frame(width: pregressWidth, height: 6, alignment: .leading)
                        .shadow(radius: 2)
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.orange)
                        .frame(width: pregressWidth * progress, height: 6, alignment: .leading)
                }
                HStack {
                    Spacer()
                    ForEach(0..<days.count) { index in
                        Circle()
                            .fill( index >= currentDay ? Color.white : Color.orange)
                            .frame(width: 44, height: 44).shadow(radius: 2)
                        Spacer()
                    }
                }
            }
        }
    }
}

struct DaysProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        DaysProgressBar(currentDay: .constant(3))
    }
}
