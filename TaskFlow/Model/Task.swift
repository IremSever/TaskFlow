//
//  Task.swift
//  TaskFlow
//
//  Created by İrem Sever on 29.10.2025.
//
import Foundation
import SwiftUI
import FirebaseFirestore

struct TFTask: Codable, Identifiable, Hashable {
    var id: String
    var title: String
    var detail: String?
    var status: TaskStatus
    var slaDeadline: Date
    var createdAt: Date
    var location: GeoPoint?
    var assignee: Assignee
    var createdBy: String
    var score: Int?
}

struct Assignee: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var email: String
}
enum TaskStatus: String, CaseIterable, Codable {
    case planned, todo, inProgress, qa, done

    var title: String {
        switch self {
        case .planned:
            return "Planlandı"
        case .todo:
            return "Yapılacak"
        case .inProgress:
            return "Çalışmada"
        case .qa:
            return "Kontrol"
        case .done:
            return "Tamamlandı"
        }
    }

    var next: TaskStatus? {
        switch self {
        case .planned:
            return .todo
        case .todo:
            return .inProgress
        case .inProgress:
            return .qa
        case .qa:
            return .done
        case .done:
            return nil
        }
    }
}
extension TaskStatus {
    var tint: Color {
        switch self {
        case .planned:
            return .orange.opacity(0.5)
        case .todo:
            return .blue.opacity(0.5)
        case .inProgress:
            return .purple.opacity(0.5)
        case .qa:
            return .cyan.opacity(0.5)
        case .done:
            return .green.opacity(0.5)
        }
    }
}
