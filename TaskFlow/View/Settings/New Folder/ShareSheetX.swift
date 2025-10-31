//
//  ShareSheetX.swift
//  TaskFlow
//
//  Created by İrem Sever on 31.10.2025.
//

import SwiftUI

struct ShareSheetX: UIViewControllerRepresentable {
    let activityItems: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

extension UIApplication {
    var keyWindowTop: UIViewController? {
        connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.rootViewController?.topPresented
    }
}
private extension UIViewController {
    var topPresented: UIViewController { presentedViewController?.topPresented ?? self }
}
