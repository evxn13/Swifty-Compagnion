// User

import Foundation

struct User: Codable, Identifiable, Hashable {
    let id: Int
    let login: String
    let email: String
    let displayname: String?
    let phone: String?
    let wallet: Int?
    let correctionPoint: Int?
    let location: String?
    let image: UserImage?
    let cursusUsers: [CursusUser]
    let projectsUsers: [ProjectUser]

    enum CodingKeys: String, CodingKey {
        case id, login, email, displayname, phone, wallet, location, image
        case correctionPoint = "correction_point"
        case cursusUsers = "cursus_users"
        case projectsUsers = "projects_users"
    }

    // 42cursus (id 21), sinon le niveau le plus haut
    var mainCursus: CursusUser? {
        cursusUsers.first { $0.cursus.id == 21 }
            ?? cursusUsers.max { $0.level < $1.level }
    }

    var level: Double { mainCursus?.level ?? 0 }

    var skills: [Skill] {
        (mainCursus?.skills ?? []).sorted { $0.level > $1.level }
    }

    // projets terminés (réussis + échoués)
    var finishedProjects: [ProjectUser] {
        projectsUsers
            .filter { $0.status == "finished" }
            .sorted { ($0.finalMark ?? 0) > ($1.finalMark ?? 0) }
    }

    var imageURL: URL? {
        let raw = image?.versions?.medium ?? image?.link
        guard let raw, !raw.isEmpty else { return nil }
        return URL(string: raw)
    }

    var phoneDisplay: String { phone?.isEmpty == false ? phone! : "hidden" }
    var locationDisplay: String { location?.isEmpty == false ? location! : "Unavailable" }
}

struct UserImage: Codable, Hashable {
    let link: String?
    let versions: Versions?

    struct Versions: Codable, Hashable {
        let large: String?
        let medium: String?
        let small: String?
        let micro: String?
    }
}
