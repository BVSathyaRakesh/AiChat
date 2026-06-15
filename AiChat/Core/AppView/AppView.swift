//
//  AppView.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import SwiftUI

struct AppView: View {
    
    @State private var showTabBar = false
    
    var body: some View {
        AppViewBuilder(
            showTabBar: showTabBar,
            tabbarView: {
                ZStack {
                    Color.red.ignoresSafeArea()
                    Text("TabBar")
                }
            },
            onBoardingView: {
                ZStack {
                    Color.blue.ignoresSafeArea()
                    Text("OnBoarding")
                }
            }
        )
        .onTapGesture {
            showTabBar.toggle()
        }
    }
}

#Preview {
    @Previewable @State var showTabBar: Bool = true
    AppView()
}
#Preview {
    @Previewable @State var showTabBar: Bool = false
    AppView(showTabBar)
}
