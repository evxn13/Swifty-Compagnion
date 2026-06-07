// Erreurs API

import Foundation

enum APIError: LocalizedError {
    case missingCredentials
    case invalidLogin
    case network
    case userNotFound
    case unauthorized
    case rateLimited
    case decoding
    case server(Int)
    case unknown

    var errorDescription: String? {
        switch self {
        case .missingCredentials:
            return "Missing API credentials. Check your .env file (UID / SECRET)."
        case .invalidLogin:
            return "Please enter a valid login."
        case .network:
            return "Network error. Check your internet connection and try again."
        case .userNotFound:
            return "This login does not exist on the 42 intra."
        case .unauthorized:
            return "Authentication failed. Please verify your API credentials."
        case .rateLimited:
            return "Too many requests. Please wait a moment and try again."
        case .decoding:
            return "Unexpected response from the server."
        case .server(let code):
            return "Server error (\(code)). Please try again later."
        case .unknown:
            return "An unexpected error occurred."
        }
    }
}
