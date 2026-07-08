//
//  LogManager.swift
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
}

struct ConsoleService: LogService {
    func identifyUser(userid: String, name: String?, email: String?) {
        let string = """
        Identify User
            userId: \(userid)
            name: \(name ?? "unknown")
            email: \(email ?? "unknown")
        """
        print(string)
    }

    func addUserproperties(properties: [String: Any]) {
        var string = """
        Log User Properties
        """

        let sortedKeys = properties.keys.sorted()
        for key in sortedKeys {
            if let value = properties[key] {
                string += "\n (key: \(key), value: \(value))"
            }
        }

        print(string)
    }

    func deleteuserProfile() {
        let string = """
                "Delete User Profile"
        """
        print(string)
    }

    func trackEvent(event: any LoggableEvent) {
        var string = """
        Track Event: \(event.eventName)
        """

        if let parameters = event.parameters {
            let sortedKeys = parameters.keys.sorted()
            for key in sortedKeys {
                if let value = parameters[key] {
                    string += "\n (key: \(key), value: \(value))"
                }
            }
        }

        print(string)
    }

    func trackScreenEvent(event: any LoggableEvent) {
        var string = """
        Track Screen Event: \(event.eventName)
        """

        if let parameters = event.parameters {
            let sortedKeys = parameters.keys.sorted()
            for key in sortedKeys {
                if let value = parameters[key] {
                    string += "\n (key: \(key), value: \(value))"
                }
            }
        }

        print(string)
    }
}

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
