//
//  CustomDeleteAlert.swift
//  AiChat
//
//  Created by Sathya Kumar on 03/07/26.
//

import SwiftUI

struct CustomDeleteAlert: View {
    let title: String
    let message: String
    let deleteAction: () -> Void
    let cancelAction: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            HStack(spacing: 12) {
                Button {
                    cancelAction()
                } label: {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.secondary.opacity(0.2))
                        .foregroundStyle(.primary)
                        .cornerRadius(10)
                }

                Button {
                    deleteAction()
                } label: {
                    Text("Delete")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding(24)
        .background(.regularMaterial)
        .cornerRadius(16)
        .shadow(radius: 20)
        .padding(.horizontal, 40)
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.3)
            .ignoresSafeArea()

        CustomDeleteAlert(
            title: "Delete Avatar",
            message: "Are you sure you want to delete \"Raji\"?",
            deleteAction: { print("Delete") },
            cancelAction: { print("Cancel") }
        )
    }
}
