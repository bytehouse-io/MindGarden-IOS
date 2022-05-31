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
    var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: -25), count: 2)
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var model: MeditationViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var searchText: String = ""
    var isSearch: Bool = false
    @Binding var showSearch: Bool
    @Binding var isBack: Bool
    let isFromQuickstart: Bool
    var selectedCategory: QuickStartType
    @State private var tappedMed = false
    @State private var showModal = false

    init(isSearch: Bool = false, showSearch: Binding<Bool>, isBack: Binding<Bool>, isFromQuickstart: Bool = false, selectedCategory: QuickStartType = .minutes3) {
        self.isSearch = isSearch
        self._showSearch = showSearch
        self._isBack = isBack
        self.isFromQuickstart = isFromQuickstart
        self.selectedCategory = selectedCategory
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }

    var body: some View {
            GeometryReader { g in
                ZStack {
                Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                VStack(alignment: .center) {
                    if !isFromQuickstart {
                        if !isSearch {
                            HStack {
                                backButton
                                Spacer()
                                Text("Categories")
                                    .foregroundColor(Clr.black2)
                                    .font(Font.mada(.bold, size: 20))
                                Spacer()
                                backButton
                                    .opacity(0)
                                    .disabled(true)
                            }.padding([.horizontal])
                                .padding(.top, 50)
                        } else {
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
                                .oldShadow()
                            }.padding(.top)
                        }
                    } else {
                        HStack {
                        }
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        if isSearch {
                            HStack {
                                CategoryButton(category: .all, selected: $model.selectedCategory)
                                CategoryButton(category: .unguided, selected: $model.selectedCategory)
                                CategoryButton(category: .beginners, selected: $model.selectedCategory)
                                CategoryButton(category: .anxiety, selected: $model.selectedCategory)
                                CategoryButton(category: .focus, selected: $model.selectedCategory)
                                CategoryButton(category: .growth, selected: $model.selectedCategory)
                                CategoryButton(category: .sleep, selected: $model.selectedCategory)
                                CategoryButton(category: .courses, selected: $model.selectedCategory)
                            }.padding([.horizontal, .bottom])
                        }
                    }
                    ScrollView(showsIndicators: false) {
                            LazyVGrid(columns: gridItemLayout, content: {
                                ForEach(meditations, id: \.self) { item in
                                    HomeSquare(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height * 0.75) , img: item.img, title: item.title, id: item.id, instructor: item.instructor, duration: item.duration, imgURL: item.imgURL, isNew: item.isNew)
                                        .onTapGesture {
                                            didSelectcategory(item: item)
                                        }
                                        .neoShadow()
                                        .padding(.vertical, 8)
                                }
                            })
                        VStack {
                            Text("Want a specific meditation?")
                                .font(Font.mada(.semiBold, size: 18))
                                .foregroundColor(Clr.black2)
                            Button {
                                Analytics.shared.log(event: .categories_tapped_request)
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                withAnimation {
                                    if let url = URL(string: "https://mindgarden.upvoty.com/b/feature-requests/") {
                                        UIApplication.shared.open(url)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text("Post a Request")
                                        .foregroundColor(.black)
                                        .font(Font.mada(.semiBold, size: 20))
                                }.frame(width: g.size.width * 0.65, height: 50)
                                .background(Clr.yellow)
                                .cornerRadius(25)
                            }.buttonStyle(NeumorphicPress())
                        }.frame(height: 140)
                        .padding(.bottom)
                    }
                    if isFromQuickstart { Spacer().frame(height:100) }
                    Spacer()
                }
                .padding(.top, isFromQuickstart ? 40 : 0)
                .background(Clr.darkWhite)
                    if showModal {
                        Color.black
                            .opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                showModal.toggle()
                            }
                        Spacer()
                    }
                }
                    MiddleModal(shown: $showModal)
                        .offset(y: showModal ? 0 : g.size.height)
                        .edgesIgnoringSafeArea(.top)
                        .animation(.default, value: showModal)
                if isFromQuickstart {
                    HStack {
                        backButton
                        Spacer()
                        Text(QuickStartMenuItem(title: selectedCategory).name)
                            .foregroundColor(Clr.black2)
                            .font(Font.mada(.semiBold, size: 20))
                        Spacer()
                        backButton.opacity(0).disabled(true)
                        Spacer()
                    }.frame(width: UIScreen.screenWidth, height: 50)
                        .padding(.horizontal, 35)
                }
            }
        .onAppear {
            DispatchQueue.main.async {
                model.selectedCategory = .all
            }
        }
        .transition(.move(edge: .bottom))
        .onDisappear {
            searchScreen = false
            if tappedMed {
                if model.selectedMeditation?.type == .course {
                    viewRouter.currentPage = .middle
                } else {
                    viewRouter.currentPage = .play
                }
            }
        }
        .onAppearAnalytics(event: .screen_load_categories)
    }
    
    var meditations : [Meditation ] {
        if isFromQuickstart {
            return filterMeditation()
        } else {
            return !isSearch ? model.selectedMeditations : model.selectedMeditations.filter({ (meditation: Meditation) -> Bool in
                return meditation.title.lowercased().contains(searchText.lowercased()) || searchText == ""
            })
        }
    }
    
    private func filterMeditation() -> [Meditation] {
        return model.selectedMeditations.filter({ (meditation: Meditation) -> Bool in
            switch selectedCategory {
            case .newMeditations: return meditation.isNew
            case .minutes3: return meditation.duration.isLess(than: 250) && meditation.type != .course
            case .minutes5: return meditation.duration <= 400 && meditation.duration >= 250
            case .minutes10: return meditation.duration <= 700 && meditation.duration >= 500
            case .minutes20: return meditation.duration >= 1000
            case .popular: return !meditation.title.isEmpty
            case .morning: return !meditation.title.isEmpty
            case .sleep: return !meditation.title.isEmpty
            case .anxiety: return !meditation.title.isEmpty
            case .unguided: return !meditation.title.isEmpty
            case .courses: return !meditation.title.isEmpty
            }
        })
    }

    var backButton: some View {
        Button {
            if !isFromQuickstart {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                if isSearch {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    DispatchQueue.main.async {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            viewRouter.currentPage = .meditate
                        }
                    }
                }
            } else {
                withAnimation {
                    isBack = false
                }
            }
        } label: {
            Image(systemName: "arrow.backward")
                .foregroundColor(Clr.darkgreen)
                .font(.system(size: 22))
                .padding(.leading, 10)
        }
    }

    var searchButton: some View {
        Button {
        } label: {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 22))
                .foregroundColor(Clr.darkgreen)
        }
    }
    
    private func didSelectcategory(item: Meditation){
        withAnimation {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            if !UserDefaults.standard.bool(forKey: "isPro") && Meditation.lockedMeditations.contains(item.id) {
                fromPage = "lockedMeditation"
                Analytics.shared.log(event: .categories_tapped_locked_meditation)
                if isSearch {
                    presentationMode.wrappedValue.dismiss()
                }
                viewRouter.currentPage = .pricing
            } else {
                Analytics.shared.log(event: .categories_tapped_meditation)
                model.selectedMeditation = item
                if isSearch {
                    tappedMed = true
                    presentationMode.wrappedValue.dismiss()
                } else {
                    if model.selectedMeditation?.type == .course {
                        viewRouter.currentPage = .middle
                    } else {
                        showModal = true
                    }
                }
            }
        }
    }

    struct CategoryButton: View {
        var category: Category
        @Binding var selected: Category?

        var body: some View {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                Analytics.shared.log(event: AnalyticEvent.getCategory(category: category.value))
                withAnimation {
                    selected = category
                }
            } label: {
                HStack {
                    Text(category.value)
                        .font(Font.mada(selected == category ? .bold : .regular, size: 16))
                        .foregroundColor(selected == category ? .black : Clr.black2)
                        .font(.footnote)
                        .padding(.horizontal)
                }
                .padding(8)
                .background(selected == category ? Clr.yellow : Clr.darkWhite)
                .cornerRadius(16)
            }
            .frame(height:32)
            .buttonStyle(NeumorphicPress())
            .padding(0)
        }
    }
}

enum Category {
    case all
    case unguided
    case courses
    case beginners
    case anxiety
    case focus
    case confidence
    case growth
    case sleep

    var value: String {
        switch self {
        case .all:
            return "👨‍🌾 All"
        case .unguided:
            return "⏳ Unguided"
        case .beginners:
            return "😁 Beginners"
        case .courses:
            return "👨‍🏫 Courses"
        case .anxiety:
            return "😖 Anxiety"
        case .focus:
            return "🎧 Focus"
        case .sleep:
            return "😴 Sleep"
        case .confidence:
            return "💪 Confidence"
        case .growth:
            return "🌱 Growth"
        }
    }
}

struct CategoriesScene_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 14.0, *) {
            CategoriesScene(showSearch: .constant(false), isBack: .constant(false))
        }
    }
}

