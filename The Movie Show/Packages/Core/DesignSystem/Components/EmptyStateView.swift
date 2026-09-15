import SwiftUI

/// Full-screen empty state rendered when a ViewModel is in the `.empty` state.
struct EmptyStateView: View {
    let title: String
    let message: String
    let systemImageName: String
    let actionTitle: String?
    let action: (() -> Void)?

    init(
        title: String,
        message: String,
        systemImageName: String = "film",
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.systemImageName = systemImageName
        self.actionTitle = actionTitle
        self.action = action
    }

    var body: some View {
        VStack(spacing: Spacing.large) {
            Image(systemName: systemImageName)
                .font(.system(size: 64))
                .foregroundStyle(Color.App.secondaryText)
                .accessibilityHidden(true)

            VStack(spacing: Spacing.xSmall) {
                Text(title)
                    .font(Font.App.headline)
                    .foregroundStyle(Color.App.primaryText)

                Text(message)
                    .font(Font.App.subheadline)
                    .foregroundStyle(Color.App.secondaryText)
                    .multilineTextAlignment(.center)
            }

            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding(Spacing.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.App.background)
    }
}

#Preview {
    EmptyStateView(
        title: "No Movies Found",
        message: "Try adjusting your search or browse by category.",
        systemImageName: "film",
        actionTitle: "Browse Movies",
        action: {}
    )
}
