//
//  CategoryCellView.swift
//  AiChat
//
//  Created by Sathya Kumar on 18/06/26.
//

import SwiftUI

struct CategoryCellView: View {
    
    var title: String?
    var imageName: String = Constants.randomImage
    var font: Font? = .title
    var cornerRadius: CGFloat = 16
    
    var body: some View {
        ZStack {
            ImageLoaderView(urlString: imageName)
                .aspectRatio(1, contentMode: .fit)
        }
        .overlay(alignment: .bottomLeading) {
           textContainer
                .foregroundStyle(.white)
                .font(font)
                .fontWeight(.semibold)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .addingGradientBackgroundFortext()
                
        }
        .cornerRadius(cornerRadius)
    }
    
    var textContainer: some View {
        VStack(alignment: .leading) {
            if let title {
                Text(title)
            } else {
                Text("Men")
            }
        }
    }
    
}

#Preview {
    CategoryCellView()
        .frame(width: 150)
}
