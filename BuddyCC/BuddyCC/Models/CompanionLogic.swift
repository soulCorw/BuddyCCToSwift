import Foundation

// MARK: - Mulberry32 PRNG
// Direct port of companion.ts mulberry32 — same seed produces same companion

private func mulberry32(seed: UInt32) -> () -> Double {
    var a = seed
    return {
        a = a &+ 0x6d2b79f5
        var t = (a ^ (a >> 15)) &* (1 | a)
        t = (t &+ ((t ^ (t >> 7)) &* (61 | t))) ^ t
        return Double(t ^ (t >> 14)) / 4294967296.0
    }
}

// MARK: - FNV-1a Hash
// Matches the non-Bun fallback branch in companion.ts hashString()

private func hashString(_ s: String) -> UInt32 {
    var h: UInt32 = 2166136261
    for byte in s.utf8 {
        h ^= UInt32(byte)
        h = h &* 16777619
    }
    return h
}

// MARK: - Roll helpers

private func pick<T>(_ rng: () -> Double, _ arr: [T]) -> T {
    arr[Int(rng() * Double(arr.count))]
}

private func rollRarity(_ rng: () -> Double) -> Rarity {
    let total = Double(Rarity.allCases.map(\.weight).reduce(0, +))
    var roll = rng() * total
    for rarity in Rarity.allCases {
        roll -= Double(rarity.weight)
        if roll < 0 { return rarity }
    }
    return .common
}

private func rollStats(_ rng: () -> Double, rarity: Rarity) -> Stats {
    let floor = rarity.statFloor
    let all = StatName.allCases
    let peak = pick(rng, all)
    var dump = pick(rng, all)
    while dump == peak { dump = pick(rng, all) }

    var stats = Stats()
    for name in all {
        if name == peak {
            stats[name] = min(100, floor + 50 + Int(rng() * 30))
        } else if name == dump {
            stats[name] = max(1, floor - 10 + Int(rng() * 15))
        } else {
            stats[name] = floor + Int(rng() * 40)
        }
    }
    return stats
}

// MARK: - Public API

private let salt = "friend-2026-401"

struct CompanionRoll {
    let bones: CompanionBones
    let inspirationSeed: Int
}

/// Deterministic roll — same userId always produces the same companion.
/// Mirrors companion.ts roll(userId) exactly.
func rollCompanion(userId: String) -> CompanionRoll {
    let key = userId + salt
    let rng = mulberry32(seed: hashString(key))

    let rarity  = rollRarity(rng)
    let species = pick(rng, Species.allCases)
    let eye     = pick(rng, Eye.allCases)
    let hat: Hat = rarity == .common ? .none : pick(rng, Hat.allCases)
    let shiny   = rng() < 0.01
    let stats   = rollStats(rng, rarity: rarity)

    let bones = CompanionBones(
        rarity: rarity,
        species: species,
        eye: eye,
        hat: hat,
        shiny: shiny,
        stats: stats
    )
    return CompanionRoll(bones: bones, inspirationSeed: Int(rng() * 1e9))
}
