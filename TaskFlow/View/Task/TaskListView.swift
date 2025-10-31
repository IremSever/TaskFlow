//
//  TaskListView.swift
//  TaskFlow
//
//  Created by İrem Sever on 29.10.2025.
//

import SwiftUI
import UIKit
import Combine
struct TaskListView: View {
    @StateObject var vm = TasksViewModel()
    @State private var shareURL: URL?
    private let pdf = PDFService()

    var body: some View {
        List(vm.tasks) { task in
            NavigationLink(value: task) { 
                HStack {
                    VStack(alignment: .leading) {
                        Text(task.title).bold()
                        Text(task.status.rawValue).font(.caption)
                    }
                    Spacer()
                    Circle().fill(task.slaBadge).frame(width: 10, height: 10)
                }
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button("İlerle") { Task { try? await vm.advance(task) } }.tint(.blue)
                if task.status == .done {
                    Button("PDF") {
                        Task {
                            let url = try pdf.makeReport(.init(task: task, finishedAt: .now, author: task.assignee.name))
                            shareURL = url
                        }
                    }.tint(.purple)
                }
            }
        }
        .navigationTitle("Görevler")
        .navigationDestination(for: TFTask.self) { TaskDetailView(task: $0) }
        .onAppear { vm.startListening() }
        .sheet(item: $shareURL) { url in
            ShareSheet(activityItems: [url])
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

extension URL: Identifiable {
    public var id: String { absoluteString }
}
