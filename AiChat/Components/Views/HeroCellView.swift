//
//  HeroCellView.swift
//  AiChat
//
//  Created by Sathya Kumar on 17/06/26.
//

import SwiftUI

struct HeroCellView: View {
    
    var title: String? = "This is some Title"
    var subtitle: String? = "This is sample subtitle that will go here"
    var image: String?  = Constants.randomImage
     
    var body: some View {
        ZStack {
            if let image {
                ImageLoaderView(urlString: image)
            }else {
                Rectangle()
                    .fill(.accent)
            }
        }
        .overlay(
            alignment: .bottomLeading,
            content: {
                VStack(alignment: .leading, spacing: 4) {
                    Spacer()
                    if let title {
                        Text(title)
                            .font(.headline)
                    }
                    if let subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                    }
                }
                .foregroundStyle(.white)
                .padding(16)
                .frame(maxWidth:.infinity, alignment: .leading)
                .background(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0),
                            Color.black.opacity(0.3),
                            Color.black.opacity(0.4)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        })
        .cornerRadius(16)
    }
}

#Preview {
    ScrollView{
        VStack{
            HeroCellView()
                .frame(width: 300, height: 200)
            
            HeroCellView(image: nil)
                .frame(width: 300, height: 200)
            
            HeroCellView()
                .frame(width: 200, height: 500)
            
            HeroCellView(title: nil)
                .frame(width: 300, height: 200)
            
            HeroCellView(subtitle: nil)
                .frame(width: 300, height: 200)
        }
        .frame(maxWidth: .infinity)
    }
}
