//
//  GroupExplorationApp.swift
//  GroupExploration
//
//  Created by Cristian Díaz on 25.11.25.
//

import SwiftUI
import GroupActivities

@main
struct GroupExplorationApp: App {
    @State private var appModel = AppModel()
    @State private var avPlayerViewModel = AVPlayerViewModel()

    var body: some Scene {
        WindowGroup {
            if avPlayerViewModel.isPlaying {
                AVPlayerView(viewModel: avPlayerViewModel)
            } else {
                ContentView()
                    .environment(appModel)
                    .handlesExternalEvents(
                        preferring: ["group-exploration"],
                        allowing: ["group-exploration"]
                    )
            }
        }
        .windowResizability(.contentSize)

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .handlesExternalEvents(
                    preferring: ["group-exploration"],
                    allowing: ["group-exploration"]
                )
                .onAppear {
                    appModel.immersiveSpaceState = .open
                    avPlayerViewModel.play()

                    // Handle scene association for SharePlay
                    if appModel.isSharePlayActive {
                        Task {
                            // TODO: Implement state synchronization
                            print("Scene association: SharePlay session active")
                        }
                    }
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                    avPlayerViewModel.reset()
                }
        }
        .immersionStyle(selection: .constant(.progressive), in: .progressive)
    }
}
