//
//  SharePlayManager.swift
//  GroupExploration
//
//  Created by Cristian Díaz on 25.11.25.
//

import GroupActivities
import SwiftUI

/**
 * SharePlayManager - Session Management and Spatial Coordination
 *
 * This class manages SharePlay sessions and configures spatial templates for immersive experiences.
 * It provides the core functionality for establishing group sessions with spatial persona support
 * in visionOS 26.
 *
 * Key Responsibilities:
 * - Starting new SharePlay sessions via activity activation
 * - Configuring SystemCoordinator for spatial participant arrangement
 * - Managing session lifecycle (join/leave)
 * - Tracking connection state for UI updates
 *
 * Architecture Pattern:
 * - @MainActor ensures all operations occur on the main thread
 * - @Observable enables SwiftUI state management
 * - Async/await for modern concurrency
 *
 * Reference: Build spatial SharePlay experiences - WWDC 2023 Session 10087
 * https://developer.apple.com/videos/play/wwdc2023/10087
 */
@MainActor
@Observable
class SharePlayManager {

    // MARK: - Properties

    /// Currently active SharePlay session
    /// nil when no session is active, contains GroupSession when connected
    var groupSession: GroupSession<GroupExplorationActivity>?

    /// Connection state tracking
    /// true when SharePlay session is active and configured
    var isConnected = false

    // MARK: - Session Management

    /**
     * Starts a new SharePlay session by activating the GroupExplorationActivity
     *
     * Process Flow:
     * 1. Create new GroupExplorationActivity instance
     * 2. Call activity.activate() to start SharePlay session
     * 3. System presents SharePlay sheet for participant invitations
     * 4. Returns activation result indicating session establishment
     *
     * Activation Details:
     * - Displays native SharePlay invitation interface
     * - Allows user to invite participants via FaceTime
     * - Returns true when session is successfully established
     * - Throws GroupActivityError for various failure scenarios
     *
     * Error Handling:
     * - .notAvailable: SharePlay not available on device
     * - .invalidConfiguration: Missing entitlements or configuration
     * - User cancellation or network issues
     *
     * Reference: Add SharePlay to your app - WWDC 2023 Session 10239
     * https://developer.apple.com/videos/play/wwdc2023/10239
     */
    func startSharePlay() async throws {
        let activity = GroupExplorationActivity()

        print("Attempting to activate SharePlay activity...")

        // Activate the SharePlay activity
        // This presents the native SharePlay interface for inviting participants
        isConnected = try await activity.activate()
        print("SharePlay session activated successfully")
    }

    /**
     * Configures a SharePlay session for spatial coordination
     *
     * This method is called when joining either a new session (after activation)
     * or an existing session (when receiving an invitation). It sets up the
     * SystemCoordinator to manage spatial participant arrangement.
     *
     * Configuration Steps:
     * 1. Store the GroupSession reference for future operations
     * 2. Access SystemCoordinator if available for spatial configuration
     * 3. Configure spatial template preferences
     * 4. Enable group immersive space support
     * 5. Join the session to establish connection
     *
     * Spatial Configuration:
     * - spatialTemplatePreference: Determines participant positioning
     * - supportsGroupImmersiveSpace: Enables immersive space transitions
     * - contentExtent: Distance from center to spatial template edge
     *
     * Template Options (.sideBySide):
     * - Participants face the shared content side by side
     * - Optimal for collaborative exploration activities
     * - Natural for shared immersive experiences
     *
     * Reference: Customize spatial Persona templates in SharePlay - WWDC 2024 Session 10201
     * https://developer.apple.com/videos/play/wwdc2024/10201
     *
     * @param session The GroupSession to configure and join
     */
    func configureForSession(_ session: GroupSession<GroupExplorationActivity>) async {
        // Store session reference for future operations
        self.groupSession = session

        // Configure spatial coordination if SystemCoordinator is available
        // SystemCoordinator manages spatial behavior and participant arrangement
        if let coordinator = await session.systemCoordinator {
            var config = SystemCoordinator.Configuration()

            // Configure spatial template for participant positioning
            // .sideBySide places participants facing shared content side by side
            config.spatialTemplatePreference = .sideBySide.contentExtent(200)

            // Enable support for group immersive space transitions
            // Allows all participants to enter/exit immersive space together
            config.supportsGroupImmersiveSpace = true

            // Apply the configuration to the coordinator
            coordinator.configuration = config

            print("Spatial coordinator configured with sideBySide template")
        }

        // Join the session to establish connection
        // This makes the local participant visible to others
        session.join()

        // Update connection state
        isConnected = true

        print("Successfully configured and joined SharePlay session")
    }

    /**
     * Leaves the current SharePlay session and cleans up resources
     *
     * Process:
     * 1. Leave the current session (notifies other participants)
     * 2. Clear session reference to prevent further operations
     * 3. Update connection state for UI updates
     *
     * Session Lifecycle:
     * - Local participant appears to leave for other users
     * - Session may continue if other participants remain
     * - App returns to non-shared state
     *
     * Safety:
     * - Safe to call multiple times (idempotent)
     * - Handles nil session gracefully
     * - Properly cleans up state references
     */
    func leaveSession() {
        guard let session = groupSession else {
            print("No active session to leave")
            return
        }

        print("Leaving SharePlay session...")

        // Leave the session (notifies other participants)
        session.leave()

        // Clear session reference
        self.groupSession = nil

        // Update connection state
        isConnected = false

        print("Successfully left SharePlay session")
    }
}
