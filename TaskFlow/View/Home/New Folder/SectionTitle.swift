//
//  SectionTitle.swift
//  TaskFlow
//
//  Created by İrem Sever on 31.10.2025.
//

import SwiftUI

struct SectionTitle: View {
    let text: String
    init(_ t: String) { self.text = t }
    var body: some View {
        Text(text)
            .font(.custom("Helvetica-Bold", size: 22))
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            .foregroundColor(.primary)
            .padding(.top, 6)
    }
}

struct SectionSubTitle: View {
    let text: String
    init(_ t: String) { self.text = t }
    var body: some View {
        Text(text)
            .font(.custom("Helvetica-SemiBold", size: 18))
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            .foregroundColor(.primary)
            .padding(.top, 6)
    }
}
