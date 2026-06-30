//
//  ImageLoaderView.swift
//  AiChat
//
//  Created by Sathya Kumar on 16/06/26.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageLoaderView: View {

    var urlString = Constants.randomImage
    var resizingMode: ContentMode = .fill
    var forceTransitionAnimation: Bool = false
    @State private var imageLoadFailed = false

    var body: some View {
        Rectangle()
            .opacity(0.001)
            .overlay {
                if imageLoadFailed {
                    placeholderView
                } else {
                    WebImage(url: URL(string: urlString)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .onSuccess { _, _, _ in
                        imageLoadFailed = false
                    }
                    .onFailure { error in
                        print("Image loading failed: \(error.localizedDescription)")
                        imageLoadFailed = true
                    }
                    .indicator(.activity)
                    .allowsHitTesting(false)
                }
            }
            .clipped()
            .if(forceTransitionAnimation) { view in
                view.drawingGroup()
            }
    }

    private var placeholderView: some View {
        ZStack {
            Color.gray.opacity(0.2)

            VStack(spacing: 8) {
                Image(systemName: "photo")
                    .font(.system(size: 40))
                    .foregroundStyle(.gray)

                Text("Image not available")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    ImageLoaderView()
        .frame(width: 100, height: 200)
        .anyButton(.highlight) {
            
        }
}
