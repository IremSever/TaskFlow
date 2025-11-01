//
//  SettingsView.swift
//  TaskFlow
//
//  Created by İrem Sever on 29.10.2025.
//
import SwiftUI
import UniformTypeIdentifiers
import Combine

struct SettingsView: View {
    var isRoot: Bool = true

    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var auth: AuthViewModel
    @EnvironmentObject var appState: AppState
    @StateObject private var vm = SettingsViewModel()
    @AppStorage("appTheme") private var theme: Int = 2

    private let corner: CGFloat = 22

    var body: some View {
        ZStack {
            (colorScheme == .dark ? Color.black : Color.white).ignoresSafeArea()
            LinearGradient(
                colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .opacity(colorScheme == .dark ? 0.5 : 0.2)
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    SettingsCard(corner: corner) {
                        HStack {
                            Text("Tema: Açık / Koyu / Sistem")
                                .font(.custom("Helvetica-Bold", size: 15))
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        Picker("", selection: $theme) {
                            Text("Açık").tag(0)
                            Text("Koyu").tag(1)
                            Text("Sistem").tag(2)
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: theme) { appState.setTheme($0) }
                    }

                    SettingsCard(corner: corner) {
                        Toggle(isOn: $vm.syncOnWifiOnly) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Offline Senkron: Yalnızca Wi-Fi’da")
                                    .font(.custom("Helvetica-Bold", size: 15))
                                Text("Mobil veride kapalı, Wi-Fi’da otomatik")
                                    .font(.custom("Helvetica", size: 12))
                                    .foregroundColor(.primary.opacity(0.7))
                            }
                        }
                        .toggleStyle(.switch)
                    }
                    
                    SettingsButtonCard(title: "Manuel Senkronla", corner: corner, isLoading: vm.isSyncing) { await vm.syncNow() }
                    SettingsButtonCard(title: "Bildirimler: SLA • Atama • Checklist",corner: corner) { vm.showNotificationSheet = true }
                    SettingsButtonCard(title: "Veri Dışa/İçe Aktarma (JSON)", corner: corner) { await vm.exportJSON() }
                    ValueCard(title: "Rol", value: auth.role == .admin ? "Admin" : "Tech", corner: corner)
                    PrimaryFillButton(title: "Çıkış Yap", corner: corner) { auth.signOut() }
                    Spacer(minLength: 0)
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
        }
        .safeAreaInset(edge: .top) {
            SectionTitle("Ayarlar")
                .padding(.horizontal, 20)
                .padding(.top, isRoot ? 4 : -54)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .toolbar(isRoot ? .hidden : .visible, for: .navigationBar)
        .toolbarBackground(isRoot ? .hidden : .visible, for: .navigationBar)

        .sheet(isPresented: $vm.showNotificationSheet) {
            NotificationSheet(isPresented: $vm.showNotificationSheet)
                .presentationDetents([.height(350)])
                .presentationDragIndicator(.hidden)
        }
        .sheet(isPresented: $vm.showExportSheet) {
            if let url = vm.exportedURL {
                ExportSheet(url: url, isPresented: $vm.showExportSheet, onShare: { vm.showSystemShare = true })
                    .presentationDetents([.height(350)])
                    .presentationDragIndicator(.hidden)
            }
        }
        .sheet(isPresented: $vm.showSystemShare) {
            if let url = vm.exportedURL {
                ShareSheetX(activityItems: [url])
            }
        }
    }
}
