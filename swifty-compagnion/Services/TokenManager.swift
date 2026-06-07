// Token OAuth2

import Foundation

actor TokenManager {
    static let shared = TokenManager()

    private struct StoredToken: Codable {
        let accessToken: String
        let expiresAt: Date
    }

    private struct TokenResponse: Decodable {
        let accessToken: String
        let expiresIn: Int
        let createdAt: Int

        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case expiresIn = "expires_in"
            case createdAt = "created_at"
        }
    }

    private let tokenURL = URL(string: "https://api.intra.42.fr/oauth/token")!
    private let keychainService = "com.swiftycompanion.token"
    private let keychainAccount = "oauth2"

    private var cached: StoredToken?

    private init() {
        // recharge le token persistant au démarrage
        if let data = KeychainHelper.read(service: keychainService, account: keychainAccount),
           let stored = try? JSONDecoder().decode(StoredToken.self, from: data) {
            cached = stored
        }
    }

    // token valide, refresh si besoin (marge 60s)
    func validToken() async throws -> String {
        if let cached, cached.expiresAt > Date().addingTimeInterval(60) {
            return cached.accessToken
        }
        return try await refreshToken()
    }

    @discardableResult
    func refreshToken() async throws -> String {
        guard Secrets.isConfigured else { throw APIError.missingCredentials }

        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded",
                         forHTTPHeaderField: "Content-Type")

        let body = [
            "grant_type=client_credentials",
            "client_id=\(Secrets.uid)",
            "client_secret=\(Secrets.secret)",
        ].joined(separator: "&")
        request.httpBody = body.data(using: .utf8)

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw APIError.network
        }

        guard let http = response as? HTTPURLResponse else { throw APIError.unknown }
        switch http.statusCode {
        case 200:
            break
        case 401, 403:
            throw APIError.unauthorized
        case 429:
            throw APIError.rateLimited
        default:
            throw APIError.server(http.statusCode)
        }

        guard let token = try? JSONDecoder().decode(TokenResponse.self, from: data) else {
            throw APIError.decoding
        }

        let stored = StoredToken(
            accessToken: token.accessToken,
            expiresAt: Date().addingTimeInterval(TimeInterval(token.expiresIn))
        )
        cached = stored

        if let encoded = try? JSONEncoder().encode(stored) {
            KeychainHelper.save(encoded, service: keychainService, account: keychainAccount)
        }
        return stored.accessToken
    }

    func invalidate() {
        cached = nil
        KeychainHelper.delete(service: keychainService, account: keychainAccount)
    }
}
