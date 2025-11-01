//
//  InfoRow.swift
//  TaskFlow
//
//  Created by İrem Sever on 31.10.2025.
//

import SwiftUI

struct InfoRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(alignment: .center) {
            Label(label, systemImage: icon)
                .foregroundColor(.primary.opacity(0.7))
                .font(.custom("Helvetica", size: 14))
            
            Spacer(minLength: 12)
            
            Text(value)
                .font(.custom("Helvetica", size: 14))
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
        }
        .frame(minHeight: 24) 
        .contentShape(Rectangle())
    }
}
