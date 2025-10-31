//
//  StatCard.swift
//  TaskFlow
//
//  Created by İrem Sever on 31.10.2025.
//

import SwiftUI

struct StatCard: View {
    let title: String
    let value: Int
    let corner: CGFloat
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .center, spacing: 6) {
            Text(title)
                .font(.custom("Helvetica-SemiBold", size: 12))
                .foregroundColor(.primary.opacity(0.7))
            Text("\(value)")
                .font(.custom("Helvetica-Bold", size: 22))
                .foregroundColor(.primary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 72)
        .background(
            RoundedRectangle(cornerRadius: corner)
                .fill(Color.primary.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: corner)
                .stroke(Color.primary.opacity(0.12), lineWidth: 0.8)
        )
        .shadow(color: colorScheme == .dark ? .white.opacity(0.08) : .black.opacity(0.08), radius: 6, y: 3)
    }
}

