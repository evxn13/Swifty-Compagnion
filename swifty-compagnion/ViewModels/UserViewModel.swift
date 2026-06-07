// ViewModel

import Foundation
import Combine

@MainActor
final class UserViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    /// déclenche la navigation vers la 2ᵉ vue
    @Published var loadedUser: User?

    func search(login: String) async {
        let trimmed = login.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            errorMessage = APIError.invalidLogin.errorDescription
            return
        }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            loadedUser = try await APIService.shared.fetchUser(login: trimmed)
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = APIError.unknown.errorDescription
        }
    }

    func reset() {
        loadedUser = nil
        errorMessage = nil
    }
}
