//
//  Binding+EXT.swift
//  AiChat
//
//  Created by Sathya Kumar on 22/06/26.
//
import SwiftUI

extension Binding  where Value == Bool {
    init<T: Sendable>(ifNotNil value: Binding<T?>) {
        self.init {
            value.wrappedValue != nil
        } set: { newValue in
            if !newValue {
                value.wrappedValue = nil
            }
        }
    }
}
