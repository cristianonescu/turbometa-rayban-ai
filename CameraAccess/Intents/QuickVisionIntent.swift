/*
 * Quick Vision Intent
 * App Intent - Supports triggering Quick Vision via Siri and Shortcuts
 *
 * Supported modes:
 * - Default mode: General image description
 * - Health mode: Analyze how healthy food is
 * - Blind mode: Describe the environment for visually impaired users
 * - Reading mode: Recognize and read text aloud
 * - Translation mode: Recognize and translate text
 * - Encyclopedia mode: Provide encyclopedic knowledge
 * - Custom: Use a custom prompt
 */

import AppIntents
import UIKit
import SwiftUI

// MARK: - Quick Vision Intent (Default Mode)

@available(iOS 16.0, *)
struct QuickVisionIntent: AppIntent {
    static var title: LocalizedStringResource = "Quick Vision"
    static var description = IntentDescription("Use Ray-Ban Meta glasses to take a photo and recognize the image content")
    static var openAppWhenRun: Bool = false

    @Parameter(title: "Custom prompt")
    var customPrompt: String?

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let manager = QuickVisionManager.shared
        await manager.performQuickVisionWithMode(.standard, customPrompt: customPrompt)
        return formatResult(manager)
    }
}

// MARK: - Health Mode Intent

@available(iOS 16.0, *)
struct QuickVisionHealthIntent: AppIntent {
    static var title: LocalizedStringResource = "Health Vision"
    static var description = IntentDescription("Analyze how healthy food/drinks are")
    static var openAppWhenRun: Bool = false

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let manager = QuickVisionManager.shared
        await manager.performQuickVisionWithMode(.health)
        return formatResult(manager)
    }
}

// MARK: - Blind Mode Intent

@available(iOS 16.0, *)
struct QuickVisionBlindIntent: AppIntent {
    static var title: LocalizedStringResource = "Environment description"
    static var description = IntentDescription("Describe the surroundings in detail for visually impaired users")
    static var openAppWhenRun: Bool = false

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let manager = QuickVisionManager.shared
        await manager.performQuickVisionWithMode(.blind)
        return formatResult(manager)
    }
}

// MARK: - Reading Mode Intent

@available(iOS 16.0, *)
struct QuickVisionReadingIntent: AppIntent {
    static var title: LocalizedStringResource = "Read text"
    static var description = IntentDescription("Recognize and read aloud the text in an image")
    static var openAppWhenRun: Bool = false

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let manager = QuickVisionManager.shared
        await manager.performQuickVisionWithMode(.reading)
        return formatResult(manager)
    }
}

// MARK: - Translation Mode Intent

@available(iOS 16.0, *)
struct QuickVisionTranslateIntent: AppIntent {
    static var title: LocalizedStringResource = "Translate text"
    static var description = IntentDescription("Recognize and translate foreign text in an image")
    static var openAppWhenRun: Bool = false

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let manager = QuickVisionManager.shared
        await manager.performQuickVisionWithMode(.translate)
        return formatResult(manager)
    }
}

// MARK: - Encyclopedia Mode Intent

@available(iOS 16.0, *)
struct QuickVisionEncyclopediaIntent: AppIntent {
    static var title: LocalizedStringResource = "Encyclopedic recognition"
    static var description = IntentDescription("Recognize objects and provide encyclopedic information")
    static var openAppWhenRun: Bool = false

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let manager = QuickVisionManager.shared
        await manager.performQuickVisionWithMode(.encyclopedia)
        return formatResult(manager)
    }
}

// MARK: - Helper Function

@available(iOS 16.0, *)
@MainActor
private func formatResult(_ manager: QuickVisionManager) -> some IntentResult & ProvidesDialog {
    if let result = manager.lastResult {
        return .result(dialog: "Recognition complete: \(result)")
    } else if let error = manager.errorMessage {
        return .result(dialog: "Recognition failed: \(error)")
    } else {
        return .result(dialog: "Recognition complete")
    }
}

// MARK: - App Shortcuts Provider

