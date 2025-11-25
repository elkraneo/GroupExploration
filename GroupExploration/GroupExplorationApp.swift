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
                        preferring: [GroupExplorationActivity.activityIdentifier],
                        allowing: [GroupExplorationActivity.activityIdentifier]
                    )
            }
        }
        .windowResizability(.contentSize)

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                    avPlayerViewModel.play()
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                    avPlayerViewModel.reset()
                }
                .handlesExternalEvents(
                  preferring: [],
                  allowing: [GroupExplorationActivity.activityIdentifier]
                )
        }
        .immersionStyle(selection: .constant(.progressive), in: .progressive)
    }
}
