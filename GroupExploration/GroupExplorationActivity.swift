//
//  GroupExplorationActivity.swift
//  GroupExploration
//
//  Created by Cristian Díaz on 25.11.25.
//

import GroupActivities
import SwiftUI

/**
 * GroupExplorationActivity - Core SharePlay Activity Definition
 *
 * This struct defines the shareable activity that users can invite others to join through FaceTime.
 * It serves as the entry point for SharePlay functionality and provides the metadata
 * displayed in the SharePlay invitation UI.
 *
 * Key Components:
 * - activityIdentifier: Unique identifier for the activity type
 * - metadata: Information shown in SharePlay invitation sheet
 *
 * Implementation Pattern:
 * Based on GroupActivities framework requirements for visionOS 26
 *
 * Reference: Building spatial SharePlay experiences - WWDC 2023 Session 10087
 * https://developer.apple.com/videos/play/wwdc2023/10087
 */
struct GroupExplorationActivity: GroupActivity {

    /// Unique identifier for this activity type
    /// Used for scene association and external event handling
    /// Must match the identifier used in handlesExternalEvents modifiers
    public static let activityIdentifier = "group-exploration"

    /**
     * Activity metadata displayed in SharePlay invitation UI
     *
     * Provides essential information to users when they receive a SharePlay invitation:
     * - title: Primary activity name shown in FaceTime interface
     * - subtitle: Additional context about the shared experience
     * - type: Activity categorization (.generic for flexible usage)
     * - fallbackURL: Deep link when SharePlay is unavailable
     *
     * Metadata Requirements:
     * - Title must be concise and descriptive
     * - Subtitle should explain what users will do together
     * - Fallback URL enables app launching from invitations
     *
     * Reference: Make a great SharePlay experience - WWDC 2022 Session 10139
     * https://developer.apple.com/videos/play/wwdc2022/10139
     */
    var metadata: GroupActivityMetadata {
        var metadata = GroupActivityMetadata()

        // Primary title shown in FaceTime SharePlay interface
        metadata.title = "Group Exploration"

        // Additional context about the shared experience
        metadata.subtitle = "Explore immersive spaces together"

        // Activity type for categorization in SharePlay
        metadata.type = .generic

        // Deep link for app launching when SharePlay unavailable
        metadata.fallbackURL = URL(string: "groupexploration://shared")!

        return metadata
    }
}
