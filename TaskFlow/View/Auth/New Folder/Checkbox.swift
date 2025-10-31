//
//  Checkbox.swift
//  TaskFlow
//
//  Created by İrem Sever on 31.10.2025.
//

import SwiftUI

struct Checkbox: View {
    @Binding var isOn: Bool
    var body: some View {
        Button { isOn.toggle() } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(Color.primary.opacity(0.35), lineWidth: 1)
                    .background(RoundedRectangle(cornerRadius: 5)
                        .fill(Color.primary.opacity(0.1)))
                    .frame(width: 20, height: 20)
                if isOn {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.primary)
                }
            }
        }
        .buttonStyle(.plain)
    }
}
