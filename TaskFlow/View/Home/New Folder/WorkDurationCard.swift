//
//  WorkDurationCard.swift
//  TaskFlow
//
//  Created by İrem Sever on 31.10.2025.
//

import SwiftUI

struct WorkDurationCard: View {
    let text: String
    let corner: CGFloat
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        HStack {
            VStack(alignment: .center, spacing: 6) {
                Text("Çalışma süresi")
                    .font(.custom("Helvetica-Bold", size: 14))
                    .foregroundColor(.primary)
                Text(text)
                    .font(.custom("Helvetica-SemiBold", size: 12))
                    .foregroundColor(.primary.opacity(0.7))
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 56)
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
