//
//  LogService.swift
//  AiChat
//
//  Created by Sathya Kumar on 08/07/26.
//
import SwiftUI

protocol LogService {
    func identifyUser(userid: String, name: String?, email: String?)
    func addUserproperties(properties: [String: Any])
    func deleteuserProfile()
    
    func trackEvent(event: LoggableEvent)
    func trackScreenEvent(event: LoggableEvent)
}

protocol LoggableEvent {
    var eventName: String {get}
    var parameters: [String: Any]? {get}
    var type: LogType {get}
}
