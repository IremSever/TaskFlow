//
//  ValueCard.swift
//  TaskFlow
//
//  Created by İrem Sever on 31.10.2025.
//

import SwiftUI

struct ValueCard: View {
    let title: String
    let value: String
    let corner: CGFloat
    var body: some View {
        HStack {
            Text("\(title): ")
                .font(.custom("Helvetica-Bold", size: 15))
            Text(value)
                .font(.custom("Helvetica", size: 15))
                .foregroundColor(.primary.opacity(0.85))
            Spacer()
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 56)
        .background(RoundedRectangle(cornerRadius: corner).fill(Color.primary.opacity(0.05)))
        .overlay(RoundedRectangle(cornerRadius: corner).stroke(Color.primary.opacity(0.12), lineWidth: 0.8))
        .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
    }
}
