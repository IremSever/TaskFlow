//
//  ReportsView.swift
//  TaskFlow
//
//  Created by İrem Sever on 29.10.2025.
//
import SwiftUI
import PDFKit
import UIKit

struct ReportsView: View {
    @StateObject private var vm = ReportsViewModel()
    @State private var selectedTask: TFTask?           // <- seçili görev
    @State private var selectedReportURL: URL?

    var body: some View {
        NavigationStack {
            VStack {
                if vm.completedTasks.isEmpty {
                    ContentUnavailableView("Henüz tamamlanmış görev yok",
                                           systemImage: "doc.text")
                } else {
                    List(vm.completedTasks) { task in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("TASKFLOW_\(task.id.prefix(8)).pdf")
                                .font(.headline)
                            Text("Süre: \(vm.duration(for: task)) • \(vm.slaText(for: task))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        // satıra dokununca seç
                        .contentShape(Rectangle())
                        .onTapGesture { selectedTask = task }
                        .contextMenu {
                            Button("PDF Aç") {
                                Task {
                                    if let url = try? await vm.openPDF(for: task) {
                                        selectedReportURL = url
                                        vm.openPDFExternally(url: url)
                                    }
                                }
                            }
                            Button("Paylaş") {
                                Task {
                                    if let url = try? await vm.openPDF(for: task) {
                                        selectedReportURL = url
                                        vm.share(url: url)
                                    }
                                }
                            }
                        }
                    }
                }

                // Seçili görev bilgisi + alt butonlar
                if let s = selectedTask {
                    HStack {
                        Text(s.title).font(.subheadline).lineLimit(1)
                        Spacer()
                        Button("PDF Aç") {
                            Task {
                                if let url = try? await vm.openPDF(for: s) {
                                    selectedReportURL = url
                                    vm.openPDFExternally(url: url)
                                }
                            }
                        }
                        .buttonStyle(.borderedProminent)

                        Button("Paylaş") {
                            Task {
                                if let url = try? await vm.openPDF(for: s) {
                                    selectedReportURL = url
                                    vm.share(url: url)
                                }
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }
            }
            .navigationTitle("Raporlarım")
            .onAppear { vm.loadCompletedTasks() }
            .sheet(
                isPresented: Binding(
                    get: { vm.sharedURL != nil },
                    set: { if !$0 { vm.sharedURL = nil } }
                )
            ) {
                ShareSheet(activityItems: [vm.sharedURL!])
            }
        }
    }
}
