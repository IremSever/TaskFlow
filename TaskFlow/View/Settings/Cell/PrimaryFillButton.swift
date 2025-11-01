//
//  PrimaryFillButton.swift
//  TaskFlow
//
//  Created by İrem Sever on 31.10.2025.
//

import SwiftUI

struct PrimaryFillButton: View {
    let title: String
    let corner: CGFloat
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Helvetica-Bold", size: 18))
                .frame(maxWidth: .infinity, minHeight: 48)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .overlay(
                    RoundedRectangle(cornerRadius: corner)
                        .stroke(Color.primary, lineWidth: 1.6)
                )
        }
    }
}
