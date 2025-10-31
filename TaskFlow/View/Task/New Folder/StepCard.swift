//
//  StepCard.swift
//  TaskFlow
//
//  Created by İrem Sever on 31.10.2025.
//


import SwiftUI
struct StepCard<Content: View>: View {
    let title: String
    let icon: String
    let tint: Color
    let corner: CGFloat
    @ViewBuilder var content: Content
    
    var body: some View {
        AppCard(corner: corner) {
            VStack(spacing: 4) {
                
                Text(title)
                    .font(.custom("Helvetica-Bold", size: 12))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                  .frame(maxWidth: .infinity, alignment: .center)

                VStack(spacing: 4) {
                    content
                        .font(.custom("Helvetica", size: 12))
                        .foregroundColor(.primary.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
     
            .padding(.horizontal, 12)
        }
        .overlay(
            RoundedRectangle(cornerRadius: corner)
                .stroke(tint.opacity(0.25), lineWidth: 1)
        )
    }
}
