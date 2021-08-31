//
//  CategoriesScene.swift
//  MindGarden
//
//  Created by Dante Kim on 7/14/21.
//

import SwiftUI
import Combine

@available(iOS 14.0, *)
struct CategoriesScene: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var model: MeditationViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var searchText: String = ""
    var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: -20), count: 2)
    var isSearch: Bool = false
    
    init(isSearch: Bool = false) {
        self.isSearch = isSearch
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }

    var body: some View {
        NavigationView {
            GeometryReader { g in
                ZStack {
                Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                VStack(alignment: .center) {
                    if isSearch {
                        //Search bar
                        HStack {
                            backButton.padding()
                                HStack {
                                    TextField("Search...", text: $searchText) { startedEditing in
                                        if startedEditing {

                                        }
                                    }
                                    Spacer()
                                    Image(systemName: "magnifyingglass")
                                }
                                .padding()
                                .foregroundColor(.gray)
                                .frame(height: 40)
                                .cornerRadius(13)
                                .background(Clr.darkWhite)
                                .padding(.trailing)
                                .neoShadow()
                        }.padding(.top, -(g.size.height * 0.025))
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        if !isSearch {
                            HStack {
                                CategoryButton(category: .all, selected: $model.selectedCategory)
                                CategoryButton(category: .unguided, selected: $model.selectedCategory)
                                CategoryButton(category: .courses, selected: $model.selectedCategory)
                                CategoryButton(category: .anxiety, selected: $model.selectedCategory)
                                CategoryButton(category: .focus, selected: $model.selectedCategory)
                                CategoryButton(category: .growth, selected: $model.selectedCategory)
                            }.padding()
                        }
                    }
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: gridItemLayout, content: {
                            ForEach(!isSearch ? model.selectedMeditations : model.selectedMeditations.filter({ (meditation: Meditation) -> Bool in
                                return meditation.title.hasPrefix(searchText) || searchText == ""
                            }), id: \.self) { item in
                                Button {
                                    model.selectedMeditation = item
                                    viewRouter.currentPage = .middle
                                } label: {
                                    HomeSquare(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.75, img: Img.daisy, title: item.title, id: item.id)
                                }.buttonStyle(NeumorphicPress())
                                .padding(.vertical, 8)
                            }
                        })
                    }
                    Spacer()
                }
                .background(Clr.darkWhite)
                }.navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(leading: isSearch ? AnyView(EmptyView()) : AnyView(backButton)
                                    , trailing: isSearch ? AnyView(EmptyView()) : AnyView(searchButton))
            }
        }
        .transition(.move(edge: .trailing))
        .onAppear {
            model.selectedCategory = .all
        }
        .gesture(DragGesture()
                     .onChanged({ _ in
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                     })
         )
    }

    var backButton: some View {
        Button {
            if isSearch {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                self.presentationMode.wrappedValue.dismiss()
            } else {
                withAnimation {
                    viewRouter.currentPage = .meditate
                }
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

struct CategoriesScene_Previews: PreviewProvider {
    static var previews: some View {
            if #available(iOS 14.0, *) {
                CategoriesScene()
            }
    }
}
