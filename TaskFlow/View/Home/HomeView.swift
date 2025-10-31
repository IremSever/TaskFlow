//
//  HomeView.swift
//  TaskFlow
//
//  Created by İrem Sever on 29.10.2025.
//

import SwiftUI
import Combine

struct HomeView: View {
    @StateObject var vm = TasksViewModel()
    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.colorScheme) private var colorScheme
    private let corner: CGFloat = 22
    private let cardSpacing: CGFloat = 12
    
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
                VStack(spacing: 20) {
                    SectionTitle("Anasayfa")
                    SectionSubTitle("Bugün Özeti")
                    summaryRow
                    WorkDurationCard(text: workDurationString, corner: corner)
                    SectionSubTitle("Kısayollar")
                    shortcutsGrid
                    if auth.role == .admin {
                        NavigationLink { TaskFormView() } label: {
                            OutlineActionButton(title: "Yeni Görev", corner: corner, height: 48)
                        }
                        .padding(.top, 4)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
        }
        .onAppear { vm.startListening() }
    }
}

extension HomeView {
    private var summaryRow: some View {
        let waiting = vm.tasks.filter { $0.status == .planned }.count
        let active = vm.tasks.filter { [.todo, .inProgress, .qa].contains($0.status) }.count
        let done = vm.tasks.filter { $0.status == .done }.count

        return HStack(spacing: cardSpacing) {
            StatCard(title: "Bekleyen", value: waiting, corner: corner)
            StatCard(title: "Aktif", value: active, corner: corner)
            StatCard(title: "Tamamlanan", value: done, corner: corner)
        }
    }

    private var shortcutsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: cardSpacing), GridItem(.flexible(), spacing: cardSpacing)], spacing: cardSpacing) {
            NavigationLink { TaskListView() } label: { QuickCard(title: "Görevlerim", icon: "checklist", corner: corner) }
            NavigationLink { LocationView() } label: { QuickCard(title: "Konumum", icon: "location.circle", corner: corner) }
            NavigationLink { ReportsView() } label: { QuickCard(title: "Raporlarım", icon: "doc.text", corner: corner) }
            NavigationLink { SettingsView() } label: { QuickCard(title: "Ayarlar", icon: "gearshape", corner: corner) }
        }
    }
    
    private var workDurationString: String {
        let today = Calendar.current.startOfDay(for: Date())
        let durations = vm.tasks
            .filter { $0.createdAt >= today }
            .map { max(0, Date().timeIntervalSince($0.createdAt)) }
        let total = durations.reduce(0, +)
        let h = Int(total / 3600)
        let m = Int((total.truncatingRemainder(dividingBy: 3600)) / 60)
        return "\(h)s \(m)dk"
    }
}
