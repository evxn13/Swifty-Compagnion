// API 42

import Foundation

struct APIService {
    static let shared = APIService()

    private let baseURL = "https://api.intra.42.fr/v2"

    // profil par login. refresh token sur 401 (bonus)
    func fetchUser(login: String) async throws -> User {
        let cleaned = login.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !cleaned.isEmpty else { throw APIError.invalidLogin }

        do {
            let token = try await TokenManager.shared.validToken()
            return try await performFetch(login: cleaned, token: token)
        } catch APIError.unauthorized {
            // token expiré → refresh une fois
            let freshToken = try await TokenManager.shared.refreshToken()
            return try await performFetch(login: cleaned, token: freshToken)
        }
    }

    private func performFetch(login: String, token: String) async throws -> User {
        guard let encoded = login.addingPercentEncoding(
                withAllowedCharacters: .urlPathAllowed),
              let url = URL(string: "\(baseURL)/users/\(encoded)") else {
            throw APIError.invalidLogin
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw APIError.network
        }

        guard let http = response as? HTTPURLResponse else { throw APIError.unknown }
        switch http.statusCode {
        case 200:
            do {
                return try JSONDecoder().decode(User.self, from: data)
            } catch {
                throw APIError.decoding
            }
        case 401:
            throw APIError.unauthorized
        case 404:
            throw APIError.userNotFound
        case 429:
            throw APIError.rateLimited
        default:
            throw APIError.server(http.statusCode)
        }
    }
}
