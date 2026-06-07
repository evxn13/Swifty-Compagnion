// Project

import Foundation

struct ProjectUser: Codable, Identifiable, Hashable {
    let id: Int
    let finalMark: Int?
    let status: String
    let validated: Bool?
    let project: ProjectInfo

    enum CodingKeys: String, CodingKey {
        case id, status, project
        case finalMark = "final_mark"
        case validated = "validated?"   // clé JSON avec "?"
    }

    var name: String { project.name }
    var isValidated: Bool? { validated }
    var markDisplay: String { finalMark.map { "\($0)" } ?? "—" }
}

struct ProjectInfo: Codable, Hashable {
    let id: Int
    let name: String
    let slug: String?
}
