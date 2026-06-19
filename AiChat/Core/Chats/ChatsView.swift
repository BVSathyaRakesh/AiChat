//
//  ChatsView.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import SwiftUI

struct ChatsView: View {
    
    @State var chats: [ChatModal] = ChatModal.mocks
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(chats) { chat in
                    HStack {
                        ImageLoaderView(urlString: Constants.randomImage)
                            .aspectRatio(1, contentMode: .fit)
                            .frame(height: 70)
                        VStack {
                            Text(chat.id)
                        }
                    }
                }
            }
            .navigationTitle("Chats")
        }
    }
}

#Preview {
    ChatsView()
}
