//
//  PDFService.swift
//  TaskFlow
//
//  Created by İrem Sever on 29.10.2025.
//
import PDFKit
import SwiftUI

struct ReportInfo {
    let task: TFTask
    let finishedAt: Date
    let author: String
}

final class PDFService {
    func makeReport(_ info: ReportInfo) throws -> URL {
        let pdf = PDFDocument()
        let page = PDFPage(image: renderPage(info))!
        pdf.insert(page, at: 0)
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("TASKFLOW_\(info.task.id).pdf")
        guard pdf.write(to: url) else { throw NSError(domain: "pdf", code: -1) }
        return url
    }

    private func renderPage(_ info: ReportInfo) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 612, height: 792)) // A4 @72dpi
        return renderer.image { ctx in
            let title = "Görev Raporu"
            title.draw(at: CGPoint(x: 40, y: 40), withAttributes: [.font: UIFont.boldSystemFont(ofSize: 24)])
            let text =
            """
            Görev: \(info.task.title)
            Açıklama: \(info.task.detail ?? "-")
            Durum: \(info.task.status.rawValue)
            SLA: \(format(info.task.slaDeadline))
            Tamamlanma: \(format(info.finishedAt))
            Sorumlu: \(info.task.assignee.name)
            Oluşturan: \(info.author)
            """
            text.draw(in: CGRect(x: 40, y: 100, width: 532, height: 600),
                      withAttributes: [.font: UIFont.systemFont(ofSize: 14)])
        }
    }

    private func format(_ d: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium; f.timeStyle = .short
        return f.string(from: d)
    }
}
