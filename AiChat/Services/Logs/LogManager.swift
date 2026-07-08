//
//  LogManager.swift
//  AiChat
//
//  Created by Sathya Kumar on 08/07/26.
//

import SwiftUI

@Observable
class LogManager {

    let services: [LogService]

    init(services: [LogService] = []) {
        self.services = services
    }

    func identifyUser(userid: String, name: String?, email: String?) {
        for service in services {
            service.identifyUser(userid: userid, name: name, email: email)
        }
    }

    func addUserproperties(properties: [String: Any]) {
        for service in services {
            service.addUserproperties(properties: properties)
        }
    }

    func deleteuserProfile() {
        for service in services {
            service.deleteuserProfile()
        }
    }
    
    func trackEvent(eventName: String, parameters: [String: Any]? = nil, type: LogType = .analytic) {
        let event = AnyLoggableEvent(eventName: eventName, parameters: parameters, type: type)
        for service in services {
            service.trackEvent(event: event)
        }
    }
    
    func trackEvent(event: AnyLoggableEvent) {
        for service in services {
            service.trackEvent(event: event)
        }
    }

    func trackEvent(event: any LoggableEvent) {
        for service in services {
            service.trackEvent(event: event)
        }
    }

    func trackScreenEvent(event: any LoggableEvent) {
        for service in services {
            service.trackScreenEvent(event: event)
        }
    }
}
