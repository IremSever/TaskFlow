//
//  StageNoteSection.swift
//  TaskFlow
//
//  Created by İrem Sever on 1.11.2025.
//
import SwiftUI

struct StageNoteSection: View {
    let isActive: Bool
    @Binding var text: String
    let placeholder: String
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        if isActive {
            VStack(spacing: 8) {
                TextEditor(text: $text)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .frame(minHeight: 84)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.clear)) 
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.primary.opacity(0.15), lineWidth: 1)
                    )
                    .overlay(alignment: .center) {
                        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            Text(placeholder)
                                .font(.custom("Helvetica", size: 13))
                                .foregroundColor(.primary.opacity(0.35))
                                .padding(.top, 14)
                                .padding(.leading, 16)
                        }
                    }
                Text("Bu not, bir sonraki aşamaya geçerken kaydedilir.")
                    .font(.custom("Helvetica", size: 11))
                    .foregroundColor(.primary.opacity(0.5))
            }
        } else {
            if let preview = textIfAny(text) {
                Text(preview)
                    .font(.custom("Helvetica", size: 13))
                    .foregroundColor(.primary.opacity(0.7))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
            } else {
                EmptyView()
            }
        }
    }

    private func textIfAny(_ t: String) -> String? {
        let trimmed = t.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
