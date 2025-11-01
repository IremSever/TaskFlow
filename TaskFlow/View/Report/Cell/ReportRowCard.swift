//
//  ReportRowCard.swift
//  TaskFlow
//
//  Created by İrem Sever on 1.11.2025.
//

import SwiftUI

struct ReportRowCard: View {
    let task: TFTask
    let corner: CGFloat
    let durationText: String
    let slaText: String
    let onOpenPDF: () -> Void
    let onShare: () -> Void

    var body: some View {
        AppCard(corner: corner) {
            VStack(alignment: .center, spacing: 16) {
              
                VStack(alignment: .center, spacing: 4) {
                    Text(reportTitle)
                        .font(.custom("Helvetica-Bold", size: 14))
                        .foregroundColor(.primary)
                    
                    Text(metaLine)
                        .font(.custom("Helvetica", size: 12))
                        .foregroundColor(.primary.opacity(0.65))
                }
                

                HStack(spacing: 12) {
                    PillOutlineButton(title: "PDF Aç", systemImage: "doc.richtext") {
                        onOpenPDF()
                    }
                    PillOutlineButton(title: "Paylaş", systemImage: "square.and.arrow.up") {
                        onShare()
                    }
                }
                .padding(.horizontal, 20)

            }
        }
    }

    private var reportTitle: String {
        task.title
    }

    private var metaLine: String {
        "Süre \(durationText) • \(slaText)"
    }
}
