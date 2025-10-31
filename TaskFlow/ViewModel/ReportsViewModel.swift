//
//  ReportsViewModel.swift
//  TaskFlow
//
//  Created by İrem Sever on 29.10.2025.
//
// ReportsViewModel.swift

import SwiftUI
import Combine
import PDFKit

@MainActor
final class ReportsViewModel: ObservableObject {
    @Published var completedTasks: [TFTask] = []
    @Published var sharedURL: URL?
    private let repo = TaskRepository()
    private let pdfService = PDFService()

    func loadCompletedTasks() {
        Task {
            for try await tasks in repo.listenTasks() {
                self.completedTasks = tasks.filter { $0.status == .done }
            }
        }
    }

    func duration(for task: TFTask) -> String {
        let interval = Date().timeIntervalSince(task.createdAt)
        let h = Int(interval / 3600)
        let m = Int((interval.truncatingRemainder(dividingBy: 3600)) / 60)
        return "\(h)s \(m)dk"
    }

    func slaText(for task: TFTask) -> String {
        task.slaDeadline > .now ? "SLA Uyumlu" : "SLA Geçti"
    }

    func openPDF(for task: TFTask) async throws -> URL {
        try pdfService.makeReport(.init(task: task, finishedAt: .now, author: task.assignee.name))
    }

    func openPDFExternally(url: URL) {
        UIApplication.shared.open(url)
    }

    func share(url: URL) {
        sharedURL = url
    }
}
