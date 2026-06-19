//
//  ButtonViewModifiers.swift
//  AiChat
//
//  Created by Sathya Kumar on 19/06/26.
//

import SwiftUI

struct HighlightButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay {
                configuration.isPressed ? Color.accent.opacity(0.4) : Color.accent.opacity(0)
            }
            .animation(.smooth, value: configuration.isPressed)
    }
}

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay {
                configuration.isPressed ? Color.accent.opacity(0.4) : Color.accent.opacity(0)
            }
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.smooth, value: configuration.isPressed)
    }
}

enum ButtonStyleOption {
    case highlight, pressable, plain
}

extension View {
    
    @ViewBuilder
    func anyButton(_ option: ButtonStyleOption = .plain, action: @escaping () -> Void) -> some View {
        switch option {
        case .highlight:
            self.highlightedButton(action: action)
        case .pressable:
            self.pressableButton(action: action)
        case .plain:
            self.plainButton(action: action)
        }
    }
    
    private func plainButton(action: @escaping () -> Void) -> some View {
         Button {
             action()
         } label: {
             self
         }
         .buttonStyle(PlainButtonStyle())
     }
   private func highlightedButton(action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            self
        }
        .buttonStyle(HighlightButtonStyle())
    }
    
   private func pressableButton(action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            self
        }
        .buttonStyle(PressableButtonStyle())
    }
}

#Preview {
    VStack {
        Text("Hello World")
            .padding()
            .frame(maxWidth: .infinity)
            .anyButton(.highlight, action: {
                
            })
            .padding()
        Text("Hello World")
            .callToFunctionButton()
            .anyButton(.pressable, action: {
                
            })
            .padding()
        
        Text("Hello")
            .callToFunctionButton()
            .anyButton(action: {
                
            })
            .padding()
    }
}
