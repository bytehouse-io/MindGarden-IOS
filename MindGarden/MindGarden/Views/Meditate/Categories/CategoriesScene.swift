//
//  CategoriesScene.swift
//  MindGarden
//
//  Created by Dante Kim on 7/14/21.
//

import SwiftUI

enum Category {
    case all
    case unguided
    case courses
    case anxiety
    case focus
    case confidence
    case growth

    var value: String {
        switch self {
        case .all:
            return "All"
        case .unguided:
            return "Unguided"
        case .courses:
            return "Courses"
        case .anxiety:
            return "Anxiety"
        case .focus:
            return "Focus"
        case .confidence:
            return "Confidence"
        case .growth:
            return "Growth"
        }
    }
}
struct CategoriesScene: View {
    @State private var selectedCategory: Category? = .all
    @ObservedObject var model: MeditationViewModel

    var body: some View {
        NavigationView {
            ZStack {
            Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
            GeometryReader { g in
                VStack(alignment: .center) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            CategoryButton(category: .all, selected: $selectedCategory)
                            CategoryButton(category: .unguided, selected: $selectedCategory)
                            CategoryButton(category: .courses, selected: $selectedCategory)
                            CategoryButton(category: .anxiety, selected: $selectedCategory)
                            CategoryButton(category: .focus, selected: $selectedCategory)
                            CategoryButton(category: .growth, selected: $selectedCategory)
                        }.padding()
                    }
                    ScrollView(showsIndicators: false) {

                    }
                    Spacer()
                    }
                }
            }.navigationBarTitle("", displayMode: .inline)
        }
    }

    struct CategoryButton: View {
        var category: Category
        @Binding var selected: Category?

        var body: some View {
            Button {
                withAnimation {
                    selected = category
                }
            } label: {
                HStack {
                    Text(category.value)
                        .font(Font.mada(selected == category ? .bold : .regular, size: 16))
                        .foregroundColor(.black)
                        .font(.footnote)
                        .padding(.horizontal)
                }
                .padding(8)
                .background(selected == category ? Clr.yellow : Clr.darkWhite)
                .cornerRadius(25)
            }
            .buttonStyle(NeumorphicPress())
            .padding(0)
        }
    }
}

struct CategoriesScene_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesScene(model: MeditationViewModel())
    }
}
