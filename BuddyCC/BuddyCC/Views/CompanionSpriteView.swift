import SwiftUI

// MARK: - Animation constants (mirrors CompanionSprite.tsx)
private let tickInterval: TimeInterval = 0.5
// Idle sequence: mostly frame 0, occasional fidget, -1 = blink on frame 0
private let idleSequence = [0, 0, 0, 0, 1, 0, 0, 0, -1, 0, 0, 2, 0, 0, 0]
private let petBurstDuration: TimeInterval = 2.5
private let heartFrames = [
    "   ♥    ♥   ",
    "  ♥  ♥   ♥  ",
    " ♥   ♥  ♥   ",
    "♥  ♥      ♥ ",
    "·    ·   ·  ",
]

// MARK: - CompanionSpriteView

struct CompanionSpriteView: View {
    let companion: Companion
    var onPet: (() -> Void)? = nil

    @State private var tickIndex = 0
    @State private var isBlinking = false
    @State private var isPetting = false
    @State private var heartTick = 0
    @State private var tickTimer: Timer?   // BUG FIX: store ref so we can invalidate

    private var currentFrame: Int {
        let seq = idleSequence[tickIndex % idleSequence.count]
        return isBlinking ? 0 : max(0, seq)
    }

    private var spriteLines: [String] {
        var bones = companion.bones
        if isBlinking {
            // Override eye to dash for blink frame
            bones = CompanionBones(
                rarity: bones.rarity, species: bones.species,
                eye: .cross, hat: bones.hat,
                shiny: bones.shiny, stats: bones.stats
            )
        }
        return renderSprite(bones: bones, frame: currentFrame)
    }

    private var rarityColor: Color { companion.rarity.color }

    var body: some View {
        VStack(spacing: 2) {
            // Floating hearts during pet burst
            if isPetting {
                Text(heartFrames[min(heartTick, heartFrames.count - 1)])
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.pink)
                    .transition(.opacity)
            }

            // Main sprite
            VStack(spacing: 0) {
                ForEach(spriteLines.indices, id: \.self) { i in
                    Text(spriteLines[i])
                        .font(.system(size: 14, weight: .regular, design: .monospaced))
                        .foregroundColor(companion.shiny ? shinyCycleColor : rarityColor)
                        .lineLimit(1)
                        .fixedSize()
                }
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemBackground).opacity(0.0))
            )
            .onTapGesture { triggerPet() }
        }
        .onAppear { startTicking() }
        .onDisappear { tickTimer?.invalidate(); tickTimer = nil }
    }

    // MARK: - Shiny rainbow cycle

    @State private var shinyPhase: Double = 0

    private var shinyCycleColor: Color {
        Color(hue: shinyPhase.truncatingRemainder(dividingBy: 1.0),
              saturation: 0.9, brightness: 0.9)
    }

    // MARK: - Tick logic

    private func startTicking() {
        tickTimer?.invalidate()
        tickTimer = Timer.scheduledTimer(withTimeInterval: tickInterval, repeats: true) { _ in
            tickIndex = (tickIndex + 1) % idleSequence.count
            isBlinking = idleSequence[tickIndex % idleSequence.count] == -1
            if companion.shiny { shinyPhase += 0.04 }
            if isPetting {
                heartTick += 1
                if heartTick >= heartFrames.count { isPetting = false; heartTick = 0 }
            }
        }
    }

    private func triggerPet() {
        isPetting = true
        heartTick = 0
        onPet?()
        DispatchQueue.main.asyncAfter(deadline: .now() + petBurstDuration) {
            isPetting = false
        }
    }
}

// MARK: - Preview

#Preview {
    let bones = CompanionBones(
        rarity: .legendary, species: .dragon,
        eye: .sparkle, hat: .wizard,
        shiny: true,
        stats: [.debugging: 95, .patience: 20, .chaos: 80, .wisdom: 60, .snark: 45]
    )
    let soul = CompanionSoul(name: "Ignis", personality: "A chaotic fire-breather who debugs by burning everything down.", hatchedAt: Date())
    return CompanionSpriteView(companion: Companion(bones: bones, soul: soul))
        .padding()
        .background(Color(.systemBackground))
}
