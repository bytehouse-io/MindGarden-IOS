////
////  HomeCoordinator.swift
////  MindGarden
////
////  Created by Dante Kim on 6/6/21.
////
//
//import SwiftUI
//import Stinsen
//
//final class HomeCoordinator: TabCoordinatable {
//
//    lazy var children = TabChild(self, tabRoutes: [.garden, .profile, .shop, .meditate])
//
//
//    var navigationStack = NavigationStack()
//
//    enum Route: TabRoute {
//        case garden
//        case profile
//        case shop
//        case meditate
//    }
//    func tabItem(forTab tab: Int) -> some View {
//        switch tab {
//        case 0:
//            Group {
//                if children.activeTab == 0 {
//                    Img.shopIcon
//                        .renderingMode(.template)
//                        .foregroundColor(.white)
//                } else {
//                    Img.shopIcon
//                }
//                Text("Home")
//            }
//        case 1:
//            Group {
//                if children.activeTab == 1 {
//                    Img.shopIcon
//                        .renderingMode(.template)
//                        .foregroundColor(.white)
//                } else {
//                    Img.shopIcon
//                }
//                Text("Projects")
//            }
//        case 2:
//            Group {
//                if children.activeTab == 2 {
//                    Img.shopIcon
//                        .renderingMode(.template)
//                        .foregroundColor(.white)
//                } else {
//                    Img.shopIcon
//                }
//                Text("Profile")
//            }
//        case 3:
//            Group {
//                if children.activeTab == 3 {
//                    Img.shopIcon
//                        .renderingMode(.template)
//                        .foregroundColor(.white)
//                } else {
//                    Img.shopIcon
//                }
//                Text("Testbed")
//            }
//        default:
//            fatalError()
//        }
//    }
//    func resolveRoute(route: Route) -> AnyCoordinatable {
//        switch route {
//        case .meditate:
//            return NavigationViewCoordinatable(HomeCoordinator()).eraseToAnyCoordinatable()
//        case .garden:
//            return NavigationViewCoordinatable(HomeCoordinator()).eraseToAnyCoordinatable()
//        case .profile:
//            return NavigationViewCoordinatable(HomeCoordinator()).eraseToAnyCoordinatable()
//        case .shop:
//            return NavigationViewCoordinatable(HomeCoordinator()).eraseToAnyCoordinatable()
//        }
//    }
//
//    @ViewBuilder func start() -> some View {
//        ContentView(viewRouter: )
//    }
//
//    init() { }
//}
