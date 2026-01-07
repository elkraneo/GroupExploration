//___FILEHEADER___

import SwiftUI
import RealityKit

struct ImmersiveView: View {
    @Environment(AppModel.self) private var appModel

    var body: some View {
        RealityView { content in
            let anchor = AnchorEntity(world: [:])
            content.add(anchor)
        }
    }
}
