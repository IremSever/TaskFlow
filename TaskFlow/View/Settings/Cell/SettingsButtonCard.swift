//
//  SettingsButtonCard.swift
//  TaskFlow
//
//  Created by İrem Sever on 31.10.2025.
//

import SwiftUI

struct SettingsButtonCard: View {
    let title: String
    let corner: CGFloat
    var isLoading: Bool = false
    var action: () async -> Void
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button {
            Task { await action() }
        } label: {
            HStack {
                Text(title)
                    .font(.custom("Helvetica-Bold", size: 15))
                    .foregroundColor(.primary)
                Spacer()
                if isLoading { ProgressView().tint(.primary) }
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary.opacity(0.6))
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 56)
            .background(RoundedRectangle(cornerRadius: corner).fill(Color.primary.opacity(0.05)))
            .overlay(RoundedRectangle(cornerRadius: corner).stroke(Color.primary.opacity(0.12), lineWidth: 0.8))
        }
        .buttonStyle(.plain)
        .shadow(color: colorScheme == .dark ? .white.opacity(0.08) : .black.opacity(0.08), radius: 6, y: 3)
    }
}
