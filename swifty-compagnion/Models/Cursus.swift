// Cursus

import Foundation

struct CursusUser: Codable, Hashable {
    let level: Double
    let skills: [Skill]
    let cursus: Cursus
}

struct Cursus: Codable, Hashable {
    let id: Int
    let name: String
    let slug: String?
}
