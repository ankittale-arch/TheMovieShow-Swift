import SwiftUI

extension Color {
    /// App-level colour tokens backed by iOS semantic system colours.
    /// Automatically adapts to light / dark mode — no asset catalogue entries needed.
    enum App {
        // Backgrounds
        static let background          = Color(.systemBackground)
        static let secondaryBackground = Color(.secondarySystemBackground)
        static let tertiaryBackground  = Color(.tertiarySystemBackground)
        static let groupedBackground   = Color(.systemGroupedBackground)

        // Text
        static let primaryText    = Color(.label)
        static let secondaryText  = Color(.secondaryLabel)
        static let tertiaryText   = Color(.tertiaryLabel)

        // Interactive
        static let accent = Color.accentColor

        // Semantic
        static let success = Color.green
        static let warning = Color.orange
        static let destructive = Color.red

        // Movie-specific
        static let ratingGold = Color(red: 1.0, green: 0.84, blue: 0.0)
        static let cardOverlay = Color.black.opacity(0.45)
        static let shimmer = Color(.systemFill)
    }
}
