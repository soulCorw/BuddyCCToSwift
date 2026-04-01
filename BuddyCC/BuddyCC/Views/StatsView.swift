import SwiftUI

// MARK: - StatsView
// Shows the five stats as animated progress bars with rarity color.

struct StatsView: View {
    let companion: Companion
    @State private var animateStats = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header: name + rarity
            HStack(alignment: .firstTextBaseline) {
                Text(companion.name)
                    .font(.title2.bold())
                Spacer()
                HStack(spacing: 4) {
                    Text(companion.rarity.stars)
                        .foregroundColor(companion.rarity.color)
                    Text(companion.rarity.rawValue.capitalized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            // Species + personality
            HStack(spacing: 6) {
                Text(companion.species.emoji)
                Text(companion.species.displayName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                if companion.shiny {
                    Text("✨ Shiny")
                        .font(.caption.bold())
                        .foregroundColor(.orange)
                }
            }

            Text(companion.personality)
                .font(.callout)
                .foregroundColor(.secondary)
                .italic()
                .fixedSize(horizontal: false, vertical: true)

            Divider()

            // Stat bars
            ForEach(StatName.allCases, id: \.self) { stat in
                StatRow(
                    stat: stat,
                    value: companion.stats[stat] ?? 0,
                    color: companion.rarity.color,
                    animate: animateStats
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.7, dampingFraction: 0.8)) {
                    animateStats = true
                }
            }
        }
    }
}

private struct StatRow: View {
    let stat: StatName
    let value: Int
    let color: Color
    let animate: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack {
                Text(stat.emoji)
                Text(stat.rawValue)
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(value)")
                    .font(.caption.monospacedDigit())
                    .foregroundColor(color)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemFill))
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: animate ? geo.size.width * CGFloat(value) / 100.0 : 0, height: 6)
                }
            }
            .frame(height: 6)
        }
    }
}

#Preview {
    let bones = CompanionBones(
        rarity: .epic, species: .axolotl,
        eye: .sparkle, hat: .halo,
        shiny: false,
        stats: [.debugging: 88, .patience: 12, .chaos: 72, .wisdom: 55, .snark: 40]
    )
    let soul = CompanionSoul(name: "Bubbles", personality: "An ancient water spirit who writes perfect unit tests.", hatchedAt: Date())
    return StatsView(companion: Companion(bones: bones, soul: soul))
        .padding()
}
