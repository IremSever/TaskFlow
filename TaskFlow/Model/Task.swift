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

    var next: TaskStatus? {
        switch self {
        case .planned:    return .todo
        case .todo:       return .inProgress
        case .inProgress: return .qa
        case .qa:         return .done
        case .done:       return nil
        }
    }
}

extension TaskStatus {
    var tint: Color {
        switch self {
        case .planned: return .orange
        case .todo: return .blue
        case .inProgress: return .purple
        case .qa: return .cyan
        case .done: return .green
        }
    }
}
