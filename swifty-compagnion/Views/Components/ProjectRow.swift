// ProjectRow

import SwiftUI

struct ProjectRow: View {
    let project: ProjectUser

    private var isPassed: Bool { project.isValidated ?? false }

    var body: some View {
        HStack {
            Image(systemName: isPassed ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundStyle(isPassed ? .green : .red)

            Text(project.name)
                .font(.subheadline)
                .lineLimit(1)

            Spacer()

            Text(project.markDisplay)
                .font(.subheadline.monospacedDigit())
                .fontWeight(.semibold)
                .foregroundStyle(isPassed ? .green : .red)
        }
        .padding(.vertical, 4)
    }
}
