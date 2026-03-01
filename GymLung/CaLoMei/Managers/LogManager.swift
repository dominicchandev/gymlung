//
//  LogManager.swift
//  GymLung
//
//  Manages application logs for the Dev Panel.
//

import Foundation
import Observation

struct LogEntry: Identifiable, Equatable {
    let id = UUID()
    let timestamp: Date
    let message: String

    var detailedTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS Z"
        return formatter.string(from: timestamp)
    }
}

@Observable
class LogManager {
    static let shared = LogManager()

    var logs: [LogEntry] = []

    private init() {}

    func addLog(_ message: String) {
        #if DEBUG
        let entry = LogEntry(timestamp: Date(), message: message)
        Task { @MainActor in
            logs.append(entry)
        }
        #endif
    }

    func clear() {
        logs.removeAll()
    }
}

/// Global function to log debug messages to the Dev Panel and Console.
/// Usage: debugPrint("Some message", someObject)
func debugPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    let output = items.map { "\($0)" }.joined(separator: separator)
    Swift.debugPrint(output, terminator: terminator)
    LogManager.shared.addLog(output)
    #endif
}
