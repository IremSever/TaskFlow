//
//  LocationView.swift
//  TaskFlow
//
//  Created by İrem Sever on 31.10.2025.
//

import SwiftUI
import CoreLocation

struct LocationView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var vm = LocationViewModel()

    private let corner: CGFloat = 22

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
            
            ScrollView {
                VStack(spacing: 40) {
                    SectionTitle("Konumum")
                    VStack(spacing: 16) {
                        InfoCard(title: "Mevcut Konum", subtitle: "Lat: \(format(vm.latitude)) • Lon: \(format(vm.longitude))", corner: corner)
                        InfoCard(title: "Durum",subtitle: vm.statusText, corner: corner)
                    }
                }
                .padding(.top, -50)
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
        }
        .onAppear { vm.request() }
        .onDisappear { vm.stop() }
        
        .navigationBarTitleDisplayMode(.inline)
    }

    private func format(_ v: Double?) -> String {
        guard let v else { return "--" }
        return String(format: "%.4f", v)
    }
}
