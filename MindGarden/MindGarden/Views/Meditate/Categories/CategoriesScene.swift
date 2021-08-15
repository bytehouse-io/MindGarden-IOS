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
@available(iOS 14.0, *)
struct CategoriesScene: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var model: MeditationViewModel
    var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: -20), count: 2)

    init() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }

    var body: some View {
        NavigationView {
            GeometryReader { g in
                ZStack {
                Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                VStack(alignment: .center) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            CategoryButton(category: .all, selected: $model.selectedCategory)
                            CategoryButton(category: .unguided, selected: $model.selectedCategory)
                            CategoryButton(category: .courses, selected: $model.selectedCategory)
                            CategoryButton(category: .anxiety, selected: $model.selectedCategory)
                            CategoryButton(category: .focus, selected: $model.selectedCategory)
                            CategoryButton(category: .growth, selected: $model.selectedCategory)
                        }.padding()
                    }
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: gridItemLayout, content: {
                            ForEach(model.selectedMeditations, id: \.self) { item in
                                Button {
                                    model.selectedMeditation = item
                                    viewRouter.currentPage = .middle
                                } label: {
                                    HomeSquare(width: g.size.width, height: g.size.height, img: Img.daisy, title: item.title, id: item.id)
                                }.buttonStyle(NeumorphicPress())
                                .padding(.vertical, 8)
                            }
                        })
                    }
                    Spacer()
                }.background(Clr.darkWhite)
            }.navigationBarTitle("Categrories", displayMode: .inline)
            .navigationBarItems(leading: backButton
                                   , trailing: searchButton)
            }
        }.transition(.move(edge: .trailing))
        .onAppear {
            model.selectedCategory = .all
        }
    }
    var backButton: some View {
        Button {
            withAnimation {
                viewRouter.currentPage = .meditate
            }
        } label: {
            Image(systemName: "arrow.backward")
                .foregroundColor(Clr.darkgreen)
                .font(.title)
        }
    }

    var searchButton: some View {
        Button {

        } label: {
            Image(systemName: "magnifyingglass")
                .font(.title)
                .foregroundColor(Clr.darkgreen)
                .padding()
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
            if #available(iOS 14.0, *) {
                CategoriesScene()
            } else {
                // Fallback on earlier versions
            }
    }
}
