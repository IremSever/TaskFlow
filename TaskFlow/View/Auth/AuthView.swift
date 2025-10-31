//
//  AuthView.swift
//  TaskFlow
//
//  Created by İrem Sever on 29.10.2025.
//
import SwiftUI
import Combine

struct AuthView: View {
    
    @EnvironmentObject var vm: AuthViewModel
    @Environment(\.colorScheme) private var colorScheme
    @FocusState private var focused: Field?
    @AppStorage("rememberMe") private var rememberMe = false
    enum Field { case email, password }
    
    private let fieldHeight: CGFloat = 48
    private let cornerRadius: CGFloat = 22
    
    var body: some View {
        ZStack {
            (colorScheme == .dark ? Color.black : Color.white)
                .ignoresSafeArea()

            LinearGradient(
                colors: [Color.blue, Color.purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .opacity(colorScheme == .dark ? 0.5 : 0.2)
            .ignoresSafeArea()

            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Image("logo")
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .shadow(color: colorScheme == .dark ? .white.opacity(0.15) :.black.opacity(0.15), radius: 8, y: 8)

                    Text("TaskFlow")
                        .font(.custom("Helvetica-Bold", size: 36))
                        .foregroundColor(.primary)

                    Text("Planla, Takip et, Tamamla")
                        .font(.custom("Helvetica", size: 14))
                        .foregroundColor(.primary.opacity(0.7))
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .padding(.bottom, 12)
                
                customField(placeholder: "E-posta", text: $vm.email, secure: false)
                    .focused($focused, equals: .email)
                    .submitLabel(.next)
                    .onSubmit { focused = .password }
                
                customField(placeholder: "Şifre", text: $vm.password, secure: true)
                    .focused($focused, equals: .password)
                    .submitLabel(.go)
                    .onSubmit { signIn() }
                
                if let err = vm.errorText, !err.isEmpty {
                    Text(err)
                        .font(.custom("Helvetica", size: 14))
                        .foregroundColor(.red)
                        .transition(.opacity)
                }
                
                HStack(spacing: 10) {
                    Checkbox(isOn: $rememberMe)
                    Text("Beni Hatırla")
                        .font(.custom("Helvetica", size: 15))
                        .foregroundColor(.primary.opacity(0.9))
                  
                }
                .padding(.top, 8)
                
                Button(action: signIn) {
                    Text("Giriş Yap")
                        .font(.custom("Helvetica-Bold", size: 18))
                        .frame(maxWidth: .infinity, minHeight: fieldHeight)
                        .foregroundColor(buttonTextColor)
                        .overlay(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(buttonBorderColor, lineWidth: 1.6)
                        )
                }
                .disabled(isDisabled)
                .opacity(vm.isLoading ? 0.85 : 1)
                .padding(.top, 8)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .preferredColorScheme(nil)
    }
    
    private var backgroundBase: Color {
        colorScheme == .dark ? .black : .white
    }
    
    private var isDisabled: Bool {
        vm.isLoading || vm.email.isEmpty || vm.password.isEmpty
    }
    
    private var buttonBorderColor: Color {
        isDisabled ? .gray.opacity(0.6) : .primary
    }
    
    private var buttonTextColor: Color {
        isDisabled ? .gray.opacity(0.9) : .primary
    }
    
    private func signIn() {
        Task { await vm.signIn(rememberEmail: rememberMe) }
    }
    
    @ViewBuilder
    private func customField(placeholder: String, text: Binding<String>, secure: Bool) -> some View {
        ZStack(alignment: .leading) {
            if text.wrappedValue.isEmpty {
                Text(placeholder)
                    .font(.custom("Helvetica", size: 16))
                    .foregroundColor(.primary.opacity(0.5))
                    .padding(.horizontal, 18)
            }
            Group {
                if secure {
                    SecureField("", text: text)
                } else {
                    TextField("", text: text)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                }
            }
            .font(.custom("Helvetica", size: 16))
            .foregroundColor(.primary)
            .padding(.horizontal, 18)
        }
        .frame(height: fieldHeight)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.primary.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.primary.opacity(0.15), lineWidth: 0.8)
        )
        .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
    }
}


