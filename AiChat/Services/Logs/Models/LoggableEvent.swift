//
//  LoggableEvent.swift
//  AiChat
//
//  Created by Sathya Kumar on 08/07/26.
//

protocol LoggableEvent {
    var eventName: String {get}
    var parameters: [String: Any]? {get}
    var type: LogType {get}
}

struct AnyLoggableEvent: LoggableEvent {
    let eventName: String
    let parameters: [String: Any]?
    let type: LogType
    
    init(eventName: String, parameters: [String: Any]?, type: LogType = .analytic) {
        self.eventName = eventName
        self.parameters = parameters
        self.type = type
    }
    
}
