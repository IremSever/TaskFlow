//
//  TaskDetailView.swift
//  TaskFlow
//
//  Created by İrem Sever on 29.10.2025.
//
import SwiftUI
import Combine
import FirebaseFirestore

struct TaskDetailView: View {
    private let initialTask: TFTask
    @State private var task: TFTask
    
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var vm = TasksViewModel()
    @State private var isAdvancing = false
    private let corner: CGFloat = 22
    
    init(task: TFTask) {
        self.initialTask = task
        _task = State(initialValue: task)
    }
    
    var body: some View {
        ZStack {
            (colorScheme == .dark ? Color.black : Color.white).ignoresSafeArea()
            LinearGradient(
                colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .opacity(colorScheme == .dark ? 0.5 : 0.2)
            .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .center, spacing: 16) {
                    SectionTitle("Görev Detayı")
                        .padding(.top, -50)
                    
                    StatusChipRow(current: task.status)
                    
                    if let detail = task.detail, !detail.isEmpty {
                        Text(detail)
                            .multilineTextAlignment(.center)
                            .font(.custom("Helvetica", size: 10))
                            .foregroundColor(.primary.opacity(0.85))
                    }
                    
                    TaskInfoCard(task: task, corner: corner)
                    
                    StepCard(title: "Yapılacak", icon: "play.circle", tint: .blue, corner: corner) {
                        VStack(alignment: .center, spacing: 6) {
                            Label(task.assignee.name, systemImage: "person.circle")
                            Text("Atanmış görev başlıyor")
                                .font(.custom("Helvetica", size: 13))
                                .foregroundColor(.primary.opacity(0.7))
                        }
                    }
                    
                    StepCard(title: "Çalışmada", icon: "hammer", tint: .purple, corner: corner) {
                        Text("Fotoğraf/Video, Notlar, İşaretleme")
                            .font(.custom("Helvetica", size: 13))
                            .foregroundColor(.primary.opacity(0.7))
                    }
                    
                    StepCard(title: "Kontrol", icon: "checklist", tint: .cyan, corner: corner) {
                        Text("Checklist")
                            .font(.custom("Helvetica", size: 13))
                            .foregroundColor(.primary.opacity(0.7))
                    }
                    
                    StepCard(title: "Tamamlandı", icon: "checkmark.seal", tint: .green, corner: corner) {
                        Text("Görev tamamlandı.")
                            .font(.custom("Helvetica", size: 13))
                            .foregroundColor(.primary.opacity(0.7))
                    }
                    PrimaryFillButton(title: nextButtonTitle(for: task.status), corner: corner) {
                        Task {
                            isAdvancing = true
                            defer { isAdvancing = false }
                            
                            if let updated = try? await vm.advance(task) {
                                task = updated
                            }
                        }
                    }
                    .disabled(task.status == .done || isAdvancing)
                    .opacity(isAdvancing ? 0.6 : 1.0)
                    
                    .disabled(task.status == .done || isAdvancing)
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                
            }
            .scrollIndicators(.hidden)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func nextButtonTitle(for s: TaskStatus) -> String {
        switch s {
        case .planned: return "Planmayı tamamla"
        case .todo: return "Çalışmaya başla"
        case .inProgress: return "Kontrole gönder"
        case .qa: return "Tamamamlaya geç"
        case .done: return "Tamamla"
        }
    }
}

private struct StatusChipRow: View {
    let current: TaskStatus
    var body: some View {
        HStack(spacing: 8) {
            ForEach(TaskStatus.allCases, id: \.self) { s in
                Text(s.title)
                    .font(.custom("Helvetica-Bold", size: 10))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(s == current ? s.tint.opacity(0.9) : Color.primary.opacity(0.15))
                    )
                    .foregroundColor(s == current ? .white : .primary)
            }
        }
    }
}
