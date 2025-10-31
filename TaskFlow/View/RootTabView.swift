//
//  RootTabView.swift
//  TaskFlow
//
//  Created by İrem Sever on 29.10.2025.
//

import SwiftUI

struct RootTabView: View {
    @EnvironmentObject var auth: AuthViewModel
    var body: some View {
        TabView {
            NavigationStack { HomeView() }
                .tabItem { Label("Anasayfa", systemImage: "house.fill") }
            NavigationStack { TaskListView() }
                .tabItem { Label("Görevler", systemImage: "checklist") }
            NavigationStack { ReportsView() }
                .tabItem { Label("Raporlar", systemImage: "doc.richtext") }
            NavigationStack { SettingsView() }
                .tabItem { Label("Ayarlar", systemImage: "gearshape") }
        }
    }
}
