//
//  ContentView.swift
//  GroupExploration
//
//  Created by Cristian Díaz on 25.11.25.
//

import SwiftUI
import RealityKit
import GroupActivities

struct ContentView: View {
    @Environment(AppModel.self) private var appModel
    @State private var isSharePlayStarting = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // SharePlay Status
                SharePlayStatusView()

                // Globe Preview with Shared Rotation
                SharedGlobeView()

                // Planet Selection
                PlanetSelectionView()

                // Immersive Space Toggle
                ToggleImmersiveSpaceButton()

                Spacer()
            }
            .padding()
            .navigationTitle("Group Exploration")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    SharePlayShareButton()
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // Show SharePlay info
                        // This could be presented as a sheet or modal
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }
        }
        .onAppear {
            // Monitor shared content changes
            Task {
                while true {
                    await MainActor.run {
                        appModel.updateSharedContent()
                    }
                    try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
                }
            }
        }
    }
}

// MARK: - SharePlay Status View
struct SharePlayStatusView: View {
    @Environment(AppModel.self) private var appModel

    var body: some View {
        VStack(spacing: 8) {
            if appModel.isSharePlayActive {
                HStack {
                    Image(systemName: "person.2.fill")
                        .foregroundColor(.green)
                    Text("SharePlay Active")
                        .font(.headline)
                        .foregroundColor(.green)
                }
                Text("\(appModel.participantCount) participant\(appModel.participantCount == 1 ? "" : "s")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                HStack {
                    Image(systemName: "person.2")
                        .foregroundColor(.secondary)
                    Text("Not Connected")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Shared Globe View
struct SharedGlobeView: View {
    @Environment(AppModel.self) private var appModel
    @State private var dragRotation: SIMD3<Float> = .zero

    var body: some View {
        VStack(spacing: 16) {
            Text("Shared Globe")
                .font(.headline)

            ZStack {
                // Globe representation
                RoundedRectangle(cornerRadius: 100)
                    .fill(.blue.gradient.opacity(0.3))
                    .frame(width: 200, height: 200)
                    .overlay {
                        Circle()
                            .stroke(.blue.opacity(0.6), lineWidth: 2)
                    }
                    .rotation3DEffect(
                        .degrees(
                            Double(appModel.sharedGlobeRotation.x) +
                            Double(appModel.sharedGlobeRotation.y) +
                            Double(appModel.sharedGlobeRotation.z)
                        ),
                        axis: (x: 1, y: 1, z: 0.3)
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragRotation = SIMD3(
                                    Float(value.translation3D.y),
                                    Float(value.translation3D.x),
                                    0
                                )
                            }
                            .onEnded { _ in
                                Task {
                                    await appModel.sharePlayManager.rotateGlobe(dragRotation)
                                }
                                dragRotation = .zero
                            }
                    )

                // Planet indicator
                if let selectedPlanet = appModel.selectedPlanet {
                    VStack {
                        Spacer()
                        Text("Selected: \(selectedPlanet)")
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.regularMaterial, in: Capsule())
                    }
                }
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Planet Selection View
struct PlanetSelectionView: View {
    @Environment(AppModel.self) private var appModel
    private let planets = ["Earth", "Mars", "Jupiter", "Saturn", "Neptune"]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select Planet")
                .font(.headline)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(planets, id: \.self) { planet in
                    Button(action: {
                        Task {
                            await appModel.sharePlayManager.selectPlanet(planet)
                        }
                    }) {
                        HStack {
                            Circle()
                                .fill(planetColor(for: planet))
                                .frame(width: 24, height: 24)
                            Text(planet)
                                .font(.subheadline)
                            Spacer()
                            if appModel.selectedPlanet == planet {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            appModel.selectedPlanet == planet ?
                            .blue.opacity(0.1) : .gray.opacity(0.1),
                            in: RoundedRectangle(cornerRadius: 8)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private func planetColor(for planet: String) -> Color {
        switch planet {
        case "Earth": return .blue
        case "Mars": return .red
        case "Jupiter": return .orange
        case "Saturn": return .yellow
        case "Neptune": return .cyan
        default: return .gray
        }
    }
}

// MARK: - SharePlay Share Button
struct SharePlayShareButton: View {
    @Environment(AppModel.self) private var appModel
    @State private var isSharing = false

    var body: some View {
        Button(action: {
            Task {
                isSharing = true
                defer { isSharing = false }

                do {
                    try await appModel.sharePlayManager.startSharePlay()
                } catch {
                    print("Failed to start SharePlay: \(error)")
                }
            }
        }) {
            HStack {
                Image(systemName: appModel.isSharePlayActive ? "person.2.fill" : "person.2")
                Text(appModel.isSharePlayActive ? "SharePlay On" : "SharePlay")
            }
            .foregroundColor(appModel.isSharePlayActive ? .green : .primary)
        }
        .disabled(isSharing || appModel.isSharePlayActive)
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
