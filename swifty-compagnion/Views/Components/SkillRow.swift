// SkillRow

import SwiftUI

struct SkillRow: View {
    let skill: Skill

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(skill.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                Text(String(format: "%.2f (%.0f%%)", skill.level, skill.percentage))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            ProgressView(value: skill.percentage, total: 100)
                .tint(.accentColor)
        }
        .padding(.vertical, 4)
    }
}
