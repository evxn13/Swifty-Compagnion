// Skill

import Foundation

struct Skill: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let level: Double

    // progression vers le niveau suivant (partie décimale)
    var percentage: Double {
        (level - level.rounded(.down)) * 100
    }
}
