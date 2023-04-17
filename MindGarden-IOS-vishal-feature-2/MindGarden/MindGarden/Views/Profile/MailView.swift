//
//  MailView.swift
//  MindGarden
//
//  Created by Dante Kim on 9/14/21.
//

import Foundation
import MessageUI
import SwiftUI
import UIKit

struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var subject: String
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var presentationMode: PresentationMode

        init(presentation: Binding<PresentationMode>) {
            _presentationMode = presentation
        }

        func mailComposeController(_: MFMailComposeViewController,
                                   didFinishWith _: MFMailComposeResult,
                                   error _: Error?)
        {
            $presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentationMode)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(["team@mindgarden.io"])
        vc.setSubject(subject)
        vc.setMessageBody("Dear MindGarden team, ", isHTML: false)
        return vc
    }

    func updateUIViewController(_: MFMailComposeViewController,
                                context _: UIViewControllerRepresentableContext<MailView>) {}
}
