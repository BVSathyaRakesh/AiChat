//
//  Utilities.swift
//  AiChat
//
//  Created by Sathya Kumar on 20/06/26.
//

import SwiftfulUtilities
import UIKit

typealias Utilities = SwiftfulUtilities.Utilities

extension Utilities {

    static var deviceModel: String {
        UIDevice.current.model
    }

    static var deviceName: String {
        UIDevice.current.name
    }

    static var systemName: String {
        UIDevice.current.systemName
    }

    static var systemVersion: String {
        UIDevice.current.systemVersion
    }

    static var screenWidth: Double {
        UIScreen.main.bounds.width
    }

    static var screenHeight: Double {
        UIScreen.main.bounds.height
    }
}
