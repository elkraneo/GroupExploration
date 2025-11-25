//
//  GroupExplorationApp.swift
//  GroupExploration
//
//  Created by Cristian Díaz on 25.11.25.
//

import SwiftUI
import GroupActivities

/**
 * GroupExplorationApp - Multi-Scene SharePlay Application Entry Point
 *
 * This app defines the multi-scene architecture for SharePlay-enabled group exploration.
 * It supports both 2D window mode and immersive space mode with proper SharePlay
 * invitation handling across scenes.
 *
 * Architecture Components:
 * - WindowGroup: 2D window interface with SharePlay controls
 * - ImmersiveSpace: Immersive spatial experience
 * - Scene Association: External event handling for SharePlay invitations
 *
 * Scene Types:
 * - Window Scene: Traditional windowed interface with SharePlay integration
 * - Immersive Space: Full immersive spatial experience with collaborative features
 *
 * SharePlay Integration:
 * - External event handling for incoming invitations
 * - Activity identifier association for proper routing
 * - Multi-scene support for 2D ↔ immersive transitions
 *
 * Reference: Go beyond the window with SwiftUI - WWDC 2023 Session 10111
 * https://developer.apple.com/videos/play/wwdc2023/10111
 */
@main
struct GroupExplorationApp: App {
    @State private var appModel = AppModel()
    @State private var avPlayerViewModel = AVPlayerViewModel()

    var body: some Scene {
        /**
         * WindowGroup - 2D Window Scene
         *
         * Provides the traditional windowed interface for the application.
         * Handles SharePlay invitations in window mode and supports external
         * event association for GroupExplorationActivity.
         *
         * External Events Configuration:
         * - preferring: Gives priority to this scene for handling invitations
         * - allowing: Permits this scene to open for specific activity identifiers
         * - activityIdentifier: Links scenes to the specific GroupActivity type
         *
         * Scene Association Logic:
         * - WindowGroup handles SharePlay invitations in 2D mode
         - ImmersiveSpace handles invitations when in immersive mode
         * - Both scenes use the same activity identifier for consistency
         *
         * Reference: Make a great SharePlay experience - WWDC 2022 Session 10139
         * https://developer.apple.com/videos/play/wwdc2022/10139
         */
        WindowGroup {
            if avPlayerViewModel.isPlaying {
                AVPlayerView(viewModel: avPlayerViewModel)
            } else {
                ContentView()
                    .environment(appModel)
                    .handlesExternalEvents(
                        preferring: [GroupExplorationActivity.activityIdentifier],
                        allowing: [GroupExplorationActivity.activityIdentifier]
                    )
            }
        }
        .windowResizability(.contentSize)

        /**
         * ImmersiveSpace - Immersive Spatial Scene
         *
         * Provides full immersive experience for spatial collaboration.
         * Supports SharePlay invitation handling and manages immersive space
         * state transitions with proper lifecycle management.
         *
         * Immersive Space Features:
         * - Full spatial immersion with passthrough
         * - SharePlay spatial persona support
         * - External event handling for invitations
         * - State management for space transitions
         *
         * ImmersionStyle Configuration:
         * - .progressive: Gradual transition between window and immersive modes
         * - .full: Full immersion with no window content
         * - .mixed: Hybrid mode with window content visible
         *
         * State Management:
         * - Tracks immersive space state in AppModel
         * - Manages AVPlayer lifecycle for spatial content
         * - Handles proper cleanup on space dismissal
         *
         * Reference: Dive deep into volumes and immersive spaces - WWDC 2024 Session 10153
         * https://developer.apple.com/videos/play/wwdc2024/10153
         */
        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    // Update app state to indicate immersive space is active
                    appModel.immersiveSpaceState = .open

                    // Start spatial content playback when immersive space appears
                    avPlayerViewModel.play()
                }
                .onDisappear {
                    // Update app state to indicate immersive space is inactive
                    appModel.immersiveSpaceState = .closed

                    // Clean up AVPlayer resources when immersive space dismisses
                    avPlayerViewModel.reset()
                }
                // Configure external event handling for SharePlay invitations in immersive space
                .handlesExternalEvents(
                  preferring: [],
                  allowing: [GroupExplorationActivity.activityIdentifier]
                )
        }
        // Configure immersion style for progressive transitions between modes
        .immersionStyle(selection: .constant(.progressive), in: .progressive)
    }
}
