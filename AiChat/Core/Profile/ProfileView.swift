//
//  ProfileView.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var showSettings: Bool = false
    
    var body: some View {
        NavigationStack {
            Text("Profile")
                .navigationTitle("Profile")
                .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                   profileButton
                }
            }
        }
        .sheet(isPresented: $showSettings) {
           SettingsView()
        }
    }
    
    private var  profileButton: some View {
        Button {
            profileButtonAction()
        } label: {
            Image(systemName: "gear")
        }
    }
    
    private func profileButtonAction() {
        showSettings.toggle()
    }
}

#Preview {
    ProfileView()
}
