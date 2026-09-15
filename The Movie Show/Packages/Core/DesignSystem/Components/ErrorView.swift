import SwiftUI

/// Full-screen error state rendered when a ViewModel is in the `.failed` state.
struct ErrorView: View {
    let error: AppError
    let onRetry: (() -> Void)?

    init(error: AppError, onRetry: (() -> Void)? = nil) {
        self.error = error
        self.onRetry = onRetry
    }

    var body: some View {
        VStack(spacing: Spacing.large) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 52))
                .foregroundStyle(Color.App.warning)

            VStack(spacing: Spacing.xSmall) {
                Text("Something went wrong")
                    .font(Font.App.headline)
                    .foregroundStyle(Color.App.primaryText)

                Text(error.localizedDescription)
                    .font(Font.App.subheadline)
                    .foregroundStyle(Color.App.secondaryText)
                    .multilineTextAlignment(.center)
            }

            if let onRetry {
                Button("Try Again", action: onRetry)
                    .buttonStyle(.borderedProminent)
                    .accessibilityHint("Retries the failed request")
            }
        }
        .padding(Spacing.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.App.background)
    }
}

#Preview {
    ErrorView(error: .networkUnavailable) { }
}
