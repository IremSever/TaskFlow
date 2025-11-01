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
    
    @State private var stageNotes: [String: String] = [:]

    init(task: TFTask) {
        self.initialTask = task
        _task = State(initialValue: task)
        _stageNotes = State(initialValue: task.stageNotes ?? [:])
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
                        StageNoteSection(
                            isActive: task.status == .todo,
                            text: Binding(
                                get: { stageNotes[TaskStatus.todo.rawValue] ?? "" },
                                set: { stageNotes[TaskStatus.todo.rawValue] = $0 }
                            ),
                            placeholder: "Yapılacak için not girin..."
                        )
                    }

                    StepCard(title: "Çalışmada", icon: "hammer", tint: .purple, corner: corner) {
                        StageNoteSection(
                            isActive: task.status == .inProgress,
                            text: Binding(
                                get: { stageNotes[TaskStatus.inProgress.rawValue] ?? "" },
                                set: { stageNotes[TaskStatus.inProgress.rawValue] = $0 }
                            ),
                            placeholder: "Çalışmada için not girin..."
                        )
                    }

                    StepCard(title: "Kontrol", icon: "checklist", tint: .cyan, corner: corner) {
                        StageNoteSection(
                            isActive: task.status == .qa,
                            text: Binding(
                                get: { stageNotes[TaskStatus.qa.rawValue] ?? "" },
                                set: { stageNotes[TaskStatus.qa.rawValue] = $0 }
                            ),
                            placeholder: "Kontrol için not girin..."
                        )
                    }

                    StepCard(title: "Tamamlandı", icon: "checkmark.seal", tint: .green, corner: corner) {
                        StageNoteSection(
                            isActive: task.status == .done,
                            text: Binding(
                                get: { stageNotes[TaskStatus.done.rawValue] ?? "" },
                                set: { stageNotes[TaskStatus.done.rawValue] = $0 }
                            ),
                            placeholder: "Tamamlandı notu..."
                        )
                    }

                    PrimaryFillButton(title: nextButtonTitle(for: task.status), corner: corner) {
                        Task {
                            isAdvancing = true
                            defer { isAdvancing = false }

                            let currentStatusKey = task.status.rawValue
                            let currentNote = stageNotes[currentStatusKey]

                            if let updated = try? await vm.advance(task, note: currentNote) {
                                task = updated
                                stageNotes = updated.stageNotes ?? stageNotes
                            }
                        }
                    }
                    .disabled(task.status == .done || isAdvancing)
                    .opacity(isAdvancing ? 0.6 : 1.0)
                    
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
        case .qa: return "Tamamlamaya geç"
        case .done: return "Tamamlandı"
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
