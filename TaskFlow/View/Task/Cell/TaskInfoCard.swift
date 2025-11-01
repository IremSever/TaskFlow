//
//  TaskInfoCard.swift
//  TaskFlow
//
//  Created by İrem Sever on 31.10.2025.
//
import SwiftUI

struct TaskInfoCard: View {
    let task: TFTask
    let corner: CGFloat
    
    var body: some View {
        AppCard(corner: corner) {
            InfoRow(icon: "hourglass", label: "SLA", value: task.slaDeadline.shortStamp) 
            InfoRow(icon: "calendar.badge.plus", label: "Oluşturma", value: task.createdAt.shortStamp)
            InfoRow(icon: "person", label: "Atanan", value: task.assignee.name)
            InfoRow(icon: "envelope", label: "E-posta", value: task.assignee.email)
        }
    }
}

private extension Date {
    var shortStamp: String {
        let f = DateFormatter()
        f.locale = .current
        f.dateStyle = .medium
        f.timeStyle = .short
        return f.string(from: self)
    }
}
