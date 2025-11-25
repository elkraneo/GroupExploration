//
//  ContentView.swift
//  GroupExploration
//
//  Created by Cristian Díaz on 25.11.25.
//

import SwiftUI
import RealityKit
import GroupActivities

struct ContentView: View {
    @Environment(AppModel.self) private var appModel
    @State private var sessionTask = Task<Void, Never> {}

    var body: some View {
        NavigationStack {
            ZStack {
                ToggleImmersiveSpaceButton()
            }
            .navigationTitle("Group Exploration")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    SharePlayShareButton()
                }
            }
            .task { await observeGroupSessions() }
        }
    }
  
  /// Monitor for new Escape Together group activity sessions.
  @Sendable
  private func observeGroupSessions() async {
    sessionTask = Task { @MainActor in
      for await session in GroupExplorationActivity.sessions() {
        await appModel.sharePlayManager.configureForSession(session)
      }
    }
  }
}

// MARK: - SharePlay Share Button
struct SharePlayShareButton: View {
    @Environment(AppModel.self) private var appModel

    var body: some View {
        Button("SharePlay"){
            Task {
                do {
                    try await appModel.sharePlayManager.startSharePlay()
                } catch {
                    print("Failed to start SharePlay: \(error)")
                }
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
