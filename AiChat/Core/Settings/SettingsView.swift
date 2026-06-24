//
//  SettingsView.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import SwiftUI
import SwiftfulUtilities

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.authService) private var authService
    @Environment(AppState.self) private var appState
    @State private var isPremium: Bool = false
    @State private var isAnonymousUser: Bool = true
    @State private var isUserSignedIn: Bool = false
    @State private var showCreateAccountView: Bool = false
    @State private var showErrorAlert: AnyAppAlert?
    
    var body: some View {
        NavigationStack {
            List {
                accountSection
                purchaseSection
                applicationSection
            }
            .navigationTitle("Settings")
        }
        .onAppear {
            UIScrollView.appearance().delaysContentTouches = false
            Task {
                await setAnonymousAccountStatus()
            }
        }
        .sheet(
            isPresented: $showCreateAccountView,
            onDismiss: {
                // Refresh auth status when sheet dismisses (in case user signed in)
                Task {
                    await setAnonymousAccountStatus()
                }
            },
            content: {
                CreateAccountView(
                    title: "Create Account?",
                    subtitle: "Don't lose your data! Connect to an SSO provider to save your account."
                )
                .presentationDetents([.medium])
            }
        )
        .showCustomAlert(type: .alert, alert: $showErrorAlert)
    }
    
    private var accountSection: some View {
        Section {
            if isUserSignedIn {
                if isAnonymousUser {
                    Text("Save & back-up Account")
                        .rowFormatting()
                        .anyButton(.highlight) {
                            onCreateAccountButtonPressed()
                        }
                } else {
                    Text("Sign Out")
                        .rowFormatting()
                        .anyButton(.highlight) {
                            onSignoutPressed()
                        }
                }

                Text("Delete Account")
                    .foregroundStyle(.red)
                    .rowFormatting()
                    .anyButton(.highlight) {
                        onDeleteAccountPressed()
                    }
            } else {
                Text("Sign In")
                    .rowFormatting()
                    .anyButton(.highlight) {
                        onCreateAccountButtonPressed()
                    }
            }
        } header: {
            Text("Account")
        }
    }
    
    private var purchaseSection: some View {
        Section {
            HStack(spacing: 8) {
                Text("Account Status : \(isPremium ? "PREMIUM" : "FREE")")
                Spacer(minLength: 0)
                if isPremium {
                    Text("MANAGE")
                      .badgeButton()
                }
            }
            .rowFormatting()
            .anyButton(.highlight) {
                onSignoutPressed()
            }
            .disabled(!isPremium)
            
        } header: {
            Text("Purchases")
        }
    }
    
    private var applicationSection: some View {
        Section {
            HStack {
                Text("Version")
                Spacer()
                Text(Utilities.appVersion ?? "")
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }
            .rowFormatting()
            HStack {
                Text("Build")
                Spacer()
                Text(Utilities.buildNumber ?? "")
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }
            .rowFormatting()
            Text("Contact us")
               .foregroundStyle(.red)
               .rowFormatting()
               .anyButton(.highlight) {
                   onSignoutPressed()
               }
        } header: {
            Text("Application")
        } footer: {
            Text("Created by Sathya Kumar \n Learn More www.swiftfulthinking.com")
                .baselineOffset(6)
        }
    }
    
    func onSignoutPressed() {
        Task {
            do {
                try authService.signout()
                await setAnonymousAccountStatus() // Refresh UI state
                try? await Task.sleep(for: .seconds(1))
                appState.updateViewState(showTabBarView: false)
            } catch {
                showErrorAlert = AnyAppAlert(error: AuthError.userNotFound)
            }
            dismiss()
        }
    }
    
    func onDeleteAccountPressed() {
        showErrorAlert = AnyAppAlert(title: "Delete Account?", subtitle: "Are you sure you want to delete your Account? This action cannot be undone and Your data will be deleted from our server forever", showButtons: {
            AnyView(
                Button("Delete", role: .destructive) {
                    onDeleteAccountConfirmationPressed()
                }
            )
        })
    }
    
    private func onDeleteAccountConfirmationPressed() {
        Task {
            do {
                try await authService.deleteAccount()
                await setAnonymousAccountStatus() // Refresh UI state
                try? await Task.sleep(for: .seconds(1))
                appState.updateViewState(showTabBarView: false)
            } catch {
                showErrorAlert = AnyAppAlert(error: AuthError.userNotFound)
            }
            dismiss()
        }
    }
    
    func onCreateAccountButtonPressed() {
        showCreateAccountView.toggle()
    }
    
    func setAnonymousAccountStatus() async {
        do {
            let user = try await authService.getAuthenticatedUserRefreshed()
            isUserSignedIn = user != nil
            isAnonymousUser = user?.isAnonymous == true
        } catch {
            let user = authService.getAuthenticatedUser()
            isUserSignedIn = user != nil
            isAnonymousUser = user?.isAnonymous == true
        }
    }
}

fileprivate extension View {
    func rowFormatting() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 4)
            .padding(.horizontal, 12)
            .background(Color(uiColor: .systemBackground))
    }
}

#Preview("No Auth") {
    SettingsView()
        .environment(\.authService, MockAuthService(user: nil))
        .environment(AppState())
}

#Preview("SignIn Anonymously") {
    SettingsView()
        .environment(\.authService, MockAuthService(user: UserAuthInfo.mock(isAnonymous: true)))
        .environment(AppState())
}

#Preview("SignIn with Google") {
    SettingsView()
        .environment(\.authService, MockAuthService(user: UserAuthInfo.mock(isAnonymous: false)))
        .environment(AppState())
}
