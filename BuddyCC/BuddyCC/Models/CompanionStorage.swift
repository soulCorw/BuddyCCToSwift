import Foundation
import Combine

// MARK: - CompanionStore
// ObservableObject that mirrors the config.companion pattern from the original.
// Bones are never persisted — regenerated from hash(userId) on every read
// so species renames can't break stored companions, and users can't fake rarity.

@MainActor
final class CompanionStore: ObservableObject {
    static let shared = CompanionStore()

    @Published private(set) var companion: Companion?
    @Published private(set) var isHatching = false

    private let soulKey = "buddy.companion.soul"
    private let userIdKey = "buddy.userId"

    // Default to a stable anonymous ID; replaced when real auth is available.
    var userId: String {
        get {
            if let id = UserDefaults.standard.string(forKey: userIdKey) { return id }
            let new = UUID().uuidString
            UserDefaults.standard.set(new, forKey: userIdKey)
            return new
        }
        set { UserDefaults.standard.set(newValue, forKey: userIdKey) }
    }

    init() {
        reload()
    }

    /// Reload companion from stored soul + freshly-computed bones.
    func reload() {
        guard let data = UserDefaults.standard.data(forKey: soulKey),
              let soul = try? JSONDecoder().decode(CompanionSoul.self, from: data)
        else {
            companion = nil
            return
        }
        let result = rollCompanion(userId: userId)
        companion = Companion(bones: result.bones, soul: soul)
    }

    /// Persist a newly-generated soul (called after LLM soul generation).
    func saveSoul(_ soul: CompanionSoul) {
        guard let data = try? JSONEncoder().encode(soul) else { return }
        UserDefaults.standard.set(data, forKey: soulKey)
        reload()
    }

    /// Remove companion — used for reset/debug.
    func deleteSoul() {
        UserDefaults.standard.removeObject(forKey: soulKey)
        companion = nil
    }

    /// Peek at bones without requiring a soul (used during hatch preview).
    var previewBones: CompanionBones {
        rollCompanion(userId: userId).bones
    }
}
