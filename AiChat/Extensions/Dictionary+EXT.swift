//
//  Dictionary+EXT.swift
//  AiChat
//
//  Created by Sathya Kumar on 07/07/26.
//

import Foundation

extension Dictionary where Key == String, Value == Any {

    var asAlphabeticalArray: [(key: String, value: Any)] {
        let array: [(key: String, value: Any)] = self.map { (key: $0, value: $1) }
        return array.sortedByKeyPath(\.key)
    }
}
