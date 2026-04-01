import SwiftUI

// MARK: - SpeechBubbleView
// Mirrors the SpeechBubble + bubble ticker logic in CompanionSprite.tsx.
// Shown for ~10s, dims in the last 3s before disappearing.

private let bubbleShowTicks = 20   // ~10s at 500ms
private let fadeWindowTicks = 6    // last ~3s

struct SpeechBubbleView: View {
    let text: String
    let color: Color
    var onDismiss: (() -> Void)? = nil

    @State private var ticksRemaining = bubbleShowTicks
    @State private var timer: Timer?

    private var isFading: Bool { ticksRemaining <= fadeWindowTicks }
    private var opacity: Double { isFading ? Double(ticksRemaining) / Double(fadeWindowTicks) : 1.0 }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(text)
                .font(.system(.footnote, design: .rounded))
                .italic()
                .foregroundColor(isFading ? .secondary : .primary)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: 200, alignment: .leading)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.secondarySystemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(isFading ? Color.secondary.opacity(0.3) : color.opacity(0.6), lineWidth: 1.5)
                )
        )
        .opacity(opacity)
        .animation(.easeInOut(duration: 0.3), value: opacity)
        // Tail triangle pointing down
        .overlay(alignment: .bottom) {
            Triangle()
                .fill(Color(.secondarySystemBackground))
                .frame(width: 14, height: 8)
                .offset(y: 7)
        }
        .onAppear { startTimer() }
        .onDisappear { timer?.invalidate() }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            if ticksRemaining > 0 {
                ticksRemaining -= 1
            } else {
                timer?.invalidate()
                onDismiss?()
            }
        }
    }
}

// Small triangle for speech bubble tail
private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            p.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            p.closeSubpath()
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        SpeechBubbleView(text: "I found a segfault in your future. You're welcome.", color: .purple)
        SpeechBubbleView(text: "Mrrph.", color: .green)
    }
    .padding()
}
