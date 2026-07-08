//
//  ConsoleService.swift
//  AiChat
//
//  Created by Sathya Kumar on 08/07/26.
//
import SwiftUI
import OSLog

actor LogSystem {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "ConsoleLogger")
    
    func log(level: OSLogType, message: String) {
        logger.log(level: level, "\(message)")
    }
    
    nonisolated func log(level: LogType, message: String) {
        Task {
            await log(level: level.OSLogType, message: message)
        }
    }
}

enum LogType {
    /// use Info for information taska. These are not consoloidated analytics , issues or errors
    case info
    ///   Deafult type for analytics
    case analytic
    /// Issues or errors that should not occur, but will not  negativiely affect the userexperience
    case warning
    ///  issues or errors that negatively affect user experience
    case severe

    var emoji: String {
        switch self {
        case .info:
            return "👋"
        case .analytic:
            return "📈"
        case .warning:
            return "⚠️"
        case .severe:
            return "🚨"
        }
    }

    var OSLogType: OSLogType {
        switch self {
        case .info:
            return .info
        case .analytic:
            return .default
        case .warning:
            return .error
        case .severe:
            return .fault
        }
    }
}

struct ConsoleService: LogService {
    
    let logger = LogSystem()
    private let printParameters: Bool
    
    init(printParameters: Bool = true) {
        self.printParameters = printParameters
    }
    
    func identifyUser(userid: String, name: String?, email: String?) {
        let string = """
        📈 Identify User
            userId: \(userid)
            name: \(name ?? "unknown")
            email: \(email ?? "unknown")
        """
        logger.log(level: LogType.info, message: string)
    }

    func addUserproperties(properties: [String: Any]) {
        var string = """
        📈 Log User Properties
        """
        if printParameters {
            let sortedKeys = properties.keys.sorted()
            for key in sortedKeys {
                if let value = properties[key] {
                    string += "\n (key: \(key), value: \(value))"
                }
            }
        }
        logger.log(level: LogType.info, message: string)
    }

    func deleteuserProfile() {
        let string = """
        📈Delete User Profil
        """
        print(string)
    }

    func trackEvent(event: any LoggableEvent) {
        var string = """
        Track Event: \(event.eventName)
        """
        if  printParameters, let  parameters = event.parameters {
            let sortedKeys = parameters.keys.sorted()
            for key in sortedKeys {
                if let value = parameters[key] {
                    string += "\n (key: \(key), value: \(value))"
                }
            }
        }
        logger.log(level: LogType.info, message: string)
    }

    func trackScreenEvent(event: any LoggableEvent) {
        var string = """
        Track Screen Event: \(event.type.emoji) \(event.eventName)
        """
        if printParameters, let parameters = event.parameters {
            let sortedKeys = parameters.keys.sorted()
            for key in sortedKeys {
                if let value = parameters[key] {
                    string += "\n (key: \(key), value: \(value))"
                }
            }
        }

        logger.log(level: event.type, message: string)
    }
}
