import SwiftUI

/// Recently Viewed screen — placeholder until Phase 7.
struct RecentlyViewedView: View {
    let coordinator: RecentlyViewedCoordinator

    var body: some View {
        EmptyStateView(
            title: "Recently Viewed",
            message: "Auto-recorded history coming in Phase 7.",
            systemImageName: "clock.fill"
        )
        .navigationTitle("Recently Viewed")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        RecentlyViewedView(coordinator: RecentlyViewedCoordinator(
            movieRepository: PreviewMovieRepository(),
            bookmarkRepository: PreviewBookmarkRepository(),
            recentlyViewedRepository: PreviewRecentlyViewedRepository()
        ))
    }
}
