//
//  ContentView.swift
//  GroupExploration
//
//  Created by Cristian Díaz on 25.11.25.
//

import SwiftUI
import RealityKit
import GroupActivities

/**
 * ContentView - Main UI with SharePlay Integration
 *
 * This view provides the primary user interface for the SharePlay-enabled GroupExploration app.
 * It combines the immersive space toggle with SharePlay controls and handles automatic
 * detection of incoming SharePlay invitations.
 *
 * Key Features:
 * - Immersive space toggle for 2D ↔ immersive transitions
 * - SharePlay controls for starting new sessions
 * - Automatic monitoring for incoming SharePlay invitations
 * - Session management UI state feedback
 *
 * Architecture:
 * - @MainActor for UI thread operations
 * - SwiftUI NavigationStack for organized navigation
 * - Task-based async session monitoring
 *
 * Reference: Go beyond the window with SwiftUI - WWDC 2023 Session 10111
 * https://developer.apple.com/videos/play/wwdc2023/10111
 */
struct ContentView: View {
    @Environment(AppModel.self) private var appModel

    /// Task for monitoring SharePlay sessions
    /// Used to manage the lifecycle of session observation
    @State private var sessionTask = Task<Void, Never> {}

    var body: some View {
        NavigationStack {
            ZStack {
                // Toggle button for immersive space transition
                // Located in center of view for easy access
                ToggleImmersiveSpaceButton()
            }
            .navigationTitle("Group Exploration")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    SharePlayShareButton()
                }
            }
            // Start monitoring for incoming SharePlay sessions when view appears
            .task { await observeGroupSessions() }
        }
    }

    /**
     * Monitors for new GroupExplorationActivity SharePlay sessions
     *
     * This function establishes continuous monitoring for incoming SharePlay invitations
     * and automatically configures the SharePlayManager when a session is detected.
     *
     * Monitoring Process:
     * 1. Uses GroupExplorationActivity.sessions() async sequence
     * 2. Continuously iterates over incoming sessions
     * 3. Configures SharePlayManager for each detected session
     * 4. Handles automatic session joining for invitations
     *
     * Session Detection:
     * - Triggered when user receives SharePlay invitation via FaceTime
     * - Async sequence provides real-time session availability
     * - Automatic configuration enables seamless user experience
     *
     * Task Management:
     * - Stored in sessionTask for lifecycle management
     * - @MainActor ensures UI updates occur on main thread
     * - Task can be cancelled to stop monitoring
     *
     * Implementation Pattern:
     * Based on GroupActivities session monitoring best practices
     *
     * Reference: Make a great SharePlay experience - WWDC 2022 Session 10139
     * https://developer.apple.com/videos/play/wwdc2022/10139
     */
    @Sendable
    private func observeGroupSessions() async {
        sessionTask = Task { @MainActor in
            // Continuously monitor for incoming SharePlay sessions
            // GroupExplorationActivity.sessions() provides async sequence of available sessions
            for await session in GroupExplorationActivity.sessions() {
                print("Detected incoming SharePlay session, configuring...")

                // Configure SharePlayManager to handle the detected session
                // This sets up spatial coordination and joins the session
                await appModel.sharePlayManager.configureForSession(session)
            }
        }
    }
}

// MARK: - SharePlay Share Button

/**
 * SharePlayShareButton - SharePlay Session Controls
 *
 * Provides a simple button interface for starting new SharePlay sessions.
 * The button initiates the SharePlay activation process through the SharePlayManager.
 *
 * User Experience:
 * - Single tap starts SharePlay session
 * - System presents native SharePlay invitation interface
 * - User can invite participants via FaceTime
 * - Error handling provides feedback for failures
 *
 * Integration:
 * - Uses SharePlayManager for session management
 * - Handles async activation within synchronous context
 * - Provides error logging for debugging
 *
 * State Management:
 * - Button state indicates SharePlay availability
 * - Error handling prevents crashes during activation
 * - Clean separation of concerns with SharePlayManager
 *
 * Reference: Add SharePlay to your app - WWDC 2023 Session 10239
 * https://developer.apple.com/videos/play/wwdc2023/10239
 */
struct SharePlayShareButton: View {
    @Environment(AppModel.self) private var appModel

    var body: some View {
        Button("SharePlay") {
            // Start SharePlay session in async context
            // Task wrapper handles async activation within synchronous button action
            Task {
                do {
                    // Delegate to SharePlayManager for session activation
                    try await appModel.sharePlayManager.startSharePlay()
                } catch {
                    // Log error for debugging while maintaining UI stability
                    print("Failed to start SharePlay: \(error)")

                    // In production, consider showing user-facing error message
                    // For now, print to console for development debugging
                }
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
