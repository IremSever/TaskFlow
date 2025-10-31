//
//  QuickCard.swift
//  TaskFlow
//
//  Created by İrem Sever on 31.10.2025.
//

import SwiftUI
struct QuickCard: View {
    let title: String
    let icon: String
    let corner: CGFloat
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .frame(width: 28, height: 28)
                .foregroundColor(.primary)
            Text(title)
                .font(.custom("Helvetica-Bold", size: 15))
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 80)
        .background(
            RoundedRectangle(cornerRadius: corner)
                .fill(Color.primary.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: corner)
                .stroke(Color.primary.opacity(0.12), lineWidth: 0.8)
        )
    }
}
