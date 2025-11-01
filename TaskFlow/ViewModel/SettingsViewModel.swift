//
//  SettingsViewModel.swift
//  TaskFlow
//
//  Created by İrem Sever on 31.10.2025.
//
import SwiftUI
import Combine
import FirebaseFirestore
import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @AppStorage("wifiOnlySync") var syncOnWifiOnly: Bool = true
    @Published var isSyncing: Bool = false
    @Published var showNotificationSheet: Bool = false
    @Published var exportedURL: URL?
    @Published var showExportSheet: Bool = false
    @Published var showSystemShare: Bool = false

    func syncNow() async {
        isSyncing = true
        defer { isSyncing = false }
        try? await Task.sleep(nanoseconds: 900_000_000)
    }

    func exportJSON() async {
        do {
            let data = try JSONEncoder().encode([String: String]())
            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent("TaskFlow_Export.json")
            try data.write(to: url, options: .atomic)

            exportedURL = url
            showExportSheet = true
        } catch {
            print("Export error:", error)
        }
    }
}
