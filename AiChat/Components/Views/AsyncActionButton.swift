//
//  AsyncActionButton.swift
//  AiChat
//
//  Created by Sathya Kumar on 21/06/26.
//

import SwiftUI

struct AsyncActionButton: View {
    let title: String
    let action: () async -> Void

    @State private var isLoading: Bool = false

    var body: some View {
        Button {
            Task {
                isLoading = true
                await action()
                isLoading = false
            }
        } label: {
            ZStack {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(title)
                }
            }
            .callToFunctionButton()
        }
        .disabled(isLoading)
    }
}

#Preview {
    VStack(spacing: 20) {
        AsyncActionButton(title: "Finish") {
            try? await Task.sleep(for: .seconds(2))
            print("Action completed")
        }

        AsyncActionButton(title: "Save") {
            try? await Task.sleep(for: .seconds(1))
            print("Saved")
        }
    }
    .padding()
}
