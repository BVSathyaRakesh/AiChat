//
//  CustomListsCellView.swift
//  AiChat
//
//  Created by Sathya Kumar on 19/06/26.
//

import SwiftUI

struct CustomListsCellView: View {
    
    var title: String? = "Alien"
    var subtitle: String? = "An Alien that walks in the park"
    var imageName: String? = Constants.randomImage
    
    var body: some View {
        HStack(spacing: 8) {
            
            ZStack {
                if let imageName {
                    ImageLoaderView(urlString: imageName)
                } else {
                    Rectangle()
                     .fill(.gray)
                }
            }
              .aspectRatio(1, contentMode: .fit)
              .frame(height: 60)
               .cornerRadius(16)
            
            VStack(alignment: .leading) {
                if let title {
                    Text(title)
                        .font(.headline)
                }
                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                }
                Color(.lightGray).opacity(0.2)
                    .frame(height: 1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .padding(.vertical,4)
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        VStack {
            CustomListsCellView()
                .anyButton(.highlight) {
                    
                }
            CustomListsCellView(imageName: nil)
        }
        
    }
 }
