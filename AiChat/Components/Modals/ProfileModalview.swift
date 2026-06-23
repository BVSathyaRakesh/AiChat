//
//  ProfileModalview.swift
//  AiChat
//
//  Created by Sathya Kumar on 23/06/26.
//

import SwiftUI

struct ProfileModalview: View {
    
    var imageName: String? = Constants.randomImage
    var title: String? = "Alpha"
    var subtitle: String? = "Alien"
    var headline: String? = "An Alien that walks in the park"
    var onMarkPressed: () -> Void = {}
    
    var body: some View {
        VStack(spacing: 4) {
            if let imageName {
                ImageLoaderView(
                    urlString: imageName,
                    forceTransitionAnimation: true
                )
                 .aspectRatio(1, contentMode: .fit)
            }
            VStack(alignment: .leading, spacing: 4) {
                if let title {
                    Text(title)
                        .font(.title)
                        .fontWeight(.semibold)
                }
                
                if let subtitle {
                    Text(subtitle)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                
                if let headline {
                    Text(headline)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
              Image(systemName: "xmark.circle.fill")
                .font(.title2)
                .foregroundStyle(.black)
                .padding(4)
                .tappableBackground()
                .anyButton {
                    onMarkPressed()
                }
            , alignment: .topTrailing
        )
    }
}

#Preview("with Image") {
    ZStack {
        Color.black.ignoresSafeArea()
            .opacity(0.7)
        ProfileModalview()
            .padding(40)
    }
}

#Preview("without Image") {
    ZStack {
        Color.black.ignoresSafeArea()
            .opacity(0.7)
        ProfileModalview(imageName: nil)
            .padding(40)
    }
}
