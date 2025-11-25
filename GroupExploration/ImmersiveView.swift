//
//  ImmersiveView.swift
//  GroupExploration
//
//  Created by Cristian Díaz on 25.11.25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @Environment(AppModel.self) private var appModel

    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)
            }

            // Add shared immersive content
            await addSharedContent(to: content)
        }
        .onAppear {
            // Notify other participants that we entered immersive space
            Task {
                await appModel.sharePlayManager.broadcastAction(.enterImmersiveSpace("progressive"))
            }
        }
        .onDisappear {
            // Notify other participants that we left immersive space
            Task {
                await appModel.sharePlayManager.broadcastAction(.exitImmersiveSpace)
            }
        }
    }

    // MARK: - Shared Content
    private func addSharedContent(to content: RealityViewContent) async {
        // Create a shared globe that rotates based on shared state
        let globeEntity = createSharedGlobe()
        globeEntity.position = [0, 1.5, -2] // Position relative to shared origin
        content.add(globeEntity)

        // Add selected planet model if available
        if let selectedPlanet = appModel.selectedPlanet {
            let planetEntity = createPlanetEntity(for: selectedPlanet)
            planetEntity.position = [1.5, 1.5, -2]
            content.add(planetEntity)
        }
    }

    private func createSharedGlobe() -> Entity {
        let sphere = MeshResource.generateSphere(radius: 0.5)
        let material = SimpleMaterial(color: .blue, isMetallic: false)
        let globeEntity = ModelEntity(mesh: sphere, materials: [material])

        // Apply shared rotation
        let rotationAngle = appModel.sharedGlobeRotation.x + appModel.sharedGlobeRotation.y + appModel.sharedGlobeRotation.z
        let rotation = simd_quatf(angle: rotationAngle, axis: [1, 1, 0.3])
        globeEntity.transform.rotation = rotation

        // Make the globe interactive
        globeEntity.components.set(GlobeInteractionComponent())

        // Add a tag for easy identification
        globeEntity.name = "SharedGlobe"

        return globeEntity
    }

    private func createPlanetEntity(for planet: String) -> Entity {
        let radius: Float = 0.3
        let sphere = MeshResource.generateSphere(radius: radius)
        let material = SimpleMaterial(color: .blue, isMetallic: true) // Simplified for now
        let planetEntity = ModelEntity(mesh: sphere, materials: [material])

        // Add orbital animation
        planetEntity.components.set(OrbitalAnimationComponent(
            center: [0, 0, 0],
            radius: 1.2,
            speed: 0.5
        ))

        planetEntity.name = planet
        return planetEntity
    }

    // MARK: - Gesture
    private var rotateGesture: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                // Find the globe entity and rotate it
                if let globeEntity = value.entity.parent?.children.first(where: { $0.name == "SharedGlobe" }) {
                    let rotation = SIMD3<Float>(
                        Float(value.translation3D.y) * 0.01,
                        Float(value.translation3D.x) * 0.01,
                        0
                    )

                    let currentRotation = globeEntity.transform.rotation
                    let newRotation = simd_mul(
                        simd_quatf(angle: 0.01, axis: SIMD3<Float>(Float(value.translation3D.y), Float(value.translation3D.x), 0)),
                        currentRotation
                    )
                    globeEntity.transform.rotation = newRotation

                    // Broadcast rotation to other participants
                    Task {
                        await appModel.sharePlayManager.rotateGlobe(rotation)
                    }
                }
            }
    }
}

// MARK: - Component Definitions
struct GlobeInteractionComponent: Component {}

struct OrbitalAnimationComponent: Component {
    let center: SIMD3<Float>
    let radius: Float
    let speed: Float
}

// MARK: - Participant Control Panel
struct ParticipantControlPanel: View {
    @Environment(AppModel.self) private var appModel
    @State private var isShowingParticipants = false

    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Image(systemName: "person.2.fill")
                    .foregroundColor(.blue)
                Text("SharePlay Controls")
                    .font(.headline)
                Spacer()
            }

            // Participant Count
            HStack {
                Text("Participants:")
                    .font(.subheadline)
                Spacer()
                Text("\(appModel.participantCount)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }

            Divider()

            // Quick Actions
            VStack(spacing: 12) {
                Button("Sync State") {
                    Task {
                        // TODO: Implement state synchronization
                        print("State synchronization requested")
                    }
                }
                .buttonStyle(.bordered)

                Button("Leave SharePlay") {
                    appModel.sharePlayManager.leaveSession()
                }
                .buttonStyle(.bordered)
                .foregroundColor(.red)
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .frame(width: 280)
    }
}

#Preview(immersionStyle: .progressive) {
    ImmersiveView()
        .environment(AppModel())
}