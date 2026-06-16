//
//  OnBoardingColorView.swift
//  AiChat
//
//  Created by Sathya Kumar on 16/06/26.
//

import SwiftUI

struct OnBoardingColorView: View {
    
    @State private var selectedColor: Color?
    let colors: [Color] = [.red, .green, .blue, .orange, .mint, .purple, .cyan, .teal, .indigo]
    
    var body: some View {
        ScrollView {
            colorGrid
            .padding(.horizontal, 16)
        }
        .safeAreaInset(edge: .bottom, content: {
            ZStack {
                if let selectedColor {
                   ctaButtons
                    .transition(AnyTransition.move(edge: .bottom))
                }
            }
            .padding(24)
            .background(Color(uiColor: .systemBackground))
        })
        .animation(.bouncy, value: selectedColor)
        
    }
    
    private var colorGrid: some View {
        LazyVGrid(
            columns: Array(
                repeating: GridItem(.flexible(), spacing: 16),
                count: 3
            ),
            alignment: .center,
            spacing: 16,
            pinnedViews: [.sectionHeaders],
            content: {
                Section {
                    ForEach(colors, id: \.self) { index in
                        Circle()
                            .fill(.accent)
                            .overlay(content: {
                                index
                                    .clipShape(Circle())
                                    .padding(selectedColor == index ? 10 : 0)
                            })
                            .onTapGesture {
                                selectedColor = index
                            }
                    }
                } header: {
                    Text("Select a profile Color")
                }
            }
        )
    }
    private var ctaButtons: some View{
        NavigationLink {
            OnBoardingCompletedView()
        } label: {
            Text("Continue")
                .callToFunctionButton()
        }
    }
}

#Preview {
    NavigationStack {
        OnBoardingColorView()
    }
}
