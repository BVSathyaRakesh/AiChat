//
//  FileManager+EXT.swift
//  AiChat
//
//  Created by Sathya Kumar on 25/06/26.
//

import Foundation

extension FileManager {

    /// Base directory for storing documents
    private var documentsDirectory: URL {
        urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    /// Builds a file URL from a key
    /// - Parameter key: The key for the file
    /// - Returns: URL for the file with .txt extension
    private func fileURL(forKey key: String) -> URL {
        documentsDirectory.appendingPathComponent("\(key).txt")
    }

    /// Saves a Codable model as a .txt document
    /// - Parameters:
    ///   - key: The key/filename for the document
    ///   - value: The Codable model to save
    /// - Throws: FileManagerError if save fails
    func saveDocument<T: Codable>(key: String, value: T) throws {
        let url = fileURL(forKey: key)

        do {
            let data = try JSONEncoder().encode(value)
            try data.write(to: url, options: .atomic)
        } catch {
            throw FileManagerError.writeDataFailed
        }
    }

    /// Gets a Codable model from a .txt document
    /// - Parameter key: The key/filename for the document
    /// - Returns: The decoded Codable model
    /// - Throws: FileManagerError if reading or decoding fails
    func getDocument<T: Codable>(key: String) throws -> T {
        let url = fileURL(forKey: key)

        guard fileExists(atPath: url.path) else {
            throw FileManagerError.fileNotFound
        }

        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw FileManagerError.readDataFailed
        }
    }
}

enum FileManagerError: LocalizedError {
    case fileNotFound
    case writeDataFailed
    case readDataFailed
    case deleteFailed

    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "No data found for the specified key"
        case .writeDataFailed:
            return "Failed to save data"
        case .readDataFailed:
            return "Failed to read data"
        case .deleteFailed:
            return "Failed to delete data"
        }
    }
}
