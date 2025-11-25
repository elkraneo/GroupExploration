//
//  GroupExplorationActivity.swift
//  GroupExploration
//
//  Created by Cristian Díaz on 25.11.25.
//

import GroupActivities
import SwiftUI

/// Activity for sharing immersive exploration experiences with spatial persona support
struct GroupExplorationActivity: GroupActivity {
    var metadata: GroupActivityMetadata {
        var metadata = GroupActivityMetadata()
        metadata.title = "Group Exploration"
        metadata.subtitle = "Explore immersive spaces together"
        metadata.type = .generic
        metadata.fallbackURL = URL(string: "groupexploration://shared")!

        return metadata
    }
}

/// Shared state for synchronized group exploration
struct SharedExplorationState: Codable {
    var globeRotation: SIMD3<Float> = .zero
    var selectedPlanet: String? = nil
    var participants: [ParticipantInfo] = []
    var lastUpdated: Date = Date()

    struct ParticipantInfo: Codable, Identifiable {
        let id: UUID
        let name: String
        var isImmersive: Bool = false
        var immersionStyle: String? = nil
    }
}

/// Synchronized actions for group exploration
enum ExplorationAction: Codable {
    case rotateGlobe(SIMD3<Float>)
    case selectPlanet(String)
    case participantJoined(SharedExplorationState.ParticipantInfo)
    case participantLeft(UUID)
    case enterImmersiveSpace(String)
    case exitImmersiveSpace
    case synchronizeState(SharedExplorationState)
}