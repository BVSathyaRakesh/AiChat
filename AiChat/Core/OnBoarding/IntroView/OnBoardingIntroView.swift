//
//  OnBoardingIntroView.swift
//  AiChat
//
//  Created by Sathya Kumar on 16/06/26.
//

import SwiftUI

struct OnBoardingIntroView: View {
    var body: some View {
        
        VStack {
            Group {
                Text("Make Your own ")
                +
                Text("Avatars ")
                    .foregroundStyle(.accent)
                    .fontWeight(.semibold)
                +
                Text("and chat with them \n\nHave ")
                +
                Text("real conversations ")
                    .foregroundStyle(.accent)
                    .fontWeight(.semibold)
                +
                Text("with AI generated responses")
            }
            .baselineOffset(6)
            .frame(maxHeight: .infinity)
            .padding(24)
            
            NavigationLink {
                OnBoardingColorView()
            } label: {
                Text("Continue")
                    .callToFunctionButton()
            }
        }
        .padding(24)
        .font(.title3)
        .toolbar(.hidden, for: .navigationBar)
       
    }
}

#Preview {
    NavigationStack {
        OnBoardingIntroView()
    }
}
