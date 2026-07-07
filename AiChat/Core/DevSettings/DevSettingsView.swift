//
//  DevSettingsView.swift
//  AiChat
//
//  Created by Sathya Kumar on 07/07/26.
//

import SwiftUI

struct DevSettingsView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(AuthManager.self) private var authManager
    @Environment(UserManager.self) private var userManager

    private let deviceInfo = DeviceInfo()

    var body: some View {
        NavigationStack {
            List {
                authInfoSection
                userInfoSection
                deviceInfoSection
            }
            .navigationTitle("Dev Settings 😜")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "xmark")
                        .font(.headline)
                        .anyButton {
                            dismiss()
                        }
                }
            }
        }
    }

    private var authInfoSection: some View {
        Section {
            let sortedAuthParameters = (authManager.auth?.eventParameters ?? [:]).asAlphabeticalArray

            ForEach(sortedAuthParameters, id: \.key) { parameter in
                parameterRow(key: parameter.key, value: parameter.value)
            }
        } header: {
            Text("AUTH INFO")
        }
    }

    private var userInfoSection: some View {
        Section {
            let sortedUserParameters = (userManager.currentuser?.eventParameters ?? [:]).asAlphabeticalArray

            ForEach(sortedUserParameters, id: \.key) { parameter in
                parameterRow(key: parameter.key, value: parameter.value)
            }
        } header: {
            Text("USER INFO")
        }
    }

    private var deviceInfoSection: some View {
        Section {
            let sortedDeviceParameters = deviceInfo.eventParameters.asAlphabeticalArray

            ForEach(sortedDeviceParameters, id: \.key) { parameter in
                parameterRow(key: parameter.key, value: parameter.value)
            }
        } header: {
            Text("DEVICE INFO")
        }
    }

    @ViewBuilder
    private func parameterRow(key: String, value: Any) -> some View {
        HStack {
            Text(key)
            Spacer(minLength: 4)
            if let value = value as? String {
                Text(value)
            } else if let value = value as? Bool {
                Text(value.description)
            } else if let value = value as? Int {
                Text("\(value)")
            } else if let value = value as? Double {
                Text("\(value)")
            } else if let value = value as? Date {
                Text(value.formatted())
            } else {
                Text("Unknown")
            }
        }
        .font(.caption)
        .lineLimit(1)
        .minimumScaleFactor(0.3)
    }
}

#Preview {
    DevSettingsView()
        .environment(AuthManager(authService: MockAuthService(user: .mock())))
        .environment(UserManager(services: MockUserServices(userModal: .mock)))
}
