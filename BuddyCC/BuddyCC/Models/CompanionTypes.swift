import SwiftUI

// MARK: - Rarity

enum Rarity: String, CaseIterable, Codable {
    case common, uncommon, rare, epic, legendary

    var weight: Int {
        switch self {
        case .common:    return 60
        case .uncommon:  return 25
        case .rare:      return 10
        case .epic:      return 4
        case .legendary: return 1
        }
    }

    var statFloor: Int {
        switch self {
        case .common:    return 5
        case .uncommon:  return 15
        case .rare:      return 25
        case .epic:      return 35
        case .legendary: return 50
        }
    }

    var stars: String {
        switch self {
        case .common:    return "★"
        case .uncommon:  return "★★"
        case .rare:      return "★★★"
        case .epic:      return "★★★★"
        case .legendary: return "★★★★★"
        }
    }

    var color: Color {
        switch self {
        case .common:    return .gray
        case .uncommon:  return .green
        case .rare:      return .blue
        case .epic:      return .purple
        case .legendary: return .orange
        }
    }
}

// MARK: - Species

enum Species: String, CaseIterable, Codable {
    case duck, goose, blob, cat, dragon, octopus
    case owl, penguin, turtle, snail, ghost, axolotl
    case capybara, cactus, robot, rabbit, mushroom, chonk

    var displayName: String { rawValue.capitalized }
    var emoji: String {
        switch self {
        case .duck:     return "🦆"
        case .goose:    return "🪿"
        case .blob:     return "🫧"
        case .cat:      return "🐱"
        case .dragon:   return "🐲"
        case .octopus:  return "🐙"
        case .owl:      return "🦉"
        case .penguin:  return "🐧"
        case .turtle:   return "🐢"
        case .snail:    return "🐌"
        case .ghost:    return "👻"
        case .axolotl:  return "🦎"
        case .capybara: return "🦫"
        case .cactus:   return "🌵"
        case .robot:    return "🤖"
        case .rabbit:   return "🐰"
        case .mushroom: return "🍄"
        case .chonk:    return "🐾"
        }
    }
}

// MARK: - Eye & Hat

enum Eye: String, CaseIterable, Codable {
    case dot     = "·"
    case sparkle = "✦"
    case cross   = "×"
    case circle  = "◉"
    case at      = "@"
    case degree  = "°"

    var character: String { rawValue }
}

enum Hat: String, CaseIterable, Codable {
    case none, crown, tophat, propeller, halo, wizard, beanie, tinyduck

    var displayName: String {
        switch self {
        case .none:      return "None"
        case .crown:     return "Crown"
        case .tophat:    return "Top Hat"
        case .propeller: return "Propeller"
        case .halo:      return "Halo"
        case .wizard:    return "Wizard Hat"
        case .beanie:    return "Beanie"
        case .tinyduck:  return "Tiny Duck"
        }
    }
}

// MARK: - Stats

enum StatName: String, CaseIterable, Codable {
    case debugging = "DEBUGGING"
    case patience  = "PATIENCE"
    case chaos     = "CHAOS"
    case wisdom    = "WISDOM"
    case snark     = "SNARK"

    var emoji: String {
        switch self {
        case .debugging: return "🐛"
        case .patience:  return "⏳"
        case .chaos:     return "🌀"
        case .wisdom:    return "🧠"
        case .snark:     return "💬"
        }
    }
}

typealias Stats = [StatName: Int]

// MARK: - Companion Data Models

/// Deterministic parts derived from hash(userId) — never stored
struct CompanionBones: Equatable {
    let rarity: Rarity
    let species: Species
    let eye: Eye
    let hat: Hat
    let shiny: Bool
    let stats: Stats
}

/// LLM-generated soul — stored in UserDefaults after first hatch
struct CompanionSoul: Codable {
    let name: String
    let personality: String
    let hatchedAt: Date
}

/// Full companion = bones (computed) + soul (stored)
struct Companion {
    let bones: CompanionBones
    let soul: CompanionSoul

    var name: String { soul.name }
    var personality: String { soul.personality }
    var rarity: Rarity { bones.rarity }
    var species: Species { bones.species }
    var eye: Eye { bones.eye }
    var hat: Hat { bones.hat }
    var shiny: Bool { bones.shiny }
    var stats: Stats { bones.stats }
}
