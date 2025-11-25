//
//  GroupExplorationActivity.swift
//  GroupExploration
//
//  Created by Cristian Díaz on 25.11.25.
//

import GroupActivities
import SwiftUI

/// Activity for sharing immersive exploration experiences with spatial persona support
struct GroupExplorationActivity: GroupActivity {
    public static let activityIdentifier =
      "group-exploration"
  
    var metadata: GroupActivityMetadata {
        var metadata = GroupActivityMetadata()
        metadata.title = "Group Exploration"
        metadata.subtitle = "Explore immersive spaces together"
        metadata.type = .generic
        metadata.fallbackURL = URL(string: "groupexploration://shared")!

        return metadata
    }
}
