//___FILEHEADER___

import SwiftUI

struct ToggleImmersiveSpaceButton: View {
    @Environment(AppModel.self) private var appModel
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    var body: some View {
        Button {
            Task {
                switch appModel.immersiveSpaceState {
                case .closed:
                    await openImmersiveSpace(id: appModel.immersiveSpaceID)
                case .open, .inTransition:
                    await dismissImmersiveSpace()
                }
            }
        } label: {
            Text(appModel.immersiveSpaceState == .closed ? "Enter Immersive Space" : "Exit Immersive Space")
        }
    }
}
