//___FILEHEADER___

import GroupActivities
import SwiftUI

struct ___PACKAGENAMEASIDENTIFIER___Activity: GroupActivity {
    public static let activityIdentifier = "___PROJECTNAME___"

    var metadata: GroupActivityMetadata {
        var metadata = GroupActivityMetadata()
        metadata.title = "___PROJECTNAME___"
        metadata.subtitle = "Share a spatial experience together"
        metadata.type = .generic
        metadata.fallbackURL = URL(string: "___PROJECTNAME___://shared")!
        return metadata
    }
}
