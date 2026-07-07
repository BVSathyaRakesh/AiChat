//
//  DeviceInfo.swift
//  AiChat
//
//  Created by Sathya Kumar on 07/07/26.
//

import UIKit
import SwiftfulUtilities

struct DeviceInfo {

    var eventParameters: [String: Any] {
        let dict: [String: Any?] = [
            "device_model": Utilities.deviceModel,
            "device_name": Utilities.deviceName,
            "device_system_name": Utilities.systemName,
            "device_system_version": Utilities.systemVersion,
            "device_screen_width": Utilities.screenWidth,
            "device_screen_height": Utilities.screenHeight,
            "device_app_version": Utilities.appVersion,
            "device_app_build": Utilities.buildNumber
        ]
        return dict.compactMapValues({ $0 })
    }
}
