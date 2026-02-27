/*
 * Live AI Intent
 * App Intent - Supports triggering Live AI via Siri and Shortcuts (runs in the background, no unlock required)
 */

import AppIntents
import UIKit

// MARK: - Live AI Intent (Background Mode)

@available(iOS 16.0, *)
struct LiveAIIntent: AppIntent {
    static var title: LocalizedStringResource = "Real-time Conversation"
    static var description = IntentDescription("Start a real-time multimodal conversation")
    // The app must be opened because iOS restricts background recording
    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        // Send a notification so the app automatically opens the Live AI interface
        NotificationCenter.default.post(name: .liveAITriggered, object: nil)
        return .result(dialog: "Starting real-time conversation...")
    }
}

// MARK: - Stop Live AI Intent

@available(iOS 16.0, *)
struct StopLiveAIIntent: AppIntent {
    static var title: LocalizedStringResource = "Stop Live Conversation"
    static var description = IntentDescription("Stop the currently running real-time conversation")
    static var openAppWhenRun: Bool = false

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let manager = LiveAIManager.shared

        if manager.isRunning {
            await manager.stopSession()
            return .result(dialog: "Live AI has stopped")
        } else {
            return .result(dialog: "Live AI is not running")
        }
    }
}

// MARK: - Notification Name

extension Notification.Name {
    static let liveAITriggered = Notification.Name("liveAITriggered")
}
