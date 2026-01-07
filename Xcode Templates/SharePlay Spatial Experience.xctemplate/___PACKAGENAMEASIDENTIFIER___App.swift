//___FILEHEADER___

import SwiftUI
import GroupActivities

@main
struct ___PACKAGENAMEASIDENTIFIER___App: App {
    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
                .handlesExternalEvents(
                    preferring: [___PACKAGENAMEASIDENTIFIER___Activity.activityIdentifier],
                    allowing: [___PACKAGENAMEASIDENTIFIER___Activity.activityIdentifier]
                )
        }
        .windowResizability(.contentSize)

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
                .handlesExternalEvents(
                    preferring: [],
                    allowing: [___PACKAGENAMEASIDENTIFIER___Activity.activityIdentifier]
                )
        }
        .immersionStyle(selection: .constant(.progressive), in: .progressive)
    }
}
