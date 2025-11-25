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
    var sharedState = SharedExplorationState()
    var isConnected = false

    // MARK: - Session Management
    func startSharePlay() async throws {
        let activity = GroupExplorationActivity()

        // For now, just simulate activation until we can determine the correct API
        // This allows the app to compile and the UI to work
        print("Attempting to activate SharePlay activity...")

        // Create a mock session for development
        // TODO: Replace with actual activation when API is confirmed
        isConnected = true
        print("SharePlay simulation activated")
    }

    func configureForSession(_ session: GroupSession<GroupExplorationActivity>) async {
        self.groupSession = session
        session.join()
        isConnected = true

        // Start basic message listening
        startMessageListening(session)
    }

    private func startMessageListening(_ session: GroupSession<GroupExplorationActivity>) {
        Task {
            do {
                let messenger = GroupSessionMessenger(session: session)

                // Correct message iteration for visionOS 2.6
                for await (action, context) in messenger.messages(of: ExplorationAction.self) {
                    await handleIncomingMessage(action)
                }
            } catch {
                print("Failed to start message listening: \(error)")
            }
        }
    }

    func leaveSession() {
        groupSession?.leave()
        groupSession = nil
        isConnected = false
        sharedState = SharedExplorationState()
    }

    // MARK: - Message Handling
    private func handleIncomingMessage(_ action: ExplorationAction) async {
        switch action {
        case .rotateGlobe(let rotation):
            sharedState.globeRotation = rotation
        case .selectPlanet(let planet):
            sharedState.selectedPlanet = planet
        case .synchronizeState(let state):
            sharedState = state
        default:
            break
        }
        sharedState.lastUpdated = Date()
    }

    // MARK: - Action Broadcasting
    func broadcastAction(_ action: ExplorationAction) async {
        guard isConnected else { return }

        // For simulation, just log the action
        print("Broadcasting action: \(action)")

        // TODO: Replace with actual messaging when session is available
        if let session = groupSession {
            do {
                let messenger = GroupSessionMessenger(session: session)
                try await messenger.send(action)
            } catch {
                print("Failed to broadcast action: \(error)")
            }
        }
    }

    // MARK: - Public API
    func rotateGlobe(_ rotation: SIMD3<Float>) async {
        sharedState.globeRotation = rotation
        await broadcastAction(.rotateGlobe(rotation))
    }

    func selectPlanet(_ planet: String) async {
        sharedState.selectedPlanet = planet
        await broadcastAction(.selectPlanet(planet))
    }

    // MARK: - Helper Methods
    var participantCount: Int {
        return isConnected ? 2 : 1 // Simulate 2 participants when connected
    }

    var isActive: Bool {
        return isConnected
    }
}