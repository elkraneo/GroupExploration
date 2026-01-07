//___FILEHEADER___

import SwiftUI

@MainActor
@Observable
class AppModel {
    let immersiveSpaceID = "ImmersiveSpace"
    let sharePlayManager = SharePlayManager()

    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }

    var immersiveSpaceState = ImmersiveSpaceState.closed
}
