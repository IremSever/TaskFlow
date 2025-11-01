//
//  NotificationSheet.swift
//  TaskFlow
//
//  Created by İrem Sever on 31.10.2025.
//

import SwiftUI
import Combine 
struct NotificationSheet: View {
    @Binding var isPresented: Bool
    @State private var sla = true
    @State private var assign = true
    @State private var checklist = true
    private let corner: CGFloat = 22
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            (colorScheme == .dark ? Color.black : Color.white).ignoresSafeArea()
            LinearGradient(
                colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .opacity(colorScheme == .dark ? 0.5 : 0.2)
            .ignoresSafeArea()
            VStack(spacing: 40) {
                ZStack {
                    SectionTitle("Bildirimler")
                    HStack {
                        Spacer()
                        Button { isPresented = false } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.primary.opacity(0.85))
                        }
                    }
                }
                .padding(.top, 16)
                
                VStack(spacing: 14) {
                    SettingsCard(corner: corner) {
                        Toggle("SLA uyarıları", isOn: $sla)
                            .font(.custom("Helvetica", size: 15))
                    }
                    
                    SettingsCard(corner: corner) {
                        Toggle("Atama bildirimleri", isOn: $assign)
                            .font(.custom("Helvetica", size: 15))
                    }
                    
                    SettingsCard(corner: corner) {
                        Toggle("Checklist hatırlatıcıları", isOn: $checklist)
                            .font(.custom("Helvetica", size: 15))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
        }   .presentationDetents([.height(350)])
            .presentationDragIndicator(.hidden)
    }
}
