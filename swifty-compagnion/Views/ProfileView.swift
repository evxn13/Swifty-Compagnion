// Vue 2

import SwiftUI

struct ProfileView: View {
    let user: User

    @State private var showConfetti = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                header
                infoSection
                levelSection
                skillsSection
                projectsSection
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(user.login)
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if showConfetti {
                ConfettiView()
            }
        }
        .onAppear {
            showConfetti = true
            // retire après l'animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                showConfetti = false
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 12) {
            AsyncImage(url: user.imageURL) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure:
                    placeholderAvatar
                case .empty:
                    ProgressView()
                @unknown default:
                    placeholderAvatar
                }
            }
            .frame(width: 130, height: 130)
            .clipShape(Circle())
            .overlay(Circle().stroke(.tint, lineWidth: 3))
            .shadow(radius: 4)

            Text(user.displayname ?? user.login)
                .font(.title2.bold())
            Text("@\(user.login)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top)
    }

    private var placeholderAvatar: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .scaledToFit()
            .foregroundStyle(.secondary)
    }

    // MARK: - Infos

    private var infoSection: some View {
        Card(title: "Information") {
            InfoRow(icon: "envelope.fill", label: "Email", value: user.email)
            Divider()
            InfoRow(icon: "phone.fill", label: "Mobile", value: user.phoneDisplay)
            Divider()
            InfoRow(icon: "location.fill", label: "Location", value: user.locationDisplay)
            Divider()
            InfoRow(icon: "creditcard.fill", label: "Wallet",
                    value: "\(user.wallet ?? 0) ₳")
            Divider()
            InfoRow(icon: "checkmark.seal.fill", label: "Eval. points",
                    value: "\(user.correctionPoint ?? 0)")
        }
    }

    // MARK: - Niveau

    private var levelSection: some View {
        Card(title: "Level") {
            HStack {
                Text(String(format: "Level %.2f", user.level))
                    .font(.headline)
                Spacer()
                Text(String(format: "%.0f%%",
                            (user.level - user.level.rounded(.down)) * 100))
                    .foregroundStyle(.secondary)
            }
            ProgressView(value: user.level - user.level.rounded(.down), total: 1)
                .tint(.accentColor)
        }
    }

    // MARK: - Skills

    private var skillsSection: some View {
        Card(title: "Skills") {
            if user.skills.isEmpty {
                emptyLabel("No skills to display.")
            } else {
                ForEach(user.skills) { skill in
                    SkillRow(skill: skill)
                }
            }
        }
    }

    // MARK: - Projets

    private var projectsSection: some View {
        Card(title: "Projects (\(user.finishedProjects.count))") {
            if user.finishedProjects.isEmpty {
                emptyLabel("No finished projects to display.")
            } else {
                ForEach(user.finishedProjects) { project in
                    ProjectRow(project: project)
                    if project.id != user.finishedProjects.last?.id {
                        Divider()
                    }
                }
            }
        }
    }

    private func emptyLabel(_ text: String) -> some View {
        Text(text)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Card

private struct Card<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .padding(.bottom, 2)
            content
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground),
                    in: RoundedRectangle(cornerRadius: 16))
    }
}
