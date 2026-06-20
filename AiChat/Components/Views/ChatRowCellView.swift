//
//  ChatRowCellView.swift
//  AiChat
//
//  Created by Sathya Kumar on 19/06/26.
//

import SwiftUI

struct ChatRowCellView: View {
    
    var imageName: String? = Constants.randomImage
    var title: String? = "Alpha"
    var subTitle: String? = "An ALien that walks into the Park!"
    var hasNewChat: Bool = true
    
    var body: some View {
        VStack {
            HStack(spacing: 8) {
                if let imageName {
                    ImageLoaderView(urlString: imageName)
                        .aspectRatio(1, contentMode: .fit)
                        .frame(height: 50)
                        .clipShape(.circle)
                } else {
                    Rectangle()
                        .fill(.gray)
                        .aspectRatio(1, contentMode: .fit)
                        .frame(height: 50)
                        .clipShape(.circle)
                }
                VStack(alignment: .leading, spacing: 4) {
                    if let title {
                        Text(title)
                            .foregroundStyle(.primary)
                    }
                    if let subTitle {
                        Text(subTitle)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                if hasNewChat {
                        Text("NEW")
                        .badgeButton()
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(uiColor: .systemBackground))
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        List {
            ChatRowCellView()
                .removeListRowFormatting()
            ChatRowCellView(hasNewChat: false)
                .removeListRowFormatting()
            ChatRowCellView(imageName: nil, subTitle: nil)
                .removeListRowFormatting()
            ChatRowCellView(title: nil, hasNewChat: false)
                .removeListRowFormatting()
        }
    }
}
