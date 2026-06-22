//
//  String+EXT.swift
//  AiChat
//
//  Created by Sathya Kumar on 22/06/26.
//

extension String {
    func containsAny(of substrings: [String]) -> Bool {
        substrings.contains(where: { self.lowercased().contains($0.lowercased()) })
    }
}
