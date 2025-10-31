//
//  TaskRepository.swift
//  TaskFlow
//
//  Created by İrem Sever on 29.10.2025.
//
import SwiftUI
import FirebaseFirestore

final class TaskRepository {
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    deinit {
        listener?.remove()
    }

    func listenTasks() -> AsyncThrowingStream<[TFTask], Error> {
        AsyncThrowingStream { continuation in
            self.listener = db.collection("tasks")
                .order(by: "createdAt", descending: true)
                .addSnapshotListener { snapshot, error in
                    if let error = error {
                        continuation.finish(throwing: error)
                        return
                    }
                    guard let snapshot = snapshot else {
                        continuation.yield([])
                        return
                    }
                    let tasks: [TFTask] = snapshot.documents.compactMap { doc in
                        do {
                            return try doc.data(as: TFTask.self)
                        } catch {
                            print("Decode error for \(doc.documentID): \(error)")
                            return nil
                        }
                    }
                    continuation.yield(tasks)
                }

            continuation.onTermination = { @Sendable _ in
                self.listener?.remove()
                self.listener = nil
            }
        }
    }

    func create(_ task: TFTask) async throws {
        try db.collection("tasks").document(task.id).setData(from: task)
    }

    func updateStatus(id: String, to status: TaskStatus) async throws {
        try await db.collection("tasks").document(id).updateData([
            "status": status.rawValue
        ])
    }

    func stopListening() {
        listener?.remove()
        listener = nil
    }
}
