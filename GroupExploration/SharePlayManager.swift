//
//  SharePlayManager.swift
//  GroupExploration
//
//  Created by Cristian Díaz on 25.11.25.
//

import GroupActivities
import SwiftUI

/// Manages SharePlay sessions using Swift concurrency
@MainActor
@Observable
class SharePlayManager {
    // MARK: - Published Properties
    var groupSession: GroupSession<GroupExplorationActivity>?
    var isConnected = false

    // MARK: - Session Management
    func startSharePlay() async throws {
        let activity = GroupExplorationActivity()

        // For now, just simulate activation until we can determine the correct API
        // This allows the app to compile and the UI to work
        print("Attempting to activate SharePlay activity...")

        
        // Create a mock session for development
        // TODO: Replace with actual activation when API is confirmed
        isConnected = try await activity.activate()
        print("SharePlay simulation activated")
    }

    func configureForSession(_ session: GroupSession<GroupExplorationActivity>) async {
        self.groupSession = session
      
        if let coordinator = await session.systemCoordinator {
            var config = SystemCoordinator.Configuration()
            config.spatialTemplatePreference = .sideBySide.contentExtent(200)
            config.supportsGroupImmersiveSpace = true
            coordinator.configuration = config
        }
        session.join()
        isConnected = true
    }

    func leaveSession() {
        groupSession?.leave()
        groupSession = nil
        isConnected = false
    }
}
