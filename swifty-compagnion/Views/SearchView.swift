// Vue 1

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = UserViewModel()
    @State private var login = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "person.crop.circle.badge.questionmark")
                    .font(.system(size: 64))
                    .foregroundStyle(.tint)

                Text("Swifty Companion")
                    .font(.largeTitle.bold())

                Text("Search for a 42 student by their login.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                VStack(spacing: 12) {
                    TextField("login (e.g. evscheid)", text: $login)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .submitLabel(.search)
                        .focused($isFocused)
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        .onSubmit(performSearch)

                    Button(action: performSearch) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "magnifyingglass")
                            }
                            Text(viewModel.isLoading ? "Searching…" : "Search")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.tint, in: RoundedRectangle(cornerRadius: 12))
                        .foregroundStyle(.white)
                    }
                    .disabled(viewModel.isLoading ||
                              login.trimmingCharacters(in: .whitespaces).isEmpty)
                }

                if let error = viewModel.errorMessage {
                    Label(error, systemImage: "exclamationmark.triangle.fill")
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .transition(.opacity)
                }

                Spacer()
                Spacer()
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))
            .navigationDestination(item: $viewModel.loadedUser) { user in
                ProfileView(user: user)
            }
            .animation(.default, value: viewModel.errorMessage)
        }
    }

    private func performSearch() {
        isFocused = false
        Task { await viewModel.search(login: login) }
    }
}

#Preview {
    SearchView()
}
