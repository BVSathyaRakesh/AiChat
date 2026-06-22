//
//  AnyAppAlert.swift
//  AiChat
//
//  Created by Sathya Kumar on 22/06/26.
//

import SwiftUI
struct AnyAppAlert {
    var title: String
    var subtitle: String?
    var showButtons: () -> AnyView
    
    init(
        title: String,
        subtitle: String? = nil,
        showButtons: (() -> AnyView)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.showButtons = showButtons ?? {
            AnyView(
                    Button("OK") {
                        
                    }
            )
        }
    }
    
    init(error: Error) {
        self.init(
            title: "Error",
            subtitle: error.localizedDescription,
            showButtons: nil
        )
    }
}
