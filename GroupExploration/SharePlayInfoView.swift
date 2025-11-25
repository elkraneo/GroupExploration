//
//  SharePlayInfoView.swift
//  GroupExploration
//
//  Created by Cristian Díaz on 25.11.25.
//

import SwiftUI

struct SharePlayInfoView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Introduction
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Spatial SharePlay")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("Explore immersive spaces together with spatial personas")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }

                    // Key Features
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Key Features")
                            .font(.headline)

                        FeatureCard(
                            icon: "person.2.fill",
                            title: "Spatial Personas",
                            description: "See participants as spatial personas that maintain their position in your space"
                        )

                        FeatureCard(
                            icon: "arkit",
                            title: "Shared Context",
                            description: "Everyone sees the same content from their perspective with spatial consistency"
                        )

                        FeatureCard(
                            icon: "arrow.up.and.down.text.horizontal",
                            title: "Seamless Transition",
                            description: "Move between 2D windows and immersive space while staying connected"
                        )

                        FeatureCard(
                            icon: "rotate.3d",
                            title: "Real-time Sync",
                            description: "Interact with shared objects and see changes reflected across all participants"
                        )
                    }

                    // How to Use
                    VStack(alignment: .leading, spacing: 16) {
                        Text("How to Use")
                            .font(.headline)

                        StepCard(
                            number: 1,
                            title: "Start SharePlay",
                            description: "Tap the SharePlay button in the toolbar to start a shared session"
                        )

                        StepCard(
                            number: 2,
                            title: "Invite Friends",
                            description: "Share the invitation with friends via FaceTime or Messages"
                        )

                        StepCard(
                            number: 3,
                            title: "Explore Together",
                            description: "Rotate the globe and select planets - everyone sees the same interactions"
                        )

                        StepCard(
                            number: 4,
                            title: "Enter Immersive Space",
                            description: "Toggle immersive space to explore in 3D with spatial personas"
                        )
                    }

                    // Tips
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Tips")
                            .font(.headline)

                        Text("• Spatial personas appear when participants are in FaceTime with visionOS")
                        Text("• The shared globe shows the same rotation for all participants")
                        Text("• Selected planets appear in both 2D and immersive views")
                        Text("• Use the control panel in immersive space for quick actions")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct StepCard: View {
    let number: Int
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 16) {
            Text("\(number)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(.blue, in: Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    SharePlayInfoView()
}