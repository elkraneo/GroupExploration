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

## Post-Setup Requirements

After creating a project from this template, you must manually configure the following:

### 1. Xcode Project Settings

| Setting | Required Value | Purpose |
|---------|----------------|---------|
| **Development Team** | Your Apple Developer team ID | Code signing |
| **Product Bundle Identifier** | `com.yourcompany.YourAppName` | App identification |
| **XROS Deployment Target** | `26.1` or later | SDK version |
| **Supported Platforms** | `xros xrsimulator` | Target platforms |
| **Code Signing Entitlements** | `YourAppName/YourAppName.entitlements` | Capability reference |

### 2. Swift Compiler Settings

Add these Swift Compiler - Language settings in Build Settings:

| Setting | Value | Purpose |
|---------|-------|---------|
| **Swift Approachable Concurrency** | `YES` | Enable @MainActor inference |
| **Swift Default Actor Isolation** | `MainActor` | Default actor isolation policy |
| **Member Import Visibility** | `Enabled` | Swift 6 feature flag |

### 3. Capabilities

The template includes the entitlements file, but you must enable the capability:

1. Open your project in Xcode
2. Select your target
3. Go to **Signing & Capabilities**
4. Click **+ Capability**
5. Search for **Group Session (SharePlay)**
6. The `com.apple.developer.group-session` entitlement should appear

### 4. Package Dependencies

The original project includes **RealityKitContent** as a Swift Package dependency:

**To add:**
1. File → Add Package Dependencies
2. Select **RealityKitContent**
3. Add to your target

**Purpose:** Provides RealityKit content with default immersive environment (Ground, SkyDome, etc.)

### 5. Info.plist Configuration

Update your Info.plist with the following:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>UIApplicationSceneManifest</key>
    <dict>
        <key>UIApplicationPreferredDefaultSceneSessionRole</key>
        <string>UIWindowSceneSessionRoleApplication</string>
        <key>UIApplicationSupportsMultipleScenes</key>
        <true/>
        <key>UISceneConfigurations</key>
        <dict/>
    </dict>
</dict>
</plist>
```

**Note:** The template's Info.plist is minimal. You may need to add:
- `UILaunchScreen` for startup experience
- Custom URL schemes for deep linking
- Privacy usage descriptions if accessing cameras, photos, etc.

### 6. Code Signing

For SharePlay to work:

1. **Paid Apple Developer Account** required
2. Valid **Team ID** must be set in Signing & Capabilities
3. App must be built with a **valid provisioning profile**
4. Testing requires a **physical visionOS device** or simulator with FaceTime