@available(iOS 16.0, *)
struct TurboMetaShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        // Default vision
        AppShortcut(
            intent: QuickVisionIntent(),
            phrases: [
                "Use \(.applicationName) to recognize",
                "Use \(.applicationName) to see what this is",
                "\(.applicationName) Quick Vision",
                "\(.applicationName) capture and recognize"
            ],
            shortTitle: "Quick Vision",
            systemImageName: "eye.circle.fill"
        )

        // Health vision
        AppShortcut(
            intent: QuickVisionHealthIntent(),
            phrases: [
                "Use \(.applicationName) to analyze health",
                "\(.applicationName) Health Vision",
                "\(.applicationName) Is this food healthy"
            ],
            shortTitle: "Health Vision",
            systemImageName: "heart.circle.fill"
        )

        // Blind mode
        AppShortcut(
            intent: QuickVisionBlindIntent(),
            phrases: [
                "Use \(.applicationName) to describe the environment",
                "\(.applicationName) See what's around",
                "\(.applicationName) Help me see ahead"
            ],
            shortTitle: "Environment description",
            systemImageName: "figure.walk.circle.fill"
        )

        // Reading mode
        AppShortcut(
            intent: QuickVisionReadingIntent(),
            phrases: [
                "Use \(.applicationName) to read text",
                "\(.applicationName) Read this",
                "\(.applicationName) Help me read the text"
            ],
            shortTitle: "Read text",
            systemImageName: "text.viewfinder"
        )

        // Translation mode
        AppShortcut(
            intent: QuickVisionTranslateIntent(),
            phrases: [
                "Use \(.applicationName) to translate",
                "\(.applicationName) Translate this",
                "\(.applicationName) What does this mean"
            ],
            shortTitle: "Translate text",
            systemImageName: "character.bubble.fill"
        )

        // Encyclopedia mode
        AppShortcut(
            intent: QuickVisionEncyclopediaIntent(),
            phrases: [
                "Use \(.applicationName) to introduce this",
                "\(.applicationName) Encyclopedic recognition",
                "\(.applicationName) What is this thing"
            ],
            shortTitle: "Encyclopedic recognition",
            systemImageName: "books.vertical.circle.fill"
        )

        // Real-time conversation
        AppShortcut(
            intent: LiveAIIntent(),
            phrases: [
                "Use \(.applicationName) for real-time conversation",
                "\(.applicationName) real-time conversation",
                "Start \(.applicationName) real-time conversation",
                "\(.applicationName) start conversation"
            ],
            shortTitle: "Real-time conversation",
            systemImageName: "brain.head.profile"
        )

        // Stop Live Conversation
        AppShortcut(
            intent: StopLiveAIIntent(),
            phrases: [
                "\(.applicationName) Stop Live Conversation",
                "Stop the live chat \(.applicationName)",
                "End the chazt\(.applicationName)"
            ],
            shortTitle: "Stop Live Conversation",
            systemImageName: "stop.circle.fill"
        )
    }
}

// MARK: - Notification Name

extension Notification.Name {
    static let quickVisionTriggered = Notification.Name("quickVisionTriggered")
}

// MARK: - Quick Vision Manager

@MainActor
class QuickVisionManager: ObservableObject {
    static let shared = QuickVisionManager()

    @Published var isProcessing = false
    @Published var lastResult: String?
    @Published var errorMessage: String?
    @Published var lastImage: UIImage?
    @Published var lastMode: QuickVisionMode = .standard

    // Expose streamViewModel so Intents can check initialization state
    private(set) var streamViewModel: StreamSessionViewModel?
    private let tts = TTSService.shared

