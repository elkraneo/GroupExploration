//___FILEHEADER___

import GroupActivities
import SwiftUI

@MainActor
@Observable
class SharePlayManager {
    var groupSession: GroupSession<___PACKAGENAMEASIDENTIFIER___Activity>?
    var isConnected = false

    func startSharePlay() async throws {
        let activity = ___PACKAGENAMEASIDENTIFIER___Activity()
        isConnected = try await activity.activate()
    }

    func configureForSession(_ session: GroupSession<___PACKAGENAMEASIDENTIFIER___Activity>) async {
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
        guard let session = groupSession else { return }
        session.leave()
        self.groupSession = nil
        isConnected = false
    }
}
