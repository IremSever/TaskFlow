//
//  OutlineActionButton.swift
//  TaskFlow
//
//  Created by İrem Sever on 31.10.2025.
//

import SwiftUI

struct OutlineActionButton: View {
    let title: String
    let corner: CGFloat
    var height: CGFloat = 48
    
    var body: some View {
        Text(title)
            .font(.custom("Helvetica-Bold", size: 18))
            .frame(maxWidth: .infinity, minHeight: height)
            .multilineTextAlignment(.center)
            .foregroundColor(.primary)
            .overlay(
                RoundedRectangle(cornerRadius: corner)
                    .stroke(Color.primary, lineWidth: 1.6)
            )
    }
}
