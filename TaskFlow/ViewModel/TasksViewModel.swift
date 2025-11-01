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
    
    func advance(_ task: TFTask, note: String?) async throws -> TFTask {
        guard let next = task.status.next else { return task }
        let doc = db.collection("tasks").document(task.id)
        
        var data: [String: Any] = [
            "status": next.rawValue,
            "updatedAt": FieldValue.serverTimestamp()
        ]
        
        if let t = note?.trimmingCharacters(in: .whitespacesAndNewlines), !t.isEmpty {
            data["stageNotes.\(task.status.rawValue)"] = t
        }
        
        try await doc.updateData(data)
        
        var updated = task
        updated.status = next
        
        var notes = updated.stageNotes ?? [:]
        if let t = note, !t.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            notes[task.status.rawValue] = t
        }
        updated.stageNotes = notes
        
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
