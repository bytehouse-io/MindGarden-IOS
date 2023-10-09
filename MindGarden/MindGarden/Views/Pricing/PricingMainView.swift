//
//  PricingMainView.swift
//  MindGarden
//
//  Created by apple on 25/05/23.
//

import SwiftUI
import MWMPublishingSDK

struct PricingMainView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = PricingViewHelperViewController
    @EnvironmentObject var viewRouter: ViewRouter
    
    func makeUIViewController(context: Context) -> PricingViewHelperViewController {
        let vc = PricingViewHelperViewController()
        vc.viewRouter = viewRouter
        return vc
    }
    
    func updateUIViewController(_ uiViewController: PricingViewHelperViewController, context: Context) {
    }
}

//struct PricingMainView_Previews: PreviewProvider {
//    static var previews: some View {
//        PricingMainView()
//    }
//}
