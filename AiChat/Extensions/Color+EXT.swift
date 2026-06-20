//
//  Color+EXT.swift
//  AiChat
//
//  Created by Sathya Kumar on 20/06/26.
//

import SwiftUI
import UIKit

extension Color {
    /// Initialize Color from hex string (supports "#RRGGBB" or "RRGGBB" format)
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        guard hexSanitized.count == 6 else {
            return nil
        }

        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }

    /// Convert Color to hex string (returns "#RRGGBB" format)
    func toHex() -> String? {
        guard let components = UIColor(self).cgColor.components else {
            return nil
        }

        let red = components[0]
        let green = components[1]
        let blue = components[2]

        let hexString = String(
            format: "#%02X%02X%02X",
            Int(red * 255),
            Int(green * 255),
            Int(blue * 255)
        )

        return hexString
    }
}
