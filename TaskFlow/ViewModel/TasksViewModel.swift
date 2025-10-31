//
//  TasksViewModel.swift
//  TaskFlow
//
//  Created by İrem Sever on 29.10.2025.
//
import Foundation
import SwiftUI
import Combine
import FirebaseFirestore

@MainActor
final class TasksViewModel: ObservableObject {
    @Published var tasks: [TFTask] = []
    private let repo = TaskRepository()
    private let db = Firestore.firestore()
    
    func startListening() {
        Task {
            for try await items in repo.listenTasks() {
                self.tasks = items
            }
        }
    }
    
    func create(title: String, detail: String?, sla: Date, assignee: Assignee, currentUserId: String) async throws {
        let task = TFTask(id: UUID().uuidString, title: title, detail: detail,
                          status: .planned, slaDeadline: sla, createdAt: .now,
                          location: nil, assignee: assignee, createdBy: currentUserId)
        try await repo.create(task)
    }
    
    func advance(_ task: TFTask) async throws -> TFTask {
        guard let next = task.status.next else { return task }
        
        let doc = db.collection("tasks").document(task.id)
        try await doc.updateData([
            "status": next.rawValue,
            "updatedAt": FieldValue.serverTimestamp()
        ])
        
        var updated = task
        updated.status = next
        return updated
    }
    
}

extension TFTask {
    var slaBadge: Color {
        let remain = slaDeadline.timeIntervalSinceNow
        if remain < 0 { return .red }
        if remain < 3600 * 2 { return .orange }
        return .green
    }
}
