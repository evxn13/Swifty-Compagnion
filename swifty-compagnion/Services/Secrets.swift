// Secrets, .env

import Foundation

nonisolated enum Secrets {
    private static let values: [String: String] = {
        guard let url = Bundle.main.url(forResource: ".env", withExtension: nil)
                ?? Bundle.main.url(forResource: "env", withExtension: nil),
              let content = try? String(contentsOf: url, encoding: .utf8)
        else {
            print("⚠️ .env introuvable, crée-le (UID/SECRET)")
            return [:]
        }

        var dict: [String: String] = [:]
        for rawLine in content.split(whereSeparator: \.isNewline) {
            let line = rawLine.trimmingCharacters(in: .whitespaces)
            guard !line.isEmpty, !line.hasPrefix("#"),
                  let eq = line.firstIndex(of: "=") else { continue }

            let key = String(line[..<eq]).trimmingCharacters(in: .whitespaces)
            var value = String(line[line.index(after: eq)...])
                .trimmingCharacters(in: .whitespaces)
            value = value.trimmingCharacters(in: CharacterSet(charactersIn: "\"'"))
            dict[key] = value
        }
        return dict
    }()

    static var uid: String { values["UID"] ?? "" }
    static var secret: String { values["SECRET"] ?? "" }
    static var isConfigured: Bool { !uid.isEmpty && !secret.isEmpty }
}
