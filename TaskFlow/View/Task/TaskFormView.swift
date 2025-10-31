//
//  TaskFormView.swift
//  TaskFlow
//
//  Created by İrem Sever on 29.10.2025.
//
import SwiftUI
import Combine
import FirebaseAuth

struct TaskFormView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = TasksViewModel()

    @State private var title = ""
    @State private var locationText = ""
    @State private var sla = Date().addingTimeInterval(60*60*4)
    @State private var assigneeName = ""
    @State private var assigneeEmail = ""

    enum Priority: String, CaseIterable { case low = "Düşük", normal = "Orta", high = "Yüksek" }
    @State private var priority: Priority = .normal
    @State private var category: String = ""
    @State private var checklistNote: String = ""
    @State private var detail = ""

    @State private var errorText: String?

    private let corner: CGFloat = 22
    private let fieldH: CGFloat = 28

    var body: some View {
        ZStack {
            (colorScheme == .dark ? Color.black : Color.white).ignoresSafeArea()
            LinearGradient(colors: [.blue.opacity(0.8), .purple.opacity(0.8)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            .opacity(colorScheme == .dark ? 0.5 : 0.2)
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .center, spacing: 16) {

                    SectionTitle("Görev Oluştur")
                        .padding(.top, -54)
                        .padding(.bottom, 8)

                    SettingsCard(corner: corner) {
                        LabelAndField(label: "* Görev Adı *") {
                            TextField("", text: $title)
                                .font(.custom("Helvetica-SemiBold", size: 16))
                                .textInputAutocapitalization(.words)
                                .multilineTextAlignment(.center) // 🟢 Ortalandı
                                .frame(height: fieldH)
                        }
                    }

                    SettingsCard(corner: corner) {
                        LabelAndField(label: "* Konum (Pin / Arama) *") {
                            TextField("", text: $locationText)
                                .font(.custom("Helvetica-SemiBold", size: 16))
                                .textInputAutocapitalization(.none)
                                .multilineTextAlignment(.center) // 🟢 Ortalandı
                                .frame(height: fieldH)
                        }
                    }

                    SettingsCard(corner: corner) {
                        VStack(alignment: .center, spacing: 12) {
                            Text("* Hedef Süre (SLA) *")
                                .font(.custom("Helvetica-SemiBold", size: 14))
                            DatePicker("", selection: $sla,
                                       displayedComponents: [.date, .hourAndMinute])
                                .labelsHidden()
                                .frame(height: fieldH)
                                .font(.custom("Helvetica-SemiBold", size: 16))
                        }
                    }

                    SettingsCard(corner: corner) {
                        VStack(alignment: .center, spacing: 10) {
                            LabelAndField(label: "* Atanan Kişi/Ekip *") {
                                TextField("", text: $assigneeName)
                                    .font(.custom("Helvetica-SemiBold", size: 16))
                                    .multilineTextAlignment(.center) // 🟢 Ortalandı
                                    .frame(height: fieldH)
                            }
                            LabelAndField(label: "* E-posta *") {
                                TextField("", text: $assigneeEmail)
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never) // 💾 E-posta büyük harf engelleme
                                    .autocorrectionDisabled()
                                    .font(.custom("Helvetica-SemiBold", size: 16))
                                    .multilineTextAlignment(.center) // 🟢 Ortalandı
                                    .frame(height: fieldH)
                            }
                        }
                    }

                    SectionSubTitle("Ek Alanlar")
                        .padding(.top, 4)

                    HStack(alignment: .center, spacing: 12) {
                        ChipButton(title: "Öncelik: \(priority.rawValue)") {
                            switch priority {
                                case .low: priority = .normal
                                case .normal: priority = .high
                                case .high: priority = .low
                            }
                        }
                        ChipButton(title: category.isEmpty ? "Kategori" : "Kategori: \(category)") {
                            if category.isEmpty { category = "Genel" }
                            else if category == "Genel" { category = "Bakım" }
                            else if category == "Bakım" { category = "Kurulum" }
                            else { category = "" }
                        }
                        ChipButton(title: checklistNote.isEmpty ? "Kontrol Listesi" : "Checklist: ✓") {
                            checklistNote = checklistNote.isEmpty ? "OK" : ""
                        }
                    }

                    SettingsCard(corner: corner) {
                        VStack(alignment: .center, spacing: 8) {
                            Text("Açıklama")
                                .font(.custom("Helvetica-Bold", size: 14))
                            TextEditor(text: $detail)
                                .font(.custom("Helvetica", size: 16))
                                .foregroundColor(.primary)
                                .padding(10)
                                .frame(minHeight: 90, alignment: .topLeading)
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.primary.opacity(0.12), lineWidth: 0.2)
                                )
                                .multilineTextAlignment(.center)
                        }
                    }

                    Text("Kural: Atama yapılmadan “Kaydet” yapılamaz • Konum seçilmezse “Konumum”da güncellenmelidir.")
                        .font(.custom("Helvetica", size: 12))
                        .foregroundColor(.primary.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)

                    if let err = errorText {
                        Text(err)
                            .font(.custom("Helvetica", size: 13))
                            .foregroundColor(.red)
                    }

                    PrimaryFillButton(title: "Kaydet", corner: corner) {
                        Task { await save() }
                    }
                    .disabled(!canSave)
                    .opacity(canSave ? 1 : 0.6)

                    Spacer(minLength: 12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
        }
        .onAppear {
            if auth.role != .admin { dismiss() }
        }
    }

    private var canSave: Bool {
        !title.isEmpty && !locationText.isEmpty && !assigneeName.isEmpty && !assigneeEmail.isEmpty
    }

    private func save() async {
        guard canSave else {
            errorText = "Lütfen zorunlu alanları doldurun."
            return
        }
        errorText = nil
        let assignee = Assignee(id: UUID().uuidString, name: assigneeName, email: assigneeEmail)
        do {
            try await vm.create(
                title: title,
                detail: detail.isEmpty ? nil : detail,
                sla: sla,
                assignee: assignee,
                currentUserId: Auth.auth().currentUser?.uid ?? ""
            )
            dismiss()
        } catch {
            errorText = "Kaydetme başarısız: \(error.localizedDescription)"
        }
    }
}


private struct LabelAndField<Field: View>: View {
    let label: String
    @ViewBuilder var field: () -> Field
    var body: some View {
        VStack(alignment: .center, spacing: 6) {
            Text(label)
                .font(.custom("Helvetica-Bold", size: 14))
            field()
        }
    }
}

private struct ChipButton: View {
    let title: String
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .multilineTextAlignment(.center)
                .font(.custom("Helvetica-Bold", size: 14))
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .foregroundColor(.primary)
                .background(RoundedRectangle(cornerRadius: 14).fill(Color.primary.opacity(0.05)))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.primary.opacity(0.12), lineWidth: 0.8))
        }
        .buttonStyle(.plain)
    }
}
