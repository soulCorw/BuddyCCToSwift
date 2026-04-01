import Foundation

// MARK: - SoulGenerator
// Calls the Anthropic Messages API once at hatch time to generate
// the companion's name and personality.
// Replace ANTHROPIC_API_KEY with a real key or inject via config.

enum SoulGeneratorError: LocalizedError {
    case missingAPIKey
    case networkError(Error)
    case badResponse(Int)
    case parseError

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:      return "Anthropic API key is not set."
        case .networkError(let e): return "Network error: \(e.localizedDescription)"
        case .badResponse(let c): return "API returned status \(c)."
        case .parseError:         return "Could not parse API response."
        }
    }
}

struct SoulGenerator {
    // Store your key in Info.plist as ANTHROPIC_API_KEY,
    // or replace this line with a direct string for local testing.
    static var apiKey: String {
        Bundle.main.infoDictionary?["ANTHROPIC_API_KEY"] as? String ?? ""
    }

    /// Generate name + personality for the given bones.
    /// Falls back to offline procedural generation when no API key is set.
    static func generate(bones: CompanionBones) async throws -> CompanionSoul {
        guard !apiKey.isEmpty else {
            return generateOffline(bones: bones)
        }

        let prompt = buildPrompt(bones: bones)

        let url = URL(string: "https://api.anthropic.com/v1/messages")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")

        let body: [String: Any] = [
            "model": "claude-3-5-haiku-latest",
            "max_tokens": 200,
            "messages": [["role": "user", "content": prompt]],
            "system": systemPrompt,
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw SoulGeneratorError.networkError(error)
        }

        if let http = response as? HTTPURLResponse, http.statusCode != 200 {
            throw SoulGeneratorError.badResponse(http.statusCode)
        }

        return try parseSoul(from: data, bones: bones)
    }

    // MARK: - Private

    private static let systemPrompt = """
    You are hatching a tiny companion for a developer. \
    Respond ONLY with a JSON object — no markdown, no prose:
    {"name": "...", "personality": "..."}
    The name should be short (1–2 words). \
    The personality should be one vivid sentence capturing the creature's essence.
    """

    private static func buildPrompt(bones: CompanionBones) -> String {
        let statSummary = StatName.allCases
            .compactMap { s -> String? in
                guard let v = bones.stats[s] else { return nil }
                return "\(s.rawValue) \(v)"
            }
            .joined(separator: ", ")

        return """
        Hatch a \(bones.rarity.rawValue) \(bones.species.rawValue)\
        \(bones.shiny ? " (shiny!)" : ""). \
        Eyes: \(bones.eye.rawValue). Hat: \(bones.hat.rawValue). \
        Stats: \(statSummary).
        """
    }

    // MARK: - Offline fallback
    // Procedurally generates a name + personality when no API key is available.
    // Uses the same PRNG seed as bones generation for consistency.
    static func generateOffline(bones: CompanionBones) -> CompanionSoul {
        let prefixes = ["Sir", "Lady", "Lord", "Dr.", "Prof.", "Captain", "Agent", ""]
        let namesBySpecies: [Species: [String]] = [
            .duck:     ["Quackers", "Puddle", "Ducky", "Waddles"],
            .goose:    ["Honk", "Greg", "Gerald", "Untitled"],
            .blob:     ["Blobby", "Goo", "Squish", "Gelatin"],
            .cat:      ["Mittens", "Whiskers", "Shadow", "Biscuit"],
            .dragon:   ["Ember", "Scorch", "Cinder", "Blaze"],
            .octopus:  ["Ink", "Tentacle", "Squirtle", "Cephalopod"],
            .owl:      ["Hoot", "Talon", "Archimedes", "Nightwing"],
            .penguin:  ["Tux", "Waddle", "Pebble", "Freeze"],
            .turtle:   ["Shell", "Pebble", "Mossy", "Slowpoke"],
            .snail:    ["Slime", "Spiral", "Tempo", "Escargot"],
            .ghost:    ["Boo", "Wisp", "Phantom", "Vapor"],
            .axolotl:  ["Gill", "Bubbles", "Axel", "Lotl"],
            .capybara: ["Capy", "Rodney", "Chill", "Cappy"],
            .cactus:   ["Spike", "Prick", "Sandy", "Needles"],
            .robot:    ["Unit-7", "Bleep", "Cortex", "Servo"],
            .rabbit:   ["Bun", "Flop", "Thumper", "Clover"],
            .mushroom: ["Spore", "Fungi", "Mycelium", "Cap"],
            .chonk:    ["Beef", "Chonky", "Thicc", "Rotund"],
        ]
        let personalitiesByRarity: [Rarity: [String]] = [
            .common:    ["Cheerfully breaks things and calls it a feature.", "Reliably mediocre, consistently lovable."],
            .uncommon:  ["Has strong opinions about tab width.", "Mysteriously solves bugs by staring at them."],
            .rare:      ["Writes unit tests for fun on weekends.", "Once fixed a production bug in their sleep."],
            .epic:      ["Can read stack traces like poetry.", "Refactored legacy spaghetti into elegant soup."],
            .legendary: ["Achieved enlightenment through a rubber duck debug session.", "Their pull requests have zero comments because they're already perfect."],
        ]

        let names = namesBySpecies[bones.species] ?? ["Buddy"]
        let name: String
        if let prefix = prefixes.randomElement(), !prefix.isEmpty,
           let base = names.randomElement() {
            name = "\(prefix) \(base)"
        } else {
            name = names.randomElement() ?? "Buddy"
        }

        let personalities = personalitiesByRarity[bones.rarity] ?? ["A loyal companion."]
        let personality = personalities.randomElement() ?? "A loyal companion."

        return CompanionSoul(name: name, personality: personality, hatchedAt: Date())
    }

    private static func parseSoul(from data: Data, bones: CompanionBones) throws -> CompanionSoul {
        guard
            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            let content = json["content"] as? [[String: Any]],
            let text = content.first?["text"] as? String,
            let inner = text.data(using: .utf8),
            let parsed = try? JSONSerialization.jsonObject(with: inner) as? [String: Any],
            let name = parsed["name"] as? String,
            let personality = parsed["personality"] as? String
        else {
            throw SoulGeneratorError.parseError
        }

        return CompanionSoul(
            name: name,
            personality: personality,
            hatchedAt: Date()
        )
    }
}
