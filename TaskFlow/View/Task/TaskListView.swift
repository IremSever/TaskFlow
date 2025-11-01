//
//  TaskListView.swift
//  TaskFlow
//
//  Created by İrem Sever on 29.10.2025.
//
import SwiftUI
import Combine
import UIKit

struct TaskListView: View {
    var isRoot: Bool = true

    @StateObject var vm = TasksViewModel()
    @State private var shareURL: URL?
    private let pdf = PDFService()
    @Environment(\.colorScheme) private var colorScheme
    private let corner: CGFloat = 22

    var body: some View {
        ZStack {
            (colorScheme == .dark ? Color.black : Color.white).ignoresSafeArea()
            LinearGradient(
                colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .opacity(colorScheme == .dark ? 0.5 : 0.2)
            .ignoresSafeArea()

            List(vm.tasks) { task in
                NavigationLink {
                    TaskDetailView(task: task)
                } label: {
                    HStack(alignment: .center, spacing: 12) {
                        Circle().fill(task.status.tint).frame(width: 10, height: 10)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(task.title)
                                .font(.custom("Helvetica-Bold", size: 15))
                                .foregroundColor(.primary)
                            Text(task.status.rawValue)
                                .font(.custom("Helvetica-SemiBold", size: 11))
                                .foregroundColor(.primary.opacity(0.60))
                        }
                        Spacer(minLength: 8)
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: corner).fill(Color.primary.opacity(0.05)))
                    .overlay(RoundedRectangle(cornerRadius: corner).stroke(Color.primary.opacity(0.12), lineWidth: 0.8))
                    .shadow(color: colorScheme == .dark ? .white.opacity(0.08) : .black.opacity(0.08), radius: 6, y: 3)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 6)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button("İlerle") { Task { try? await vm.advance(task) } }.tint(.primary.opacity(0.05))
                    if task.status == .done {
                        Button("PDF") {
                            Task {
                                let url = try pdf.makeReport(.init(task: task, finishedAt: .now, author: task.assignee.name))
                                shareURL = url
                            }
                        }.tint(.green.opacity(0.05))
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .safeAreaInset(edge: .top) {
            SectionTitle("Görevler")
                .padding(.horizontal, 20)
                .padding(.top, isRoot ? 0 : -54)
                .background(.clear)
        }

        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .toolbar(isRoot ? .hidden : .visible, for: .navigationBar)
        .toolbarBackground(isRoot ? .hidden : .visible, for: .navigationBar)

        .navigationDestination(for: TFTask.self) { TaskDetailView(task: $0) }
        .onAppear { vm.startListening() }
        .sheet(item: $shareURL) { url in ShareSheet(activityItems: [url]) }
    }
}


extension URL: Identifiable {
    public var id: String { absoluteString }
}
