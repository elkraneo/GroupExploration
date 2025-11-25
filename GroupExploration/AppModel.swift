//
//  AppModel.swift
//  GroupExploration
//
//  Created by Cristian Díaz on 25.11.25.
//

import SwiftUI

/**
 * AppModel - Application-Wide State Management
 *
 * This class maintains the core state for the GroupExploration application,
 * managing both immersive space state and SharePlay integration.
 * It serves as the central state hub for the multi-scene application.
 *
 * Key Responsibilities:
 * - Immersive space state tracking and transitions
 * - SharePlay session integration and management
 * - Cross-component state synchronization
 *
 * Architecture Pattern:
 * - @MainActor ensures all state updates occur on the main thread
 * - @Observable enables SwiftUI state management and UI reactivity
 * - Centralized state management for consistency across scenes
 *
 * State Management:
 * - Tracks immersive space lifecycle (closed → inTransition → open)
 * - Provides SharePlayManager for session coordination
 * - Coordinates state changes between different app components
 *
 * Reference: SwiftUI State Management and VisionOS App Architecture
 * https://developer.apple.com/documentation/swiftui/observable
 */
@MainActor
@Observable
class AppModel {

    // MARK: - Immersive Space Configuration

    /// Unique identifier for the immersive space scene
    /// Used by ImmersiveSpace scene definition and navigation
    /// Must match the ID used in GroupExplorationApp body
    let immersiveSpaceID = "ImmersiveSpace"

    /**
     * ImmersiveSpaceState - Immersive Space Lifecycle Management
     *
     * Enum representing the current state of the immersive space scene.
     * Provides finite state machine for managing immersive space transitions.
     *
     * State Flow:
     * - closed → inTransition → open (opening sequence)
     * - open → inTransition → closed (closing sequence)
     *
     * State Descriptions:
     * - closed: Immersive space is not active, window mode only
     * - inTransition: Space is transitioning between states
     * - open: Immersive space is active and visible
     *
     * Usage:
     * - UI state feedback for space transitions
     * - Preventing concurrent space operations
     * - Managing resource lifecycle for immersive content
     *
     * Reference: Go beyond the window with SwiftUI - WWDC 2023 Session 10111
     * https://developer.apple.com/videos/play/wwdc2023/10111
     */
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }

    /// Current state of the immersive space scene
    /// Managed by various app components during space transitions
    /// Initial state is closed, transitions occur via user actions
    var immersiveSpaceState = ImmersiveSpaceState.closed

    // MARK: - SharePlay Integration

    /**
     * SharePlayManager - Session Management Instance
     *
     * Provides SharePlay session management and spatial coordination
     * capabilities for the application. This is the central point for
     * all SharePlay functionality across the application.
     *
     * Integration Points:
     * - ContentView: SharePlay controls and session monitoring
     * - ImmersiveView: Shared spatial content coordination
     * - GroupExplorationApp: Scene association for invitations
     *
     * Lifecycle:
     * - Created when AppModel is initialized
     * - Manages SharePlay session throughout app lifecycle
     * - Handles spatial coordination for immersive experiences
     *
     * Reference: Building spatial SharePlay experiences - WWDC 2023 Session 10087
     * https://developer.apple.com/videos/play/wwdc2023/10087
     */
    let sharePlayManager = SharePlayManager()

    // MARK: - Initialization

    /**
     * Initialize AppModel with default state
     *
     * Sets up the initial application state:
     * - Immersive space starts in closed state
     * - SharePlayManager is ready for session management
     * - All state properties are properly initialized
     *
     * Called automatically when the app launches via @StateObject
     * in GroupExplorationApp.
     */
    init() {
        // Initial state setup occurs automatically via property initializers
        // immersiveSpaceState starts as .closed
        // sharePlayManager is initialized via default constructor
    }
}
