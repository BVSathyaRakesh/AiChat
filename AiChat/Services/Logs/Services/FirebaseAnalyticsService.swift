//
//  FirebaseAnalyticsService.swift
//  AiChat
//
//  Created by Sathya Kumar on 08/07/26.
//

import FirebaseAnalytics
import Foundation

struct FirebaseAnalyticsService: LogService {

    private func sanitizeEventName(_ eventName: String) -> String {
        // Firebase Analytics requires event names to only contain letters, numbers, and underscores
        // Replace spaces with underscores and remove other invalid characters
        let sanitized = eventName
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "-", with: "_")
            .lowercased()
            .filter { $0.isLetter || $0.isNumber || $0 == "_" }

        return String(sanitized.prefix(40)) // Firebase has a 40 character limit
    }

    private func sanitizeParameters(_ parameters: [String: Any]?) -> [String: Any]? {
        guard let parameters = parameters else { return nil }

        var sanitized: [String: Any] = [:]

        for (key, value) in parameters {
            // Convert Date to ISO8601 string
            if let date = value as? Date {
                sanitized[key] = ISO8601DateFormatter().string(from: date)
            }
            // Keep NSString, NSNumber, NSArray
            else if value is String || value is NSNumber || value is [Any] {
                sanitized[key] = value
            }
            // Convert Bool to NSNumber
            else if let boolValue = value as? Bool {
                sanitized[key] = NSNumber(value: boolValue)
            }
            // Convert Int/Double to NSNumber
            else if let intValue = value as? Int {
                sanitized[key] = NSNumber(value: intValue)
            } else if let doubleValue = value as? Double {
                sanitized[key] = NSNumber(value: doubleValue)
            }
            // Skip unsupported types
            else {
                print("⚠️ Skipping unsupported parameter type: \(key) = \(type(of: value))")
            }
        }

        return sanitized
    }

    func identifyUser(userid: String, name: String?, email: String?) {
        Analytics.setUserID(userid)
        if let name {
            Analytics.setUserProperty(name, forName: "account_name")
        }
        if let email {
            Analytics.setUserProperty(email, forName: "account_email")
        }
    }

    func addUserproperties(properties: [String: Any]) {
        for (key, value) in properties {
            if let stringValue = value as? String {
                Analytics.setUserProperty(stringValue, forName: key)
            }
        }
    }

    func deleteuserProfile() {
        Analytics.resetAnalyticsData()
    }

    func trackEvent(event: any LoggableEvent) {
        let sanitizedName = sanitizeEventName(event.eventName)
        let sanitizedParameters = sanitizeParameters(event.parameters)
        Analytics.logEvent(sanitizedName, parameters: sanitizedParameters)
    }

    func trackScreenEvent(event: any LoggableEvent) {
        let sanitizedName = sanitizeEventName(event.eventName)

        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: sanitizedName
        ])

        if event.parameters != nil {
            let sanitizedParameters = sanitizeParameters(event.parameters)
            Analytics.logEvent(sanitizedName, parameters: sanitizedParameters)
        }
    }
}
