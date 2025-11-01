//
//  PillOutlineButton.swift
//  TaskFlow
//
//  Created by İrem Sever on 1.11.2025.
//



import SwiftUI

struct PillOutlineButton: View {
    let title: String
    var systemImage: String? = nil
    var corner: CGFloat = 22
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
                    .font(.custom("Helvetica-Bold", size: 12))
            }
            .frame(maxWidth: .infinity, minHeight: 28)
            .multilineTextAlignment(.center)
            .foregroundColor(.primary)
            .background(
                RoundedRectangle(cornerRadius: corner)
                    .fill(Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: corner)
                    .stroke(Color.primary, lineWidth: 1.6)
            )
        }
        .buttonStyle(.plain)
        .contentShape(RoundedRectangle(cornerRadius: corner))
    }
}