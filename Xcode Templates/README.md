# SharePlay Spatial Experience - Xcode Template

A visionOS 26 Xcode project template for building apps with SharePlay group activities and immersive spaces.

## What's Included

### Core Components

| File | Description |
|------|-------------|
| `___PROJECTNAMEASIDENTIFIER___App.swift` | Multi-scene app with WindowGroup + ImmersiveSpace |
| `___PROJECTNAMEASIDENTIFIER___Activity.swift` | GroupActivity definition with metadata |
| `SharePlayManager.swift` | Session management, SystemCoordinator config |
| `AppModel.swift` | @MainActor @Observable state management |
| `ContentView.swift` | Main UI with SharePlay controls |
| `ImmersiveView.swift` | RealityView for immersive content |
| `ToggleImmersiveSpaceButton.swift` | 2D ↔ immersive transition |
| `Info.plist` | visionOS app configuration |
| `___PROJECTNAME___.entitlements` | `com.apple.developer.group-session` capability |

### Features

- GroupActivity protocol implementation
- `SystemCoordinator` with `.sideBySide` spatial template
- `supportsGroupImmersiveSpace = true`
- `handlesExternalEvents` for scene association
- Progressive immersion style (configurable)

---

## What's NOT Included (Post-Setup Required)

### 1. AVPlayer Video Playback

The template does **not** include AVPlayer integration. To add video playback:

**Add these files:**

```
AVPlayerViewModel.swift:
```swift
import AVKit

@MainActor
@Observable
class AVPlayerViewModel: NSObject {
    var isPlaying: Bool = false
    private var avPlayerViewController: AVPlayerViewController?
    private var avPlayer = AVPlayer()
    private let videoURL: URL? = {
        Bundle.main.url(forResource: "MyVideo", withExtension: "mp4")
    }()

    func makePlayerViewController() -> AVPlayerViewController {
        let avPlayerViewController = AVPlayerViewController()
        avPlayerViewController.player = avPlayer
        avPlayerViewController.delegate = self
        self.avPlayerViewController = avPlayerViewController
        return avPlayerViewController
    }

    func play() {
        guard !isPlaying, let videoURL else { return }
        isPlaying = true
        let item = AVPlayerItem(url: videoURL)
        avPlayer.replaceCurrentItem(with: item)
        avPlayer.play()
    }

    func reset() {
        guard isPlaying else { return }
        isPlaying = false
        avPlayer.replaceCurrentItem(with: nil)
    }
}

extension AVPlayerViewModel: AVPlayerViewControllerDelegate {
    nonisolated func playerViewController(
        _ playerViewController: AVPlayerViewController,
        willEndFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator
    ) {
        Task { @MainActor in reset() }
    }
}
```

```
AVPlayerView.swift:
```swift
import SwiftUI

struct AVPlayerView: UIViewControllerRepresentable {
    let viewModel: AVPlayerViewModel

    func makeUIViewController(context: Context) -> some UIViewController {
        return viewModel.makePlayerViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
```

**Update AppModel.swift:**
```swift
@MainActor
@Observable
class AppModel {
    let immersiveSpaceID = "ImmersiveSpace"
    let sharePlayManager = SharePlayManager()
    let avPlayerViewModel = AVPlayerViewModel()

    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }

    var immersiveSpaceState = ImmersiveSpaceState.closed
}
```

**Update ___PROJECTNAMEASIDENTIFIER___App.swift:**
```swift
WindowGroup {
    if avPlayerViewModel.isPlaying {
        AVPlayerView(viewModel: avPlayerViewModel)
    } else {
        ContentView()
            .environment(appModel)
            .handlesExternalEvents(...)
    }
}
```

---

### 2. Documentation

The template uses minimal inline documentation. For production apps, consider adding:

- WWDC session references (10111, 10087, 10201, etc.)
- Architecture explanations
- Error handling guidance
- State machine documentation

---

### 3. Info.plist Customization

The template's Info.plist includes minimal settings. Add:

- `UILaunchScreen` configuration for app startup experience
- Custom URL schemes for deep linking
- Device capability requirements

---

## Installation

```bash
./install-xcode-template.sh
```

Then restart Xcode and create a new project:
- File → New → Project
- Select **visionOS** → **Application**
- Choose **SharePlay Spatial Experience**

## Template Structure

```
SharePlay Spatial Experience.xctemplate/
├── TemplateInfo.plist           # Metadata & configuration
├── ___PROJECTNAMEASIDENTIFIER___App.swift
├── ___PROJECTNAMEASIDENTIFIER___Activity.swift
├── SharePlayManager.swift
├── ContentView.swift
├── AppModel.swift
├── ImmersiveView.swift
├── ToggleImmersiveSpaceButton.swift
├── Info.plist
├── ___PROJECTNAME___.entitlements
└── Assets.xcassets/
    ├── AppIcon.solidimagestack/
    └── AccentColor.colorset/
```

## Requirements

- Xcode 26+
- visionOS 26 SDK
- Paid Apple Developer account (for SharePlay capabilities)
- FaceTime-enabled device for testing SharePlay

## References

- [Build spatial SharePlay experiences - WWDC 2023](https://developer.apple.com/videos/play/wwdc2023/10087)
- [Customize spatial Persona templates - WWDC 2024](https://developer.apple.com/videos/play/wwdc2024/10201)
- [Go beyond the window with SwiftUI - WWDC 2023](https://developer.apple.com/videos/play/wwdc2023/10111)
- [GroupActivities Documentation](https://developer.apple.com/documentation/GroupActivities)
