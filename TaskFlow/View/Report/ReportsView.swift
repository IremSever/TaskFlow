//
//  ReportsView.swift
//  TaskFlow
//
//  Created by İrem Sever on 29.10.2025.
//
import SwiftUI
import PDFKit
import UIKit

struct ReportsView: View {
    var isRoot: Bool = true
    @StateObject private var vm = ReportsViewModel()
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

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    LazyVStack(spacing: 16) {
                        ForEach(vm.completedTasks) { task in
                            ReportRowCard(
                                task: task,
                                corner: corner,
                                durationText: vm.duration(for: task),
                                slaText: vm.slaText(for: task),
                                onOpenPDF: {
                                    Task {
                                        let url = try await vm.openPDF(for: task)
                                        vm.openPDFExternally(url: url)
                                    }
                                },
                                onShare: {
                                    Task {
                                        let url = try await vm.openPDF(for: task)
                                        vm.share(url: url)
                                    }
                                }
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
        }
        .safeAreaInset(edge: .top) {
            SectionTitle("Raporlarım")
                .padding(.horizontal, 20)
                .padding(.top, isRoot ? 4 : -54)
        }
        .onAppear { vm.loadCompletedTasks() }
        .sheet(item: $vm.sharedURL) { url in
            ShareSheet(activityItems: [url])
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .toolbar(isRoot ? .hidden : .visible, for: .navigationBar)
        .toolbarBackground(isRoot ? .hidden : .visible, for: .navigationBar)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
