//
//  ChatBubbleView.swift
//  AiChat
//
//  Created by Sathya Kumar on 22/06/26.
//

import SwiftUI

struct ChatBubbleView: View {
    
    var text: String = "This is Sample Text"
    var textColor: Color = .primary
    var backgroundColor: Color = Color(uiColor: .systemGray6)
    var showImage: Bool = true
    var imageName: String? = Constants.randomImage
    let offset: CGFloat = 14
    
    var action: (() -> Void)?
    
    var body: some View {
        HStack {
            if showImage {
                ZStack {
                    if let imageName {
                        ImageLoaderView(urlString: imageName)
                            .aspectRatio(contentMode: .fit)
                            .anyButton {
                                action?()
                            }
                    } else {
                        Circle()
                            .fill(.gray)
                    }
                }
                .frame(width: 50, height: 50)
                .clipShape(.circle)
                .offset(y: offset)
            }
            Text(text)
                .padding(.vertical, 12)
                .padding(.horizontal, 8)
                .background(backgroundColor)
                .foregroundStyle(textColor)
                .cornerRadius(10)
        }
        .padding(.bottom, showImage ? offset : 0)
    }
}

#Preview {
    ScrollView {
        ChatBubbleView()
        ChatBubbleView(imageName: nil)
        ChatBubbleView(textColor: .white, backgroundColor: .accent, showImage: false)
        ChatBubbleView(text: "vjnvjbnmbn bcvnmbnmbnbmbvcb bvcnmbncmbnm bmvmcnmbnmvnbm bvcnbmnmnbm bmvncmbncb bnvmcnbmncb bmvmbmnbmn bmvnb,, dghgfhfg fdsfhdsfhf fdhsfhdsbfhbfbh", textColor: .white, backgroundColor: .accent, showImage: false)
        ChatBubbleView()
    }
}
