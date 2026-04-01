import SwiftUI

// MARK: - CompanionCardView
// Full card: sprite on top, stats below. Used in the main tab.

struct CompanionCardView: View {
    @ObservedObject var store: CompanionStore
    @State private var activeBubble: String?
    @State private var showStats = true

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let companion = store.companion {
                    // Sprite with speech bubble floating above via overlay
                    // (overlay escapes the ZStack bounds, avoids clipping)
                    CompanionSpriteView(companion: companion) {
                        activeBubble = randomQuip(for: companion)
                    }
                    .padding(.top, 8)
                    .overlay(alignment: .top) {
                        if let bubble = activeBubble {
                            SpeechBubbleView(
                                text: bubble,
                                color: companion.rarity.color
                            ) {
                                withAnimation { activeBubble = nil }
                            }
                            .fixedSize()
                            .offset(y: -80)
                            .transition(.scale(scale: 0.8, anchor: .bottom).combined(with: .opacity))
                        }
                    }
                    .animation(.spring(response: 0.4), value: activeBubble != nil)

                    // Toggle stats
                    Button {
                        withAnimation(.spring()) { showStats.toggle() }
                    } label: {
                        Label(showStats ? "Hide stats" : "Show stats", systemImage: showStats ? "chevron.up" : "chevron.down")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)

                    if showStats {
                        StatsView(companion: companion)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    // Reset button (debug)
                    Button(role: .destructive) {
                        store.deleteSoul()
                    } label: {
                        Label("Release companion", systemImage: "arrow.uturn.backward")
                            .font(.caption)
                    }
                    .buttonStyle(.bordered)
                    .padding(.top, 8)

                } else {
                    HatchView(store: store)
                }
            }
            .padding()
        }
    }
}

// MARK: - Quips
// A small pool of personality-flavoured quips triggered on pet.
private func randomQuip(for companion: Companion) -> String {
    let quips: [String]
    let chaos = companion.stats[.chaos] ?? 50
    let snark = companion.stats[.snark] ?? 50
    let wisdom = companion.stats[.wisdom] ?? 50

    if chaos > 70 {
        quips = ["chaos is my love language", "have you tried rm -rf?", "I rewrote it in Rust. Again."]
    } else if snark > 70 {
        quips = ["oh, you think that compiles?", "10 errors. Nice.", "have you checked Stack Overflow?"]
    } else if wisdom > 70 {
        quips = ["the code is the documentation", "simplicity is the ultimate sophistication", "ship it 🚢"]
    } else {
        quips = ["mrrph.", "...", "pat received.", "✓"]
    }
    return quips.randomElement() ?? "mrrph."
}

#Preview {
    CompanionCardView(store: CompanionStore())
}
