//___FILEHEADER___

import SwiftUI
import GroupActivities

struct ContentView: View {
    @Environment(AppModel.self) private var appModel
    @State private var sessionTask = Task<Void, Never> {}

    var body: some View {
        NavigationStack {
            ZStack {
                ToggleImmersiveSpaceButton()
            }
            .navigationTitle("___PROJECTNAME___")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    SharePlayShareButton()
                }
            }
            .task { await observeGroupSessions() }
        }
    }

    @Sendable
    private func observeGroupSessions() async {
        sessionTask = Task { @MainActor in
            for await session in ___PACKAGENAMEASIDENTIFIER___Activity.sessions() {
                await appModel.sharePlayManager.configureForSession(session)
            }
        }
    }
}

struct SharePlayShareButton: View {
    @Environment(AppModel.self) private var appModel

    var body: some View {
        Button("SharePlay") {
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
