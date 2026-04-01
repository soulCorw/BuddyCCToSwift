import SwiftUI

// MARK: - HatchView
// The first-run "hatch your companion" flow.
// Shows a preview of the companion's bones, then calls Claude API
// to generate the soul (name + personality).

struct HatchView: View {
    @ObservedObject var store: CompanionStore
    var onHatched: (() -> Void)? = nil

    @State private var phase: HatchPhase = .preview
    @State private var errorMessage: String?

    private var bones: CompanionBones { store.previewBones }

    enum HatchPhase { case preview, hatching, error }

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // Title
            VStack(spacing: 6) {
                Text("A new companion awaits")
                    .font(.title2.bold())
                Text("Tap the egg to hatch")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // Egg / preview sprite
            ZStack {
                if phase == .hatching {
                    // Spinning while Claude generates the soul
                    ProgressView()
                        .scaleEffect(2)
                        .tint(bones.rarity.color)
                } else {
                    EggView(rarity: bones.rarity)
                        .onTapGesture { beginHatch() }
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .frame(height: 120)

            // Rarity hint
            HStack {
                Text(bones.rarity.stars)
                    .foregroundColor(bones.rarity.color)
                Text("·")
                    .foregroundColor(.secondary)
                Text(bones.species.displayName)
                    .foregroundColor(.secondary)
                if bones.shiny {
                    Text("✨")
                }
            }
            .font(.subheadline)
            .animation(.easeInOut, value: phase)

            if let err = errorMessage {
                Text(err)
                    .font(.caption)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Button("Try again") { beginHatch() }
                    .buttonStyle(.bordered)
            }

            if phase == .preview {
                Button("Hatch!") { beginHatch() }
                    .buttonStyle(.borderedProminent)
                    .tint(bones.rarity.color)
                    .controlSize(.large)
            }

            Spacer()
        }
        .padding()
    }

    private func beginHatch() {
        phase = .hatching
        errorMessage = nil

        Task {
            do {
                let soul = try await SoulGenerator.generate(bones: bones)
                await MainActor.run {
                    store.saveSoul(soul)
                    phase = .preview
                    onHatched?()
                }
            } catch {
                await MainActor.run {
                    phase = .error
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

// MARK: - EggView

private struct EggView: View {
    let rarity: Rarity
    @State private var wiggle = false

    var body: some View {
        ZStack {
            Ellipse()
                .fill(
                    LinearGradient(
                        colors: [rarity.color.opacity(0.7), rarity.color],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 80, height: 100)
                .shadow(color: rarity.color.opacity(0.4), radius: 12, y: 4)

            // Crack marks for rare+
            if rarity != .common && rarity != .uncommon {
                Text("✦")
                    .font(.title)
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .rotationEffect(.degrees(wiggle ? -5 : 5))
        .animation(.easeInOut(duration: 0.25).repeatForever(autoreverses: true), value: wiggle)
        .onAppear { wiggle = true }
    }
}

#Preview {
    HatchView(store: CompanionStore())
}
