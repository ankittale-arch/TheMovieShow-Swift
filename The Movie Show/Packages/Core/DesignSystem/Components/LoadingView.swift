import SwiftUI

/// Full-screen loading indicator used while a ViewModel is in the `.loading` state.
struct LoadingView: View {
    var message: String = "Loading…"

    var body: some View {
        VStack(spacing: Spacing.medium) {
            ProgressView()
                .scaleEffect(1.4)
            Text(message)
                .font(Font.App.subheadline)
                .foregroundStyle(Color.App.secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.App.background)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(message)
    }
}

#Preview {
    LoadingView()
}
