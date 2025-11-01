//
//  SettingsCard.swift
//  TaskFlow
//
//  Created by İrem Sever on 31.10.2025.
//
import SwiftUI

struct SettingsCard<Content: View>: View {
    let corner: CGFloat
    @ViewBuilder var content: Content
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 12) { content }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 56)
            .background(RoundedRectangle(cornerRadius: corner).fill(Color.primary.opacity(0.05)))
            .overlay(RoundedRectangle(cornerRadius: corner).stroke(Color.primary.opacity(0.12), lineWidth: 0.8))
            .shadow(color: colorScheme == .dark ? .white.opacity(0.08) : .black.opacity(0.08), radius: 6, y: 3)
    }
}

