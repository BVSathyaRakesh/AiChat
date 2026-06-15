//
//  SettingsView.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) private var appState
    
    var body: some View {
        NavigationStack {
            List {
                Button {
                    onSignoutPressed()
                } label: {
                    Text("Sign Out")
                }
            }
            .navigationTitle("Settings")
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
}

#Preview {
    SettingsView()
        .environment(AppState())
}
