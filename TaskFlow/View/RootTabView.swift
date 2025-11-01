//
//  RootTabView.swift
//  TaskFlow
//
//  Created by İrem Sever on 29.10.2025.
//

import SwiftUI

struct RootTabView: View {
    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        TabView {
            NavigationStack { HomeView() }
                .tabItem { Label("Anasayfa", systemImage: "house.fill") }
            NavigationStack { TaskListView() }
                .tabItem { Label("Görevler", systemImage: "checklist") }
            NavigationStack { LocationView() }
                .tabItem { Label("Konumum", systemImage: "location") }
            NavigationStack { ReportsView() }
                .tabItem { Label("Raporlar", systemImage: "doc.richtext") }
            NavigationStack { SettingsView() }
                .tabItem { Label("Ayarlar", systemImage: "gearshape") }
        }.tint(colorScheme == .dark ? .white.opacity(0.2) : .black.opacity(0.2))
    }
}
