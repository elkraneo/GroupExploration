//
//  AppModel.swift
//  GroupExploration
//
//  Created by Cristian Díaz on 25.11.25.
//

import SwiftUI

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    let immersiveSpaceID = "ImmersiveSpace"
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed

    // MARK: - SharePlay Integration
    let sharePlayManager = SharePlayManager()

    var isSharePlayActive: Bool {
        sharePlayManager.isActive
    }

    var participantCount: Int {
        sharePlayManager.participantCount
    }

    
    // MARK: - Shared Content
    var sharedGlobeRotation: SIMD3<Float> = .zero
    var selectedPlanet: String? = nil

    func updateSharedContent() {
        sharedGlobeRotation = sharePlayManager.sharedState.globeRotation
        selectedPlanet = sharePlayManager.sharedState.selectedPlanet
    }
}
