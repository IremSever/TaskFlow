//
//  ExportSheet.swift
//  TaskFlow
//
//  Created by İrem Sever on 31.10.2025.
//
import SwiftUI
import UniformTypeIdentifiers
import UIKit

struct ExportSheet: View {
    let url: URL
    @Binding var isPresented: Bool
    var onShare: () -> Void

    @Environment(\.colorScheme) private var colorScheme
    private let corner: CGFloat = 22

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

            VStack(spacing: 40) {
                ZStack {
                    SectionTitle("Dışa Aktar")
                    HStack {
                        Spacer()
                        Button { isPresented = false } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.primary.opacity(0.85))
                        }
                    }
                }
                .padding(.top, 16)
                SettingsCard(corner: corner) {
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.primary.opacity(0.12))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "doc.json")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.primary.opacity(0.8))
                            )
                        VStack(alignment: .leading, spacing: 2) {
                            Text(url.lastPathComponent)
                                .font(.custom("Helvetica-Bold", size: 16))
                            Text("JSON • \(byteString(of: url))")
                                .font(.custom("Helvetica", size: 12))
                                .foregroundColor(.primary.opacity(0.7))
                        }
                        Spacer()
                    }
                }

                HStack(spacing: 12) {
                    ActionPill(title: "Kopyala", icon: "doc.on.doc") {
                        if let data = try? Data(contentsOf: url) {
                            UIPasteboard.general.setData(data, forPasteboardType: UTType.json.identifier)
                        } else {
                            UIPasteboard.general.url = url
                        }
                    }
                    ActionPill(title: "Kaydet", icon: "folder") {
                        presentExportPicker(url)
                    }
                    ActionPill(title: "Paylaş", icon: "square.and.arrow.up") {
                        onShare()
                    }
                }
                .padding(.horizontal, 8)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
        }
    }

    private func byteString(of url: URL) -> String {
        if let values = try? url.resourceValues(forKeys: [.fileSizeKey]),
           let size = values.fileSize {
            return ByteCountFormatter.string(fromByteCount: Int64(size), countStyle: .file)
        }
        if let attrs = try? FileManager.default.attributesOfItem(atPath: url.path),
           let size = (attrs[.size] as? NSNumber)?.int64Value {
            return ByteCountFormatter.string(fromByteCount: size, countStyle: .file)
        }
        return "—"
    }

    private func presentExportPicker(_ url: URL) {
        let vc = UIDocumentPickerViewController(forExporting: [url], asCopy: true)
        UIApplication.shared.keyWindowTop?.present(vc, animated: true)
    }
}

struct ActionPill: View {
    let title: String
    let icon: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon).font(.system(size: 12, weight: .semibold))
                Text(title).font(.custom("Helvetica-SemiBold", size: 12))
            }
            .foregroundColor(.primary)
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.primary.opacity(0.05)))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.primary.opacity(0.12), lineWidth: 0.8))
        }
        .buttonStyle(.plain)
    }
}

