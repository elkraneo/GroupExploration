# GroupExploration - SharePlay Spatial Experience for visionOS 26

A minimal viable SharePlay group activity implementation for visionOS 26 that enables spatial persona support and immersive space collaboration.

## Overview

This project demonstrates the essential components needed to implement SharePlay functionality with spatial coordination in visionOS 26 immersive spaces. The implementation focuses on core functionality without unnecessary complexity, making it an ideal reference template for spatial collaboration applications.

## Features

- **Real SharePlay Integration**: Actual GroupActivity activation and session management
- **Spatial Persona Support**: SystemCoordinator configuration for participant positioning
- **Immersive Space Coordination**: Group immersive space transitions with shared context
- **Session Monitoring**: Automatic detection and handling of incoming SharePlay invitations
- **Scene Association**: Proper multi-scene support for 2D window and immersive modes
- **Minimal Architecture**: Essential components only, no bloat

## Project Structure

```
GroupExploration/
├── GroupExplorationActivity.swift    # Core GroupActivity definition
├── SharePlayManager.swift             # Session management and spatial coordination
├── ContentView.swift                  # UI with SharePlay controls and session monitoring
├── GroupExplorationApp.swift         # Scene association and external event handling
├── GroupExploration.entitlements     # Required SharePlay capabilities
├── AppModel.swift                     # App state management
├── ImmersiveView.swift               # Immersive space implementation
└── ToggleImmersiveSpaceButton.swift   # Immersive space toggle UI
```

## Key Components

### GroupExplorationActivity.swift
Defines the shareable activity that users can invite others to join through FaceTime.

### SharePlayManager.swift
Manages SharePlay sessions and configures spatial templates using SystemCoordinator.

### ContentView.swift
Provides SharePlay controls and monitors for incoming group activity sessions.

### GroupExplorationApp.swift
Configures app scenes to handle SharePlay invitations and external events.

## Getting Started

### Prerequisites
- visionOS 26.0+
- Xcode 16.0+
- Apple Developer account (for entitlements)
- Physical visionOS device (SharePlay requires real hardware)

### Setup
1. Clone or download the project
2. Open in Xcode 16.0+
3. Ensure your Apple Developer account has Group Activities capability
4. Build and run on a physical visionOS device

### Usage
1. **Start SharePlay**: Tap the "SharePlay" button to start a new session
2. **Invite Participants**: Share via FaceTime to invite others to join
3. **Enter Immersive Space**: Toggle immersive space for spatial collaboration
4. **Automatic Joining**: The app automatically detects and joins incoming SharePlay sessions

## Technical Implementation

The implementation follows a minimal viable pattern focusing on essential SharePlay functionality:

- **Real API Usage**: Uses actual `activity.activate()` and session monitoring
- **Spatial Coordination**: SystemCoordinator configuration with `.sideBySide` template
- **Scene Association**: Proper external event handling for SharePlay invitations
- **Swift Concurrency**: Modern async/await patterns throughout

## WWDC Session References

For comprehensive understanding, refer to these official Apple sessions:

- **Build spatial SharePlay experiences** (WWDC 2023, Session 10087) - [Link](https://developer.apple.com/videos/play/wwdc2023/10087)
- **Make a great SharePlay experience** (WWDC 2022, Session 10139) - [Link](https://developer.apple.com/videos/play/wwdc2022/10139)
- **Customize spatial Persona templates in SharePlay** (WWDC 2024, Session 10201) - [Link](https://developer.apple.com/videos/play/wwdc2024/10201)
- **Go beyond the window with SwiftUI** (WWDC 2023, Session 10111) - [Link](https://developer.apple.com/videos/play/wwdc2023/10111)

## Required Entitlements

The project includes the essential SharePlay entitlement:
- `com.apple.developer.group-session` - Enables SharePlay functionality

## Architecture

This implementation demonstrates the minimal viable pattern for SharePlay spatial experiences in visionOS 26:

1. **Activity Definition**: Core GroupActivity with metadata
2. **Session Management**: Real activation and configuration
3. **Spatial Coordination**: SystemCoordinator with spatial templates
4. **UI Integration**: Simple controls and session monitoring
5. **Scene Association**: Proper external event handling

## Testing

### Requirements
- Multiple visionOS devices
- Different Apple IDs for participants
- FaceTime integration
- Stable network connection

### Test Scenarios
1. **Starting New Sessions**: Create SharePlay session from app
2. **Joining Existing Sessions**: Receive and join invitations
3. **Immersive Space Transitions**: Test spatial template behavior
4. **Participant Management**: Verify join/leave functionality

## Documentation

For detailed technical documentation, see the inline code comments and the comprehensive implementation guide.

## License

This project serves as a reference template for SharePlay implementation. Use as needed for your own visionOS applications.