    private init() {
        // Listen for Intent triggers
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleQuickVisionTrigger(_:)),
            name: .quickVisionTriggered,
            object: nil
        )
    }

    /// Set the StreamSessionViewModel reference
    func setStreamViewModel(_ viewModel: StreamSessionViewModel) {
        self.streamViewModel = viewModel
    }

    @objc private func handleQuickVisionTrigger(_ notification: Notification) {
        let customPrompt = notification.userInfo?["customPrompt"] as? String
        let modeString = notification.userInfo?["mode"] as? String
        let mode = modeString.flatMap { QuickVisionMode(rawValue: $0) } ?? .standard

        Task { @MainActor in
            await performQuickVisionWithMode(mode, customPrompt: customPrompt)
        }
    }

    /// Perform Quick Vision with the specified mode
    func performQuickVisionWithMode(_ mode: QuickVisionMode, customPrompt: String? = nil) async {
        guard !isProcessing else {
            print("⚠️ [QuickVision] Already processing")
            return
        }

        guard let streamViewModel = streamViewModel else {
            print("❌ [QuickVision] StreamViewModel not set")
            tts.speak("The vision feature is not initialized, please open the app first")
            return
        }

        isProcessing = true
        errorMessage = nil
        lastResult = nil
        lastImage = nil
        lastMode = mode

        // Get API Key
        guard let apiKey = APIKeyManager.shared.getAPIKey(), !apiKey.isEmpty else {
            errorMessage = "Please configure the API Key in Settings first"
            tts.speak("Please configure the API Key in Settings first")
            isProcessing = false
            return
        }

        // Announce start
        try? await Task.sleep(for: .seconds(5))
        tts.speak("Analizez imaginea, te rog asteapta. Acest proces dureaza cateva secunde.", apiKey: apiKey)

        // Get prompt
        let prompt = customPrompt ?? QuickVisionModeManager.shared.getPrompt(for: mode)

        do {
            // 0. Check if a device is connected
            if !streamViewModel.hasActiveDevice {
                print("❌ [QuickVision] No active device connected")
                throw QuickVisionError.noDevice
            }

            // 1. Start video stream (if not started)
            if streamViewModel.streamingStatus != .streaming {
                print("📹 [QuickVision] Starting stream...")
                await streamViewModel.handleStartStreaming()

                // Wait for streaming state (up to 5 seconds)
                var streamWait = 0
                while streamViewModel.streamingStatus != .streaming && streamWait < 50 {
                    try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
                    streamWait += 1
                }

                if streamViewModel.streamingStatus != .streaming {
                    print("❌ [QuickVision] Failed to start streaming")
                    throw QuickVisionError.streamNotReady
                }
            }

            // 2. Wait for stream to stabilize
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds

            // 3. Clear previous photo, then capture a new one
            streamViewModel.dismissPhotoPreview()
            print("📸 [QuickVision] Capturing photo...")
            streamViewModel.capturePhoto()

            // 4. Wait for photo capture to finish (up to 3 seconds)
            var photoWait = 0
            while streamViewModel.capturedPhoto == nil && photoWait < 30 {
                try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
                photoWait += 1
            }

            // If SDK capturePhoto fails, fall back to current video frame
            let photo: UIImage
            if let capturedPhoto = streamViewModel.capturedPhoto {
                photo = capturedPhoto
                print("📸 [QuickVision] Using SDK captured photo")
            } else if let videoFrame = streamViewModel.currentVideoFrame {
                photo = videoFrame
                print("📸 [QuickVision] SDK capturePhoto failed, using video frame as fallback")
            } else {
                print("❌ [QuickVision] No photo or video frame available")
                throw QuickVisionError.frameTimeout
            }

            print("📸 [QuickVision] Photo captured: \(photo.size.width)x\(photo.size.height)")

            // Save image for history
            lastImage = photo

            // 5. Preconfigure TTS audio session
            tts.prepareAudioSession()

            // 6. Stop stream immediately
            print("🛑 [QuickVision] Stopping stream after capture")
            await streamViewModel.stopSession()

            // 7. Call image recognition API
            let service = QuickVisionService(apiKey: apiKey)
            let result = try await service.analyzeImage(photo, customPrompt: prompt)

            // 8. Save result
            lastResult = result

            // 9. Save to history
            saveToHistory(mode: mode, prompt: prompt, result: result, image: photo)

            // 10. TTS speak result
            tts.speak(result, apiKey: apiKey)

            print("✅ [QuickVision] Complete: \(result)")

        } catch let error as QuickVisionError {
            errorMessage = error.localizedDescription
            print("❌ [QuickVision] QuickVisionError: \(error)")
            tts.speak(error.localizedDescription, apiKey: apiKey)
            await streamViewModel.stopSession()
        } catch {
            errorMessage = error.localizedDescription
            print("❌ [QuickVision] Error: \(error)")
            tts.speak("Recognition failed, \(error.localizedDescription)", apiKey: apiKey)
            await streamViewModel.stopSession()
        }

        isProcessing = false
    }

    /// Perform Quick Vision (using the current mode)
    func performQuickVision(customPrompt: String? = nil) async {
        await performQuickVisionWithMode(QuickVisionModeManager.staticCurrentMode, customPrompt: customPrompt)
    }

    /// Perform Quick Vision (triggered from Shortcuts/Siri)
    func performQuickVisionFromIntent(customPrompt: String? = nil) async {
        await performQuickVision(customPrompt: customPrompt)
    }

    /// Save recognition result to history
    private func saveToHistory(mode: QuickVisionMode, prompt: String, result: String, image: UIImage) {
        let record = QuickVisionRecord(
            mode: mode,
            prompt: prompt,
            result: result,
            thumbnail: image
        )
        QuickVisionStorage.shared.saveRecord(record)
        print("💾 [QuickVision] Record saved to history")
    }

    /// Stop video stream (called when page is closed)
    func stopStream() async {
        await streamViewModel?.stopSession()
    }

    /// Manually trigger Quick Vision (from UI)
    func triggerQuickVision(customPrompt: String? = nil) {
        Task { @MainActor in
            await performQuickVision(customPrompt: customPrompt)
        }
    }

    /// Manually trigger Quick Vision with a specific mode (from UI)
    func triggerQuickVisionWithMode(_ mode: QuickVisionMode) {
        Task { @MainActor in
            await performQuickVisionWithMode(mode)
        }
    }
}
