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
    @Environment(AppState.self) private var appState
    @State private var isPremium: Bool = false
    @State private var isAnonymousUser: Bool = true
    @State private var showCreateAccountView: Bool = false
    
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
        }
        .sheet(isPresented: $showCreateAccountView) {
            CreateAccountView(
                title: "Create Account?",
                subtitle: "Don't lose your data! Connect to an SSO provider to save your account."
            )
            .presentationDetents([.medium])
        }
    }
    
    private var accountSection: some View {
        Section {
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
                    onSignoutPressed()
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
        // do some logic to sign out the user
        dismiss()
        Task {
            try? await Task.sleep(for: .seconds(1))
            appState.updateViewState(showTabBarView: false)
        }
    }
    
    func onCreateAccountButtonPressed() {
        showCreateAccountView.toggle()
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

#Preview {
    SettingsView()
        .environment(AppState())
}
